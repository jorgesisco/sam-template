# python3.11 lambda base image
FROM public.ecr.aws/lambda/python:3.11

# Allows local access with VSC
RUN yum update -y && \
    yum install -y tar gzip

# Copy function code to container
COPY . ./

# upgrading pip
RUN pip3 install --upgrade pip

# installing dependencies
RUN pip3 install -r requirements.txt

# setting the CMD to your handler file_name.function_name
CMD [ "src.process.handler" ]