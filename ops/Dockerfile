FROM python:3.8-alpine
WORKDIR /app

# Install necessary dependencies
RUN apk add --no-cache curl tar

# Install AWS CLI
RUN pip install --upgrade pip \
    && pip install awscli

# Install EKS CLI
RUN curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp && \
    mv /tmp/eksctl /usr/local/bin

# Verify the EKS CLI installation
RUN aws --version && eksctl version

# Make port 80 available to the world outside this container
EXPOSE 80

# Run the command inside your image filesystem
CMD [ "sh" ]
