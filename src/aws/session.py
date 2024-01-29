"""
==========================
AWS Session Creator Module
==========================
"""

from boto3 import Session


def create_aws_session(region_name: str,
                       aws_access_key_id=None,
                       aws_secret_access_key=None,
                       ):
    """
    Create and return a boto3 session for the Lambda's
    execution context.

    Args:
        region_name
        aws_access_key_id
        aws_secret_access_key

    Returns:
        AWS Session
    """
    return Session(region_name=region_name,
                   aws_access_key_id=aws_access_key_id,
                   aws_secret_access_key=aws_secret_access_key)
