#!/bin/bash

GITHUB_CONFIG_URL=""
GITHUB_PAT=""
ARC_NAMESPACE="arc-systems"
RUNNER_NAMESPACE="arc-runners"


# 1. Installing Actions Runner Controller

helm upgrade --install arc \
    --namespace "${ARC_NAMESPACE}" \
    --create-namespace \
    oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set-controller

# 2. Add GITHUB PAT as a kube secret
kubectl create secret generic pre-defined-secret \
   --namespace=arc-runners \
   --from-literal=github_token="${GITHUB_PAT}"


# 2. Configure a runner scale set
INSTALLATION_NAME="arc-runner-set"

helm install "${INSTALLATION_NAME}" \
    --namespace "${RUNNER_NAMESPACE}" \
    --create-namespace \
    --set githubConfigUrl="${GITHUB_CONFIG_URL}" \
    --set githubConfigSecret.github_token="${GITHUB_PAT}" \
    oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set
