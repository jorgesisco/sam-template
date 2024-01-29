# Serverless Application Model Template

## Overview
This repo holds the code for the Serverless Application Model template. It stores the code for a single Lambda Handler. 
## Prerequisites
 - [Docker](https://docs.docker.com/get-docker/)
 - [Docker Compose](https://docs.docker.com/compose/install/)
 - [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)


## Getting Started
### Setup

1. cd to the directory of any of the lambda functions
2. Run build command
```commandline
make build
```
3. Run the docker-compose command
```commandline
make run
```
4. Test the function locally
The INFO.md file in each lambda directory contains instructions on how to test the function locally.


## Lambda Invoke Documentation



## Invoke Locally

### ** Invoke Locally with Docker **

Assuming Docker is buit already, run the following command to run container locally:

```bash
make run
```

The container will be running at port 9000. To invoke the lambda, run the following command:

### Note:
When providing `filename`, the code will process only one file, if you want to process multiple emails, avoid providing `filename` and provide `bucket` and `prefixes` instead.


### 1. Using cURL
```bash
curl --location 'http://localhost:9000/2015-03-31/functions/function/invocations' \
--header 'Content-Type: application/json' \
--data '{
    "body": {
        "data": "**{data payload}"
    }
}
}'
```

### 2. Using Python

```python
import requests
import json

url = "http://localhost:9000/2015-03-31/functions/function/invocations"

payload = json.dumps({
    "body": {
        "data": "**{data payload}"
    }
})
headers = {
  'Content-Type': 'application/json'
}

response = requests.request("POST", url, headers=headers, data=payload)

print(response.text)
```

### Simulating SQS event with the API

Use the following request body:

```commandline
{
    "Records": [
        {
            "messageId": "ad954b29-7b861267c24c",
            "receiptHandle": "/fFcg++/////++/FPiNy1zQ==",
            "body": "{\"message\": \"Success\", \"data\": **{payload}}",
            "attributes": {
                "ApproximateReceiveCount": "1",
                "SentTimestamp": "1703941724276",
                "SenderId": "AIDARMBPL2YW26BH5SYTY",
                "ApproximateFirstReceiveTimestamp": "1703941724281"
            },
            "messageAttributes": {},
            "md5OfBody": "e54352435jntl5jbt5k4tn",
            "eventSource": "aws:sqs",
            "eventSourceARN": "arn:aws:sqs:eu-central-1:<account_id>:lamnda_name",
            "awsRegion": "eu-central-1"
        }
    ]
}
```

Handler code will go an retrieve the body data from the SQS first event.
As you can see in the above structure, Records is a list of events, so you can simulate multiple events.


## Invoke Deployed Lambda

### 1. Using the API Gateway

Same as the previous examples, but using the API Gateway URL instead of localhost.
Also DO NOT enclose the data in the `body` key.

Example:
```json
{
    "data": **{data}
}
```