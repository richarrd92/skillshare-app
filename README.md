# Skillshare App
A micro skill-barter web platform that lets users offer and request skills from others in their area or online. This app is built to showcase full-stack problem solving, real-world functionality, and clean architecture using modern tools like React, FastAPI, and Firebase.

### Features

- Google Sign-In with Firebase
- User profile with skill offered & wanted
- Search/filter other users by skill
- Express interest to connect (basic match system)
- Real-time database (Firestore) or REST backend (FastAPI)
- Responsive design for desktop (mobile later)

### Why Open Source?

Skillshare App is open source because we believe in:
- **Collaborative growth**: Developers from anywhere can suggest improvements or build new features.
- **Transparency**: Everything from data models to deployment is out in the open to encourage learning and feedback.
- **Education**: This project is a teaching tool for understanding full-stack architecture, authentication, and database modeling.


### Tech Stack

| Layer        | Technology         |
|--------------|--------------------|
| Frontend     | React + Tailwind CSS |
| Auth         | Firebase Auth       |
| Backend      | FastAPI + PostgreSQL |
| Hosting      | Firebase |


### Getting Started

```
  git clone https://github.com/<your-username>/skillshare-app.git
  cd skillshare-app
```

#### High-Level Architecture

```plaintext
+-------------------+        +-------------------+        +--------------------+
|    Frontend       | <----> |     Backend       | <----> |      Database      |
|  (React / Web)    |        |  (FastAPI / Node) |        | (Postgres / Mongo) |
+-------------------+        +-------------------+        +--------------------+
```

#### Frontend Structure (React)

```plaintext
src/
├── components/        # UI components grouped by domain
├── contexts/          # Auth context
├── hooks/             # Custom hooks
├── pages/             # Pages
├── styles/            # CSS styles
├── routes/            # Route
├── firebase/          # firebase connection
└── App.jsx            # App entry point
```

#### Backend Structure (FastAPI)

```plaintext
backend/
├── routes/            # Routes (auth, skills, swaps)
├── database/          # DB, config, security
├── models/            # ORM Models
├── schemas/           # Pydantic schemas
├── database.py/       # Database connection
└── main.py            # Entry point
```

####  Ideal Development Flow:
- **Backend First**
  - Set up FastAPI project structure
  - Define models, schemas, routes
  - Build endpoints for auth, users, skills, and swap requests
  - Test with Swagger UI or Postman

- **Frontend After**
  - Scaffold React project
  - Set up routing and auth context
  - Consume API via Axios/fetch
  - Build pages using live data


#### Core User Flow
- User signs up / logs in
- Creates profile + adds offered/desired skills
- Browses other users' skills
- Sends a request to swap skills
- Request is accepted/rejected
- Match is confirmed, reviewed, or completed


#### Ways to Contribute
- We welcome your ideas, issues, and pull requests!
  - Submit pull requests for small fixes, UI improvements, or new features.
  - Help improve this documentation or write new guides.

#### Contribution Guidelines
1. **Fork** the repository and **clone** it to your machine.
2. Create a **new branch** for your feature or fix:
```
git checkout -b feat/add-messaging
```
