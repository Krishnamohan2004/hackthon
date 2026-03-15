#!/bin/bash

# Log everything
exec > /var/log/install-script.log 2>&1

echo "Starting DevOps Tools Installation..."

#############################################
# Update system
#############################################

sudo apt update -y
sudo apt upgrade -y

#############################################
# Install Docker
#############################################

sudo apt install docker.io -y
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker ubuntu

#############################################
# Install AWS CLI
#############################################

sudo apt install unzip -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

#############################################
# Install dependencies
#############################################

sudo apt install wget curl gnupg software-properties-common apt-transport-https ca-certificates -y

#############################################
# Install Trivy (Security Scanner)
#############################################

wget https://aquasecurity.github.io/trivy-repo/deb/public.key
sudo apt-key add public.key

echo "deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" \
| sudo tee /etc/apt/sources.list.d/trivy.list

sudo apt update
sudo apt install trivy -y

#############################################
# Install kubectl
#############################################

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

chmod +x kubectl
sudo mv kubectl /usr/local/bin/

kubectl version --client

#############################################
# Install Helm (Kubernetes Package Manager)
#############################################

curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

helm version

#############################################
# Run SonarQube Container
#############################################

sudo docker run -d \
--name sonarqube \
-p 9000:9000 \
sonarqube:lts

#############################################
# Install Prometheus & Grafana in Kubernetes
#############################################

echo "Installing Prometheus Monitoring Stack in Kubernetes..."

# Add Helm repository
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Create monitoring namespace
kubectl create namespace monitoring || true

# Install kube-prometheus-stack
helm install monitoring prometheus-community/kube-prometheus-stack \
--namespace monitoring

#############################################
# Wait for monitoring pods
#############################################

sleep 30

kubectl get pods -n monitoring

#############################################
# Show important services
#############################################

echo "Monitoring services"

kubectl get svc -n monitoring

#############################################
# Show running ports
#############################################

sudo ss -tulnp | grep -E "9000"

echo "Installation Completed Successfully!"
