# Import the FastAPI class from the fastapi package
# This is the core framework used to define and run the API
from fastapi import FastAPI
from contextlib import asynccontextmanager # to manage startup and shutdown lifecycle events asynchronously
from logger import logger # Import the shared logger instance for consistent logging across modules

# Define the lifespan event handler using an asynchronous context manager
# This function runs once at startup (before serving requests), and once at shutdown (after all requests are done)
@asynccontextmanager
async def lifespan(app: FastAPI):
    # ====== STARTUP LOGIC ======
    # This code runs before the app starts handling requests
    logger.info("HobbyMatch App Backend Server is starting up!")

    # `yield` passes control back to FastAPI to run the app
    # The code after `yield` will execute when the server shuts down
    yield

    # ====== SHUTDOWN LOGIC ======
    # This code runs once the app is shutting down (e.g., server is stopped)
    logger.info("HobbyMatch App Backend Server is shutting down!")

# Create the FastAPI app instance and pass the `lifespan` handler
# This replaces deprecated @app.on_event("startup") and @app.on_event("shutdown")
app = FastAPI(lifespan=lifespan)


# Define a simple GET endpoint at the root URL ("/")
# When a client visits http://localhost:8000/, this function will be triggered
@app.get("/")
def read_root():
    # Return a JSON response with a message confirming that the backend is running
    logger.info("Received request at root endpoint")
    return {"message" : "HobbyMatch App Backend Server is running!"}

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