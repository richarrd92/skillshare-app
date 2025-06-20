#!/bin/bash

# -----------------------------------------------------------------------------
# Script to activate virtual environment, update requirements, and run FastAPI app
# -----------------------------------------------------------------------------

echo
echo "------ STARTING HOBBYMATCH BACKEND ------"
echo
# Activate virtual environment
if [ -f "venv/bin/activate" ]; then
  echo " - Activating virtual environment..."
  source venv/bin/activate
else
  echo "[ERROR] venv not found. To create it, run:"
  echo "python3 -m venv venv && source venv/bin/activate"
  exit 1
fi

# Automatically update requirements.txt
echo " - Updating requirements.txt..."
pip freeze > requirements.txt && echo " - Updated requirements.txt" || echo "[Warning] Failed to update requirements.txt"
echo

# Initialize the database
python3 database.py || { echo "[ERROR] Failed to initialize database."; deactivate; exit 1; }

# Start FastAPI app
echo
echo "-------- STARTING MAIN FASTAPI APP --------"
echo
python3 main.py


# -----------------------------------------------------------------------------
# HOW TO USE THIS SCRIPT:
# 1. Place this script in your project root (same level as backend/ and frontend/ folders)
# 2. Make it executable (once): chmod +x start.sh
# 3. Run it: ./start.sh
# 4. To completely exit: press Ctrl+C twice 
# -----------------------------------------------------------------------------