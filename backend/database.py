from sqlalchemy import create_engine, text
from sqlalchemy.orm import declarative_base, sessionmaker
from dotenv import load_dotenv
import os
import sys
from sqlalchemy.exc import OperationalError

# Load environment variables only once
if not hasattr(sys.modules[__name__], "_env_loaded"):
    if not os.path.isfile(".env"):
        print({"error message": "Missing .env file. Please create one with database credentials."}, file=sys.stderr)
        sys.exit(1)
    load_dotenv()
    setattr(sys.modules[__name__], "_env_loaded", True)

# Load the database URL from environment
DATABASE_URL = os.getenv("SKILLSHARE_DATABASE_URL")
if not DATABASE_URL:
    print({"error message": "SKILLSHARE_DATABASE_URL is not set in .env."}, file=sys.stderr)
    sys.exit(1)

# Use module-level singletons to avoid multiple initializations
_engine = None
_SessionLocal = None
_Base = None

# Initialize only once
def init_db():
    global _engine, _SessionLocal, _Base

    if _engine is None:
        print("\n-------- INITIALIZING SKILLSHARE DATABASE CONNECTION --------\n")
        print(f"Connecting to: {DATABASE_URL}")
        try:
            _engine = create_engine(DATABASE_URL)
            with _engine.connect() as conn:
                print("Database engine connected successfully.")
        except OperationalError as e:
            print({"error message": f"Connection failed. {e}"}, file=sys.stderr)
            sys.exit(1)
        except Exception as e:
            print({"error message": f"Unexpected connection error. {e}"}, file=sys.stderr)
            sys.exit(1)

    if _SessionLocal is None:
        _SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=_engine)

    if _Base is None:
        _Base = declarative_base()

        try:
            print("Creating tables for Skillshare App...")
            _Base.metadata.create_all(bind=_engine)
            print("All tables created or verified successfully.")
        except Exception as e:
            print({"error message": f"Table creation error: {e}"}, file=sys.stderr)
            sys.exit(1)

    return _engine, _SessionLocal, _Base

# Call this once to initialize
engine, SessionLocal, Base = init_db()

# Dependency to get DB session
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# Test function
def test_db_connection():
    try:
        with engine.connect() as conn:
            result = conn.execute(text("SELECT 1"))
            print("Database test successful:", result.scalar())
            print("\n-------- SKILLSHARE DB CONNECTED --------\n")
    except Exception as e:
        print({"error message": f"Test query failed: {e}"}, file=sys.stderr)

# Only run when executing this file directly
if __name__ == "__main__":
    test_db_connection()