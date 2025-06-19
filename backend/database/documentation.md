## SkillShare App Database Schema Overview

This document explains the schema design, table relations, and core logic for the SkillShare social platform.

### Core Logic & Workflow

- Users **register** with external auth (Google, GitHub), no password stored.
- Users **add skills** they offer or want to learn, tagging their level.
- Matches connect two users with complementary or mutual skills:
  - `trade` = users offer and want to learn different skills.
  - `learn` = one-sided learning request.
  - `mutual` = users share the same skill and want to connect.
- Users **message** each other within matches, with threaded replies.
- After sessions, users can leave **reviews** tied to the skill and match.
- Users specify **availability** to coordinate meeting times.

This schema ensures flexibility for a skill-sharing platform focused on community building, learning, and collaboration.

### Database Setup & Types

- **Database**: `skillshare_app`
- **UUID extension** enabled (`uuid-ossp`) for universally unique identifiers.
- **Enums defined**:
  - `skill_type`: `'offer'`, `'learn'`
  - `skill_level`: `'beginner'`, `'intermediate'`, `'expert'`
  - `match_status`: `'pending'`, `'accepted'`, `'rejected'`, `'completed'`
  - `match_type`: `'trade'`, `'learn'`, `'mutual'` (type of user connection)

### Tables & Relations

#### 1. `users`
- Stores user info: name, email, bio, profile picture, location, and auth provider.
- **Primary Key:** `id (UUID)`
- **Relation:**  
  - `location_id` → references `locations(id)` (optional, set to NULL if location deleted).

#### 2. `locations`
- Stores geographical info: city, region, country, coordinates, and timezone.
- **Primary Key:** `id (UUID)`

#### 3. `skills`
- Catalog of skills users can offer or want to learn.
- Users can **add new skills** (`created_by` references who added it).
- **Primary Key:** `id (UUID)`
- **Relation:**  
  - `created_by` → references `users(id)`, set to NULL if user deleted.

#### 4. `user_skills`
- Links users to their skills with details:
  - Whether they **offer** or **learn** the skill.
  - Their skill level.
  - Optional description.
- **Primary Key:** `id (UUID)`
- **Relations:**  
  - `user_id` → `users(id)` (cascade delete)
  - `skill_id` → `skills(id)` (cascade delete)
- **Constraint:** Unique combination of `user_id`, `skill_id`, and `type` to prevent duplicates.

#### 5. `matches`
- Represents connections/matches between two users based on skills.
- Supports different types of matches: trade, one-sided learning, or mutual interest.
- Tracks status (`pending`, `accepted`, etc.).
- **Primary Key:** `id (UUID)`
- **Relations:**  
  - `initiator_id` and `receiver_id` → `users(id)` (cascade delete)  
  - `initiator_skill_id` and `receiver_skill_id` → `user_skills(id)` (cascade delete)

#### 6. `messages`
- Conversation messages between matched users.
- Supports threaded replies via `reply_to_message_id`.
- **Primary Key:** `id (UUID)`
- **Relations:**  
  - `match_id` → `matches(id)` (cascade delete)  
  - `sender_id` → `users(id)` (cascade delete)  
  - `reply_to_message_id` → `messages(id)` (set NULL if replied message deleted)

#### 7. `reviews`
- Users can review each other after a match on a specific skill.
- Ratings are between 1 and 5.
- **Primary Key:** `id (UUID)`
- **Relations:**  
  - `match_id` → `matches(id)` (cascade delete)  
  - `reviewer_id` and `reviewee_id` → `users(id)` (cascade delete)  
  - `skill_id` → `skills(id)` (cascade delete)

#### 8. `availability`
- Tracks users’ available days/times with timezone info.
- Useful for scheduling skill sharing sessions.
- **Primary Key:** `id (UUID)`
- **Relation:**  
  - `user_id` → `users(id)` (cascade delete)
- Constraints ensure valid day of week (0–6) and valid times.


