import json
from aws_lambda_powertools.utilities.typing import LambdaContext

from pathlib import Path
import sys
sys.path.append(str(Path(__file__).resolve().parent.parent))
from src import logger
from src.process_manager import process_event

def handler(event, context: LambdaContext) -> dict:
    """Lambda handler for processing events."""
    try:
        logger.info(f"event: {event}")
        data = process_event(event)

        return data



    except Exception as e:
        logger.error(f"Error processing message: {e}")
        return {
            "statusCode": 500,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({
                "message": "Error",
                "data": str(e),
            }),
        }
