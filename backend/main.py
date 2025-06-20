# Import the FastAPI class from the fastapi package
# This is the core framework used to define and run the API
from fastapi import FastAPI

# Create an instance of the FastAPI application
# This 'app' object is what routes and configurations are attached to
app = FastAPI()

# Define a simple GET endpoint at the root URL ("/")
# When a client visits http://localhost:8000/, this function will be triggered
@app.get("/")
def read_root():
    # Return a JSON response with a message confirming that the backend is running
    return {"message" : "Skillshare App Backend is running!"}

# This conditional block ensures the following code only runs
# if this file is executed directly (e.g., `python main.py`)
if __name__ == "__main__":
    # Import uvicorn, the ASGI server used to serve FastAPI applications
    # Start the uvicorn server:
    # - "main:app" points to the 'app' instance in this 'main' module
    # - host="127.0.0.1" means the server is only accessible locally (localhost)
    # - port=8000 sets the server to listen on port 8000
    # - reload=True enables auto-reloading when code changes, great for development
    import uvicorn
    uvicorn.run("main:app", host="127.0.0.1", port=8000, reload=True)