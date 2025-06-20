#!/bin/bash

# -----------------------------------------------------------------------------
# Script to initialize environment, connect database, and start FastAPI backend
# For the HobbyMatch App (backend only)
# -----------------------------------------------------------------------------

BACKEND_PORT=8000

# --- KILL OLD PROCESS ON BACKEND PORT (if any) ---
echo
echo "---------------------- RUNNING START.SH SCRIPT ----------------------"
echo
echo "Checking for existing backend on port $BACKEND_PORT..."
lsof -ti:$BACKEND_PORT | xargs kill -9 2>/dev/null

# --- START BACKEND ---
echo "Starting HobbyMatch App backend on http://localhost:$BACKEND_PORT ..."
cd backend || { echo "Backend folder not found!"; exit 1; }

# Activate virtual environment
if [ -f "venv/bin/activate" ]; then
  source venv/bin/activate
else
  echo "Virtual environment not found. Please run: python3 -m venv venv && source venv/bin/activate"
  exit 1
fi

# Step 1: Initialize database (connection, tables, etc.)
echo
python3 database.py || { echo "Database init failed."; exit 1; }

# Step 2: Start main FastAPI server
echo
echo "-------- RUNNING MAIN FASTAPI APP --------"
echo
python3 main.py &
backend_pid=$!

# Wait for backend to exit or Ctrl+C
trap "echo 'Shutting down backend...'; kill $backend_pid; deactivate; echo 'Done.'" EXIT
wait $backend_pid

# -----------------------------------------------------------------------------
# HOW TO USE THIS SCRIPT:
# 1. Place this script in your project root (same level as backend/ and frontend/ folders)
# 2. Make it executable (once): chmod +x start.sh
# 3. Run it: ./start.sh
# 4. To completely exit: press Ctrl+C twice 
# -----------------------------------------------------------------------------