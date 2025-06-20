# HobbyMatch App

A social matching and discovery platform that connects users based on shared hobbies and interests. HobbyMatch helps people meet like-minded individuals by using ranked hobby preferences to drive matching, content recommendations, and interaction. It blends social discovery, ephemeral content, and gamified engagement to encourage real-world connections. This app demonstrates full-stack architecture, relational modeling, and user-centric features using React, FastAPI, PostgreSQL, and Firebase Auth.

### Goals

The purpose of HobbyMatch is to:
- Help people find friends and activity partners based on shared hobbies.
- Encourage real-world interaction via event RSVPs, live hobby spots, and blog-like story posts.
- Promote engagement through points, streaks, and a flake score system that rewards reliability.

### Features

- Google Sign-In (restricted to verified emails if needed)
- Hobby selection and ranking (top 3 interests)
- Smart matching system based on hobby overlap
- 24hr user blog posts tied to hobbies (story-style content)
- Match and chat functionality
- Event and spot RSVP system
- Flake score to track reliability
- Points and streak system to gamify participation
- Optional profile photos (up to 3) and user bios
- Notifications for messages, matches, RSVPs, and more
- Responsive design for desktop (mobile later)


### Tech Stack

| Layer        | Technology                                |
|--------------|--------------------------------------------|
| Frontend     | React [JavaScript, JSX, HTML, CSS]         |
| Auth         | Firebase Auth                              |
| Backend      | FastAPI + PostgreSQL                       |
| Hosting      | Firebase                                   |

#### High-Level Architecture

```plaintext
+---------------------------+        +------------------------------+        +------------------+
|         Frontend          | <----> |           Backend            | <----> |     Database     |
|   (React / JavaScript,    |        |  (FastAPI / SQLAlchemy ORM)  |        |   (PostgreSQL)   |
|    JSX, HTML, CSS)        |        |                              |        |                  |
+---------------------------+        +------------------------------+        +------------------+
```

#### Backend Structure (FastAPI)

```plaintext
backend/
├── documentation/     # Documentation text files
├── routes/            # Routes (auth, hobbies, posts, matches, events, etc.)
├── models/            # ORM Models
├── schemas/           # Pydantic schemas
├── database.py        # Database connection
├── logger.py          # Logging utility
├── main.py            # Entry point
└── main.sql           # Database schema
```

#### Frontend Structure (FastAPI)

```plaintext
frontend/
├── public/            # Static files
├── src/               # React components
│   ├── auth/          # Firebase login and auth context
│   ├── pages/         # Route-based pages (dashboard, matches, events, etc.)
│   ├── components/    # UI components
│   ├── utils/         # Helper functions
│   └── App.js         # App root
└── index.js           # React entry point
```
### Why Open Source?

Although this is a personal project, the **hobbymatch App** is open source to encourage collaboration with other developers. Anyone interested in contributing whether it’s fixing bugs, improving documentation, or adding features is welcome to do so. Collaboration will be managed through **pull requests** and **code reviews** to maintain quality and ensure transparency.

By keeping the project open, the goal is to:

- Promote **collaborative growth**, allowing developers to learn and build together.
- Maintain **transparency**, making the app's architecture, logic, and decisions visible to all.
- Serve as an **educational resource** for full-stack development using modern technologies like React, FastAPI, and PostgreSQL.

#### How to Contribute via Pull Request

1. **Fork the repository** to your GitHub account.
2. **Clone your fork** to your local machine:
   ```bash
   git clone https://github.com/your-username/hobbymatch-app.git
   cd hobbymatch-app
   ```
3. **Create a new branch** for your changes:
   ```bash
   git checkout -b feature/your-feature-name
   ```
4. Make your changes and **commit**:
   ```bash
   git add .
   git commit -m "Add [your feature or fix description]"
   ```
5. **Push** the changes to your fork:
   ```bash
   git push origin feature/your-feature-name
   ```
6. Go to the original repository on GitHub and **open a pull request**.
7. Describe your changes and submit the PR for review.

All contributions will go through a code review process to ensure quality and alignment with the project’s goals.