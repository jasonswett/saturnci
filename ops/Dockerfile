# Use an official Python runtime as a parent image
FROM python:3.8-alpine

# Set the working directory in the container to /app
WORKDIR /app

# Install AWS CLI
RUN pip install --upgrade pip \
    && pip install awscli

# Make port 80 available to the world outside this container
EXPOSE 80

# Run the command inside your image filesystem
CMD [ "sh" ]
