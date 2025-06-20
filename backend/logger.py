# This logger is set up to write logs to both the console and a log file,
# allowing consistent logging throughout the application.
# It supports different logging levels (DEBUG, INFO, WARNING, ERROR, CRITICAL),
# timestamps each log message, and formats them uniformly for easier reading and debugging.
import logging  # Python's built-in logging module for flexible logging
import sys      # For accessing system-specific parameters and functions (used here to specify output stream)

def setup_logger(log_file="app.log", level=logging.INFO):
    """
    Configures and returns a logger instance that outputs logs to both console and a file.

    Parameters:
    - log_file (str): Path to the file where logs should be saved.
    - level (int): Logging level threshold; messages with this level or higher will be recorded.
      Common levels: DEBUG=10, INFO=20, WARNING=30, ERROR=40, CRITICAL=50.

    Returns:
    - logger (logging.Logger): Configured logger object ready to use across the app.
    """

    # Get the root logger, which is the main logger instance shared globally by default.
    logger = logging.getLogger()

    # Set the minimum severity level of logs to capture.
    # Logs below this level will be ignored.
    logger.setLevel(level)

    # Remove any existing handlers to prevent duplicate logs if this function is called multiple times.
    if logger.hasHandlers():
        logger.handlers.clear()

    # Setup console handler to output logs to standard output (usually the terminal).
    console_handler = logging.StreamHandler(sys.stdout)

    # Define log message format including timestamp, severity level, and the message.
    console_formatter = logging.Formatter('%(asctime)s [%(levelname)s] %(message)s')

    # Attach the formatter to the console handler.
    console_handler.setFormatter(console_formatter)

    # Add the console handler to the logger so console output works.
    logger.addHandler(console_handler)

    # Setup file handler to write logs to a file for persistent storage.
    file_handler = logging.FileHandler(log_file)

    # Use the same formatting for consistency between console and file logs.
    file_handler.setFormatter(console_formatter)

    # Add the file handler to the logger.
    logger.addHandler(file_handler)

    # Return the configured logger so other modules can import and use it.
    return logger

# Create a global logger instance upon import so all modules can just do 'from logger import logger'.
logger = setup_logger()

# Example usage when running this script directly.
# Demonstrates normal info log and error log with full stack trace.
if __name__ == "__main__":
    logger.info("Logger initialized - plaintext format")
    try:
        1 / 0  # This will raise a ZeroDivisionError
    except Exception as e:
        # Logs the error message with traceback details for debugging.
        logger.error(f"An error occurred: {e}", exc_info=True)
