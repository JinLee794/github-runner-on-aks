#!/bin/bash

# azurecli install
if ! command -v az &> /dev/null
then
    echo "Azure CLI not found. Installing..."
    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
else
    echo "Azure CLI is already installed."
fi

# kubectl install
if ! command -v kubectl &> /dev/null
then
    echo "kubectl not found. Installing..."

    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

    if ! grep -q 'alias k=kubectl' ~/.bashrc; then
        echo 'alias k=kubectl' >> ~/.bashrc
        source ~/.bashrc
    fi
else
    echo "kubectl is already installed."
fi

# helm install
if ! command -v helm &> /dev/null
then
    echo "Helm not found. Installing..."
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
    chmod 700 get_helm.sh
    ./get_helm.sh
else
    echo "Helm is already installed."
fi

# kubelogin install
if ! command -v kubelogin &> /dev/null
then
    echo "kubelogin not found. Installing..."
    # KUBELOGIN_VERSION=$(curl -s https://api.github.com/repos/Azure/kubelogin/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
    # curl -LO "https://github.com/Azure/kubelogin/releases/download/${KUBELOGIN_VERSION}/kubelogin-linux-amd64.zip"
    # unzip kubelogin-linux-amd64.zip -d kubelogin
    # sudo install -o root -g root -m 0755 kubelogin/bin/linux_amd64/kubelogin /usr/local/bin/kubelogin
    # rm -rf kubelogin kubelogin-linux-amd64.zip
    
    # sudo may be required
    sudo az aks install-cli

else
    echo "kubelogin is already installed."
fi