# Skill Swap App
A micro skill-barter web platform that lets users offer and request skills from others in their area or online. Built to showcase full-stack problem solving, real-world functionality, and clean architecture.

### Features

- Google Sign-In with Firebase
- User profile with skill offered & wanted
- Search/filter other users by skill
- Express interest to connect (basic match system)
- Real-time database (Firestore) or REST backend (FastAPI)
- Responsive design for mobile + desktop (mobile later)

### Tech Stack

| Layer        | Technology         |
|--------------|--------------------|
| Frontend     | React + Tailwind CSS |
| Auth         | Firebase Auth       |
| Backend (Opt)| Firebase Firestore or FastAPI + PostgreSQL |
| Hosting      | Vercel (Frontend), Firebase/Supabase for backend |


### Getting Started

#### Clone the repo
```bash
git clone https://github.com/<your-username>/skill-swap.git
cd skill-swap
```

### Scalable Project Design
A scalable architecture for a full-stack Skill Swap web application where users can offer and request skills to exchange.

### High-Level Architecture

```plaintext
+-------------------+        +-------------------+        +--------------------+
|    Frontend       | <----> |     Backend       | <----> |      Database      |
|  (React / Web)    |        |  (FastAPI / Node) |        | (Postgres / Mongo) |
+-------------------+        +-------------------+        +--------------------+
```

### Frontend Structure (React)

```plaintext
src/
├── components/
│   ├── Auth/
│   │   ├── LoginForm.jsx
│   │   └── RegisterForm.jsx
│   ├── Skills/
│   │   ├── SkillList.jsx
│   │   ├── SkillCard.jsx
│   │   └── SkillDetail.jsx
│   ├── SwapRequests/
│   │   ├── RequestList.jsx
│   │   └── RequestForm.jsx
│   ├── Profile/
│   │   └── UserProfile.jsx
│   └── Common/
│       ├── Navbar.jsx
│       └── Footer.jsx
├── contexts/
│   └── AuthContext.jsx
├── hooks/
│   └── useFetchSkills.js
├── pages/
│   ├── Home.jsx
│   ├── Dashboard.jsx
│   ├── Login.jsx
│   ├── Register.jsx
│   └── NotFound.jsx
├── services/
│   └── api.js
└── App.jsx
```

### Backend Structure (FastAPI)

```plaintext
app/
├── api/
│   ├── auth.py           # login, register, JWT token
│   ├── skills.py         # skill endpoints
│   ├── swaps.py          # skill swap requests
│   └── users.py          # user profile
├── core/
│   ├── config.py         # env configs
│   ├── security.py       # JWT, hashing
│   └── db.py             # DB connection
├── models/
│   ├── user.py
│   ├── skill.py
│   └── swap.py
├── schemas/
│   ├── user.py
│   ├── skill.py
│   └── swap.py
└── main.py               # entry point
```

### Database Schema (Relational – PostgreSQL)

Table	Fields	Description
- **users**	id, username, email, hashed_pw, bio, created_at	User accounts
- **skills**	id, user_id (FK), title, category, description, created_at	Skills offered by users
- **swap_requests**	id, requester_id (FK), skill_id (FK), status, created_at


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
- Adds skills they can offer
- Browses other users' skills
- Sends a request to swap skills
- Request is accepted/rejected
- Tracks swap history on their profile

#### Scalability Tips
- **Frontend**
  - Code splitting with React.lazy
  - Lazy load routes
  - Separate reusable components

- **Backend**
  - Use async frameworks (FastAPI, Express + async)
  - Add caching (Redis) for hot data
  - Containerize with Docker

- **Database**
  - Use indexing on user_id, skill_id
  - Paginate list views
  - Archive old data

#### Future Enhancements
- Real-time messaging (Socket.io or WebSockets)
- Skill ratings and feedback
- Notifications (email / in-app)
- Mobile version with React Native or Flutter
