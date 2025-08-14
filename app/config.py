import os
import logging
from dotenv import load_dotenv


load_dotenv()


LOG_LEVEL = os.getenv('LOG_LEVEL').upper()
GREETING_MESSAGE = os.getenv('GREETING_MESSAGE')
APP_VERSION = os.getenv('APP_VERSION')
ENV = os.getenv('ENV')
NUMERIC_LOG_LEVEL = getattr(logging, LOG_LEVEL, logging.INFO)