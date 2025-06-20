CREATE DATABASE skillshare_app;

-- \connect skillshare_app;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ENUMs
CREATE TYPE skill_type AS ENUM ('offer', 'learn');
CREATE TYPE skill_level AS ENUM ('beginner', 'intermediate', 'expert');
CREATE TYPE match_status AS ENUM ('pending', 'accepted', 'rejected', 'completed');
CREATE TYPE match_type AS ENUM ('trade', 'learn', 'mutual');
CREATE TYPE user_role AS ENUM ('user', 'moderator', 'admin');
CREATE TYPE notification_type AS ENUM ('match_request', 'message', 'review', 'system');

-- Locations table with lat/lon
CREATE TABLE locations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    city VARCHAR(100),
    region VARCHAR(100),
    country VARCHAR(100),
    latitude DECIMAL(9,6),
    longitude DECIMAL(9,6),
    timezone VARCHAR(100)
);

-- Users table (added role column)
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    bio TEXT,
    profile_pic_url TEXT,
    location_id UUID,
    social_auth_provider VARCHAR(50), -- e.g., 'google', 'github'
    role user_role DEFAULT 'user',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (location_id) REFERENCES locations(id) ON DELETE SET NULL
);

-- Skills (user-extensible)
CREATE TABLE skills (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL UNIQUE,
    category VARCHAR(100),
    created_by UUID,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL
);

-- Tags for skills
CREATE TABLE tags (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(50) UNIQUE NOT NULL
);

-- Many-to-many skill_tags linking table
CREATE TABLE skill_tags (
    skill_id UUID NOT NULL,
    tag_id UUID NOT NULL,
    PRIMARY KEY (skill_id, tag_id),
    FOREIGN KEY (skill_id) REFERENCES skills(id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE
);

-- User's skills
CREATE TABLE user_skills (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    skill_id UUID NOT NULL,
    type skill_type NOT NULL,
    level skill_level NOT NULL,
    description TEXT,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (skill_id) REFERENCES skills(id) ON DELETE CASCADE,
    UNIQUE(user_id, skill_id, type)
);

-- Matches (supports trade, learn, or mutual interest)
CREATE TABLE matches (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    initiator_id UUID NOT NULL,
    receiver_id UUID NOT NULL,
    initiator_skill_id UUID NOT NULL,
    receiver_skill_id UUID NOT NULL,
    match_type match_type DEFAULT 'trade',
    status match_status DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (initiator_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (receiver_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (initiator_skill_id) REFERENCES user_skills(id) ON DELETE CASCADE,
    FOREIGN KEY (receiver_skill_id) REFERENCES user_skills(id) ON DELETE CASCADE
);

-- Messages (threaded)
CREATE TABLE messages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    match_id UUID NOT NULL,
    sender_id UUID NOT NULL,
    content TEXT NOT NULL,
    reply_to_message_id UUID,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (match_id) REFERENCES matches(id) ON DELETE CASCADE,
    FOREIGN KEY (sender_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (reply_to_message_id) REFERENCES messages(id) ON DELETE SET NULL
);

-- Reviews
CREATE TABLE reviews (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    match_id UUID NOT NULL,
    reviewer_id UUID NOT NULL,
    reviewee_id UUID NOT NULL,
    skill_id UUID NOT NULL,
    rating INTEGER CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (match_id) REFERENCES matches(id) ON DELETE CASCADE,
    FOREIGN KEY (reviewer_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (reviewee_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (skill_id) REFERENCES skills(id) ON DELETE CASCADE
);

-- User availability
CREATE TABLE availability (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    day_of_week INTEGER CHECK (day_of_week BETWEEN 0 AND 6),
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    timezone VARCHAR(100) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Notifications table
CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    type notification_type NOT NULL,
    reference_id UUID, -- e.g., match_id, message_id, review_id depending on notification type
    content TEXT,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);


-- Dummy data

INSERT INTO locations (id, city, region, country, latitude, longitude, timezone) VALUES
  (gen_random_uuid(), 'New York', 'NY', 'USA', 40.712776, -74.005974, 'America/New_York'),
  (gen_random_uuid(), 'San Francisco', 'CA', 'USA', 37.774929, -122.419418, 'America/Los_Angeles'),
  (gen_random_uuid(), 'London', '', 'UK', 51.507351, -0.127758, 'Europe/London'),
  (gen_random_uuid(), 'Tokyo', '', 'Japan', 35.689487, 139.691711, 'Asia/Tokyo'),
  (gen_random_uuid(), 'Berlin', '', 'Germany', 52.520008, 13.404954, 'Europe/Berlin');

INSERT INTO users (id, name, email, bio, profile_pic_url, location_id, social_auth_provider, role) VALUES
  (gen_random_uuid(), 'Alice Johnson', 'alice@example.com', 'Love sharing my coding skills', NULL, (SELECT id FROM locations LIMIT 1 OFFSET 0), 'google', 'user'),
  (gen_random_uuid(), 'Bob Smith', 'bob@example.com', 'Designer and developer', NULL, (SELECT id FROM locations LIMIT 1 OFFSET 1), 'github', 'moderator'),
  (gen_random_uuid(), 'Carol White', 'carol@example.com', 'Beginner in photography', NULL, (SELECT id FROM locations LIMIT 1 OFFSET 2), NULL, 'user'),
  (gen_random_uuid(), 'David Black', 'david@example.com', 'Expert in guitar playing', NULL, (SELECT id FROM locations LIMIT 1 OFFSET 3), 'google', 'user'),
  (gen_random_uuid(), 'Eve Green', 'eve@example.com', 'Love to learn languages', NULL, (SELECT id FROM locations LIMIT 1 OFFSET 4), NULL, 'admin');

-- Pick a created_by user ID by querying users (replace with actual UUIDs after insert)
INSERT INTO skills (id, name, category, created_by) VALUES
  (gen_random_uuid(), 'Python Programming', 'Programming', (SELECT id FROM users WHERE name='Alice Johnson')),
  (gen_random_uuid(), 'Graphic Design', 'Design', (SELECT id FROM users WHERE name='Bob Smith')),
  (gen_random_uuid(), 'Photography', 'Art', (SELECT id FROM users WHERE name='Carol White')),
  (gen_random_uuid(), 'Guitar Playing', 'Music', (SELECT id FROM users WHERE name='David Black')),
  (gen_random_uuid(), 'Spanish Language', 'Languages', (SELECT id FROM users WHERE name='Eve Green'));

INSERT INTO tags (id, name) VALUES
  (gen_random_uuid(), 'tech'),
  (gen_random_uuid(), 'art'),
  (gen_random_uuid(), 'music'),
  (gen_random_uuid(), 'language'),
  (gen_random_uuid(), 'beginner-friendly');

INSERT INTO skill_tags (skill_id, tag_id) VALUES
  ((SELECT id FROM skills WHERE name='Python Programming'), (SELECT id FROM tags WHERE name='tech')),
  ((SELECT id FROM skills WHERE name='Graphic Design'), (SELECT id FROM tags WHERE name='art')),
  ((SELECT id FROM skills WHERE name='Guitar Playing'), (SELECT id FROM tags WHERE name='music')),
  ((SELECT id FROM skills WHERE name='Spanish Language'), (SELECT id FROM tags WHERE name='language')),
  ((SELECT id FROM skills WHERE name='Photography'), (SELECT id FROM tags WHERE name='beginner-friendly'));

INSERT INTO user_skills (id, user_id, skill_id, type, level, description) VALUES
  (gen_random_uuid(), (SELECT id FROM users WHERE name='Alice Johnson'), (SELECT id FROM skills WHERE name='Python Programming'), 'offer', 'expert', 'I can teach advanced Python concepts'),
  (gen_random_uuid(), (SELECT id FROM users WHERE name='Bob Smith'), (SELECT id FROM skills WHERE name='Graphic Design'), 'offer', 'intermediate', 'I design logos and websites'),
  (gen_random_uuid(), (SELECT id FROM users WHERE name='Carol White'), (SELECT id FROM skills WHERE name='Photography'), 'learn', 'beginner', 'I want to improve my photography skills'),
  (gen_random_uuid(), (SELECT id FROM users WHERE name='David Black'), (SELECT id FROM skills WHERE name='Guitar Playing'), 'offer', 'expert', 'Professional guitarist offering lessons'),
  (gen_random_uuid(), (SELECT id FROM users WHERE name='Eve Green'), (SELECT id FROM skills WHERE name='Spanish Language'), 'learn', 'intermediate', 'Looking to practice conversational Spanish');

INSERT INTO matches (id, initiator_id, receiver_id, initiator_skill_id, receiver_skill_id, match_type, status) VALUES
  (
    gen_random_uuid(),
    (SELECT id FROM users WHERE name='Alice Johnson'),
    (SELECT id FROM users WHERE name='Carol White'),
    (SELECT id FROM user_skills WHERE user_id = (SELECT id FROM users WHERE name='Alice Johnson') AND skill_id = (SELECT id FROM skills WHERE name='Python Programming')),
    (SELECT id FROM user_skills WHERE user_id = (SELECT id FROM users WHERE name='Carol White') AND skill_id = (SELECT id FROM skills WHERE name='Photography')),
    'trade',
    'pending'
  ),
  (
    gen_random_uuid(),
    (SELECT id FROM users WHERE name='David Black'),
    (SELECT id FROM users WHERE name='Eve Green'),
    (SELECT id FROM user_skills WHERE user_id = (SELECT id FROM users WHERE name='David Black') AND skill_id = (SELECT id FROM skills WHERE name='Guitar Playing')),
    (SELECT id FROM user_skills WHERE user_id = (SELECT id FROM users WHERE name='Eve Green') AND skill_id = (SELECT id FROM skills WHERE name='Spanish Language')),
    'learn',
    'accepted'
  ),
  (
    gen_random_uuid(),
    (SELECT id FROM users WHERE name='Bob Smith'),
    (SELECT id FROM users WHERE name='Alice Johnson'),
    (SELECT id FROM user_skills WHERE user_id = (SELECT id FROM users WHERE name='Bob Smith') AND skill_id = (SELECT id FROM skills WHERE name='Graphic Design')),
    (SELECT id FROM user_skills WHERE user_id = (SELECT id FROM users WHERE name='Alice Johnson') AND skill_id = (SELECT id FROM skills WHERE name='Python Programming')),
    'mutual',
    'completed'
  ),
  (
    gen_random_uuid(),
    (SELECT id FROM users WHERE name='Eve Green'),
    (SELECT id FROM users WHERE name='Carol White'),
    (SELECT id FROM user_skills WHERE user_id = (SELECT id FROM users WHERE name='Eve Green') AND skill_id = (SELECT id FROM skills WHERE name='Spanish Language')),
    (SELECT id FROM user_skills WHERE user_id = (SELECT id FROM users WHERE name='Carol White') AND skill_id = (SELECT id FROM skills WHERE name='Photography')),
    'trade',
    'rejected'
  ),
  (
    gen_random_uuid(),
    (SELECT id FROM users WHERE name='Alice Johnson'),
    (SELECT id FROM users WHERE name='David Black'),
    (SELECT id FROM user_skills WHERE user_id = (SELECT id FROM users WHERE name='Alice Johnson') AND skill_id = (SELECT id FROM skills WHERE name='Python Programming')),
    (SELECT id FROM user_skills WHERE user_id = (SELECT id FROM users WHERE name='David Black') AND skill_id = (SELECT id FROM skills WHERE name='Guitar Playing')),
    'learn',
    'pending'
  );

INSERT INTO messages (id, match_id, sender_id, content) VALUES
  (gen_random_uuid(), (SELECT id FROM matches LIMIT 1 OFFSET 0), (SELECT id FROM users WHERE name='Alice Johnson'), 'Hi Carol, interested in trading skills?'),
  (gen_random_uuid(), (SELECT id FROM matches LIMIT 1 OFFSET 1), (SELECT id FROM users WHERE name='David Black'), 'Hello Eve! Ready to start lessons?'),
  (gen_random_uuid(), (SELECT id FROM matches LIMIT 1 OFFSET 2), (SELECT id FROM users WHERE name='Bob Smith'), 'Alice, loved working with you!'),
  (gen_random_uuid(), (SELECT id FROM matches LIMIT 1 OFFSET 3), (SELECT id FROM users WHERE name='Eve Green'), 'Carol, let me know if you change your mind.'),
  (gen_random_uuid(), (SELECT id FROM matches LIMIT 1 OFFSET 4), (SELECT id FROM users WHERE name='Alice Johnson'), 'David, can we schedule a session?');

INSERT INTO reviews (id, match_id, reviewer_id, reviewee_id, skill_id, rating, comment) VALUES
  (
    gen_random_uuid(),
    (SELECT id FROM matches LIMIT 1 OFFSET 2),
    (SELECT id FROM users WHERE name='Bob Smith'),
    (SELECT id FROM users WHERE name='Alice Johnson'),
    (SELECT id FROM skills WHERE name='Python Programming'),
    5,
    'Great trade, learned a lot!'
  ),
  (
    gen_random_uuid(),
    (SELECT id FROM matches LIMIT 1 OFFSET 1),
    (SELECT id FROM users WHERE name='David Black'),
    (SELECT id FROM users WHERE name='Eve Green'),
    (SELECT id FROM skills WHERE name='Spanish Language'),
    4,
    'Eve is a fast learner!'
  ),
  (
    gen_random_uuid(),
    (SELECT id FROM matches LIMIT 1 OFFSET 0),
    (SELECT id FROM users WHERE name='Alice Johnson'),
    (SELECT id FROM users WHERE name='Carol White'),
    (SELECT id FROM skills WHERE name='Photography'),
    3,
    'Carol needs more practice but eager to learn.'
  ),
  (
    gen_random_uuid(),
    (SELECT id FROM matches LIMIT 1 OFFSET 4),
    (SELECT id FROM users WHERE name='Alice Johnson'),
    (SELECT id FROM users WHERE name='David Black'),
    (SELECT id FROM skills WHERE name='Guitar Playing'),
    5,
    'David is an excellent teacher!'
  ),
  (
    gen_random_uuid(),
    (SELECT id FROM matches LIMIT 1 OFFSET 3),
    (SELECT id FROM users WHERE name='Eve Green'),
    (SELECT id FROM users WHERE name='Carol White'),
    (SELECT id FROM skills WHERE name='Photography'),
    2,
    'Match was not a good fit.'
  );


  INSERT INTO availability (id, user_id, day_of_week, start_time, end_time, timezone) VALUES
  (gen_random_uuid(), (SELECT id FROM users WHERE name='Alice Johnson'), 1, '09:00', '12:00', 'America/New_York'),
  (gen_random_uuid(), (SELECT id FROM users WHERE name='Bob Smith'), 2, '13:00', '17:00', 'America/Los_Angeles'),
  (gen_random_uuid(), (SELECT id FROM users WHERE name='Carol White'), 3, '10:00', '14:00', 'Europe/London'),
  (gen_random_uuid(), (SELECT id FROM users WHERE name='David Black'), 4, '15:00', '18:00', 'Asia/Tokyo'),
  (gen_random_uuid(), (SELECT id FROM users WHERE name='Eve Green'), 5, '08:00', '11:00', 'Europe/Berlin');

INSERT INTO notifications (id, user_id, type, reference_id, content, is_read) VALUES
  (gen_random_uuid(), (SELECT id FROM users WHERE name='Alice Johnson'), 'match_request', (SELECT id FROM matches LIMIT 1 OFFSET 0), 'You have a new match request from Alice.', FALSE),
  (gen_random_uuid(), (SELECT id FROM users WHERE name='Carol White'), 'message', (SELECT id FROM messages LIMIT 1 OFFSET 0), 'New message from Alice.', FALSE),
  (gen_random_uuid(), (SELECT id FROM users WHERE name='Bob Smith'), 'review', (SELECT id FROM reviews LIMIT 1 OFFSET 0), 'Bob received a 5-star review!', TRUE),
  (gen_random_uuid(), (SELECT id FROM users WHERE name='David Black'), 'system', NULL, 'System maintenance scheduled.', FALSE),
  (gen_random_uuid(), (SELECT id FROM users WHERE name='Eve Green'), 'match_request', (SELECT id FROM matches LIMIT 1 OFFSET 1), 'You have a new match request from David.', TRUE);


-- Sample Queries

-- Get all users
SELECT * FROM users;

-- Get all matches for a user
SELECT * FROM matches WHERE initiator_id = (SELECT id FROM users WHERE name='Alice Johnson');

-- Get all messages for a match
SELECT * FROM messages WHERE match_id = (SELECT id FROM matches LIMIT 1 OFFSET 0);

-- Get all reviews for a user
SELECT * FROM reviews WHERE reviewer_id = (SELECT id FROM users WHERE name='Alice Johnson');

-- Get all notifications for a user
SELECT * FROM notifications WHERE user_id = (SELECT id FROM users WHERE name='Alice Johnson');

-- Get all availability slots for a user
SELECT * FROM availability WHERE user_id = (SELECT id FROM users WHERE name='Alice Johnson');

-- Get all skills for a user
SELECT * FROM user_skills WHERE user_id = (SELECT id FROM users WHERE name='Alice Johnson');


-- Get all reviews for a skill
SELECT * FROM reviews WHERE skill_id = (SELECT id FROM skills WHERE name='Python Programming');

-- Get all notifications for a skill
SELECT * FROM notifications WHERE reference_id = (SELECT id FROM skills WHERE name='Python Programming');

-- Get all skills for a skill
SELECT * FROM user_skills WHERE skill_id = (SELECT id FROM skills WHERE name='Python Programming');

-- Get all users with a skill
SELECT u.* FROM users u
JOIN user_skills us ON u.id = us.user_id
WHERE us.skill_id = (SELECT id FROM skills WHERE name='Python Programming');

-- Get all tags for a skill
SELECT t.* FROM tags t
JOIN skill_tags st ON t.id = st.tag_id
WHERE st.skill_id = (SELECT id FROM skills WHERE name='Python Programming');

-- Get all messages for a match
SELECT * FROM messages WHERE match_id = (SELECT id FROM matches LIMIT 1 OFFSET 0);

-- Get all reviews for a match
SELECT * FROM reviews WHERE match_id = (SELECT id FROM matches LIMIT 1 OFFSET 0);

-- Get all notifications for a match
SELECT * FROM notifications WHERE reference_id = (SELECT id FROM matches LIMIT 1 OFFSET 0);

-- Get all matches
SELECT m.id, u1.name AS initiator, u2.name AS receiver, m.status, m.match_type, m.created_at
FROM matches m
JOIN users u1 ON m.initiator_id = u1.id
JOIN users u2 ON m.receiver_id = u2.id;

-- Get all messages
SELECT msg.content, u.name AS sender, msg.sent_at
FROM messages msg
JOIN users u ON msg.sender_id = u.id
WHERE msg.match_id = (SELECT id FROM matches LIMIT 1)
ORDER BY msg.sent_at ASC;
