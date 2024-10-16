#!/bin/bash

GITHUB_CONFIG_URL=""
GITHUB_PAT=""
ARC_NAMESPACE="arc-systems"
RUNNER_NAMESPACE="arc-runners"
GH_PAT_SECRET_NAME="arc-runner-gh-pat"

# 1. Installing Actions Runner Controller
if helm status arc --namespace "${ARC_NAMESPACE}" > /dev/null 2>&1; then
    echo "Helm release arc already exists. Skipping installation."
else
    echo "Helm release arc does not exist. Proceeding with installation."
    helm upgrade --install arc \
        --namespace "${ARC_NAMESPACE}" \
        --create-namespace \
        oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set-controller
fi


# 2. Add GITHUB PAT as a kube secret
if ! kubectl get secret ${GH_PAT_SECRET_NAME} --namespace=${RUNNER_NAMESPACE} > /dev/null 2>&1; then
    echo "Secret ${GH_PAT_SECRET_NAME} does not exist. Creating..."
    kubectl create secret generic ${GH_PAT_SECRET_NAME} \
        --namespace=${RUNNER_NAMESPACE} \
        --from-literal=github_token="${GITHUB_PAT}"
else
    echo "Secret ${GH_PAT_SECRET_NAME} already exists. Skipping creation."
fi


# 2. Configure a runner scale set
INSTALLATION_NAME="arc-runner-set"

if helm status "${INSTALLATION_NAME}" --namespace "${RUNNER_NAMESPACE}" > /dev/null 2>&1; then
    echo "Helm release ${INSTALLATION_NAME} already exists. Skipping installation."
    helm upgrade --install "${INSTALLATION_NAME}" \
        --namespace "${RUNNER_NAMESPACE}" \
        --create-namespace \
        --set githubConfigUrl="${GITHUB_CONFIG_URL}" \
        --set githubConfigSecret="${GH_PAT_SECRET_NAME}" \
        oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set

else
    echo "Helm release ${INSTALLATION_NAME} does not exist. Proceeding with installation."
fi