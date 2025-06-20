# Skillshare App
A micro skill-barter web platform that lets users offer and request skills from others in their area or online. This app is built to showcase full-stack problem solving, real-world functionality, and clean architecture using modern tools like React, FastAPI, and Firebase. It follows a three-tier architecture pattern consisting of a presentation layer (frontend), application layer (backend/API), and data layer (database).

### Features

- Google Sign-In with Firebase
- User profile with skill offered & wanted
- Search/filter other users by skill
- Express interest to connect (basic match system)
- Real-time database (Firestore) or REST backend (FastAPI)
- Responsive design for desktop (mobile later)


### Tech Stack

| Layer        | Technology         |
|--------------|--------------------|
| Frontend     | React + Tailwind CSS |
| Auth         | Firebase Auth       |
| Backend      | FastAPI + PostgreSQL |
| Hosting      | Firebase |


#### High-Level Architecture

```plaintext
+---------------------------+        +------------------------------+        +------------------+
|         Frontend          | <----> |           Backend            | <----> |     Database     |
|   (React / Tailwind CSS)  |        |  (FastAPI / SQLAlchemy ORM)  |        |   (PostgreSQL)   |
+---------------------------+        +------------------------------+        +------------------+
```

#### Backend Structure (FastAPI)

```plaintext
backend/
├── routes/            # Routes (auth, skills, swaps)
├── models/            # ORM Models
├── schemas/           # Pydantic schemas
├── database.py        # Database connection
├── main.py            # Entry point
└── main.sql           # Database schema
```

#### Frontend Structure (FastAPI)

```plaintext
frontend/
├── public/            # Static files
├── src/               # React components
└── To be determined   # React entry point
```

#### Why Open Source?

Skillshare App is open source because we believe in:
- **Collaborative growth**: Developers from anywhere can suggest improvements or build new features.
- **Transparency**: Everything from data models to deployment is out in the open to encourage learning and feedback.
- **Education**: This project is a teaching tool for understanding full-stack architecture, authentication, and database modeling.
