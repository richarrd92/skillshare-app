# Backend Documentation
This is the backend for the Skillshare App, built using FastAPI. It handles user authentication, skill data, and swap request logic through a RESTful API.

### Tech Stack
- **FastAPI** – modern Python web framework
- **Uvicorn** – ASGI server for running FastAPI
- **SQLAlchemy** – ORM for database interactions
- **PostgreSQL** – relational database
- **Pydantic** – data validation and serialization
- **JWT** – authentication using JSON Web Tokens
- **python-dotenv** – for environment variable management

### Setup Instructions

#### Step 1: Create virtual environment
```
cd backend
python3 -m venv venv
source venv/bin/activate
```

#### Step 2: Install dependencies and Create .env file
```
pip install -r requirements.txt
touch .env
```

#### Step 3: Run the server
```
uvicorn main:app --reload
```