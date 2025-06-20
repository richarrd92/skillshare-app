# create_engine: Establishes a connection to your database (e.g., PostgreSQL).
# text: Allows writing raw SQL queries (text("SELECT 1")) for lightweight checks or custom queries.
# declarative_base: Returns a base class for all your ORM models (tables). You inherit from this to define tables.
# sessionmaker: A factory that creates Session objects. These sessions manage DB transactions (like .add(), .commit()).
# Loads environment variables from a .env file into your Python process so sensitive data like passwords or DB URLs aren't hardcoded.
# os: Used here to check for .env file and get env vars.
# sys: Used to print errors and exit the program cleanly.
# OperationalError: Catches specific SQLAlchemy connection errors (e.g., wrong DB URL).
from sqlalchemy import create_engine, text
from sqlalchemy.orm import declarative_base, sessionmaker
from dotenv import load_dotenv
import os
import sys
from sqlalchemy.exc import OperationalError
from logger import logger

# Load environment variables only once per Python session, even if this module is imported multiple times.
if not hasattr(sys.modules[__name__], "_env_loaded"):
    # Exits the app if .env is missing.
    if not os.path.isfile(".env"):
        logger.error("Missing .env file. Please create one with database credentials.")
        sys.exit(1)
    load_dotenv() # Loads all KEY=value pairs in .env into the environment.
    setattr(sys.modules[__name__], "_env_loaded", True) # Sets a flag to prevent re-loading .env.

# Load the database URL from environment
DATABASE_URL = os.getenv("HOBBYMATCH_DATABASE_URL")
if not DATABASE_URL:
    logger.error("HOBBYMATCH_DATABASE_URL is not set in .env.")
    sys.exit(1) # Gracefully exits if DB URL is missing.

# Use module-level singletons to avoid multiple initializations
# These will hold the database engine, session factory, and base class only once, to avoid duplicate creation across imports.
_engine = None
_SessionLocal = None
_Base = None

# Initialize only once when imported. 
# Initializes everything needed to use SQLAlchemy.
def init_db():
    # Allows modifying the module-level variables from inside the function.
    global _engine, _SessionLocal, _Base

    # Note: Engine is the core SQLAlchemy object that manages DB connections.
    # Creates Engine
    if _engine is None:
        logger.info("\n\n-------- INITIALIZING HOBBYMATCH DATABASE CONNECTION --------\n")

        # Attempts to create a connection to the database.
        try:
            _engine = create_engine(DATABASE_URL)
            with _engine.connect() as conn:
                logger.info("Database engine connected successfully.")
        except OperationalError as e:
            logger.error(f"Connection failed. {e}")
            sys.exit(1)
        except Exception as e:
            logger.error(f"Unexpected connection error. {e}")
            sys.exit(1)

    # A SessionLocal() will be used inside your API endpoints to interact with the database.
    # Creates Session Factory
    if _SessionLocal is None:
        _SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=_engine)

    # declarative_base() returns a class to define all ORM models (e.g., User, Skill).
    # Base.metadata.create_all() creates all tables defined by models if they don’t exist.
    # Setups ORM Base and Create Tables
    if _Base is None:
        _Base = declarative_base()

        try:
            logger.info("Creating tables for Hobbymatch App...")
            _Base.metadata.create_all(bind=_engine)
            logger.info("All tables created or verified successfully.")
        except Exception as e:
            logger.error(f"Table creation error: {e}")
            sys.exit(1)

    return _engine, _SessionLocal, _Base # Returns initialized instances so other files can use them.

# Initializes the connection at import time so everything's ready to use.
engine, SessionLocal, Base = init_db()

# Standard FastAPI dependency pattern.
# Yields a database session for a route handler, then safely closes it after the request.
# Dependency to get DB session
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# Tests database connection during startup.
# runs a quick SELECT 1 to verify everything works.
def test_db_connection():
    try:
        with engine.connect() as conn:
            result = conn.execute(text("SELECT 1"))
            logger.info(f"Database test successful: {result.scalar()}")
            logger.info("Hobbymatch Database Connection Initialized.")
    except Exception as e:
        logger.error(f"Test query failed: {e}")

# Only run when executing this file directly
if __name__ == "__main__":
    test_db_connection()