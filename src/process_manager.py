import json
from src import logger, session



def process_event(event) -> dict:
    """
    Process the event based on its type (SQS or API Gateway).

    Args:
        event: Lambda event
    Returns:
        str: Success message
    """
    data = get_payload(event)['data']

    # Implement function code below

    return data


def get_payload(event) -> dict:
    """
    Extract payload from the event.

    Args:
        event: Lambda event
    Returns:
        dict: Payload
    """
    if 'Records' in event:
        # Handling SQS event
        record = event['Records'][0]['body']

        return json.loads(record)

    elif 'body' in event:
        # Handling API Gateway event
        payload = event['body']

        # Check if the payload is already a dictionary (which might be the case in some scenarios)
        if not isinstance(payload, dict):
            # If it's not a dictionary, it's likely a JSON string, so try to parse it.
            try:
                payload = json.loads(payload)
            except json.JSONDecodeError:
                # If the string isn't valid JSON, raise a more informative error.
                raise ValueError("API Gateway message body is not valid JSON")
        return payload  # Return the parsed payload

    else:
        raise ValueError("Invalid event structure")