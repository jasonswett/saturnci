FROM python:3.8-alpine
WORKDIR /app

# Install necessary dependencies
RUN apk add --no-cache curl tar bash openssl

# Install AWS CLI
RUN pip install --upgrade pip \
    && pip install awscli

# Install EKS CLI
RUN curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp && \
    mv /tmp/eksctl /usr/local/bin

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && chmod +x kubectl \
    && mv kubectl /usr/local/bin/

# Install Helm
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 \
    && chmod 700 get_helm.sh \
    && ./get_helm.sh \
    && rm get_helm.sh

# Verify the AWS CLI, EKS CLI, and kubectl installations
RUN aws --version && eksctl version && kubectl version --client

# Make port 80 available to the world outside this container
EXPOSE 80

# Run the command inside your image filesystem
CMD [ "sh" ]
