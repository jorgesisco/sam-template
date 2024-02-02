from aws_lambda_powertools import Logger
import os
from dotenv import load_dotenv
from src.aws.session import create_aws_session

load_dotenv()
region = os.getenv("REGION")

logger = Logger()

session = create_aws_session(region_name=region,
                             # aws_access_key_id=aws_key,
                             # aws_secret_access_key=aws_secret_key
                             )
