#!/bin/bash

# Pre-requisite:
# - Ensure the image is pushed to the registry before running this script.
# - Update the values.yaml to reference the pushed image (line 13)
# - Update the values.yaml to reference the correct secret name with `imagePullSecrets` (line 19)

REGISTRY_NAME=""
REGISTRY_USERNAME=""
REGISTRY_PASSWORD=""
IMAGE_NAME="actions/gha-runner-scale-set-controller:canary-96d1bbc"

kubectl create secret docker-registry acr-registry-secret \
  --docker-server="${REGISTRY_NAME}.azurecr.io" \
  --docker-username="${REGISTRY_USERNAME}" \
  --docker-password="${REGISTRY_PASSWORD}" \
  --docker-email="noreply@github.com"
# Upgrade or install the Actions Runner Controller (ARC) using Helm
# This command will either upgrade an existing installation or install a new one if it doesn't exist

echo "Upgrading or installing Actions Runner Controller (ARC)..."

helm upgrade --install arc \
    --namespace "${ARC_NAMESPACE}" \
    --create-namespace \
    --debug \
    --set imagePullSecrets[0].name=acr-registry-secret \
    --values values.yaml \
    oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set-controller

# Explanation of the command:
# helm upgrade --install: Upgrade if the release exists, install if it doesn't
# arc: Name of the Helm release
# --namespace "${ARC_NAMESPACE}": Install in the namespace specified by ARC_NAMESPACE
# --create-namespace: Create the namespace if it doesn't exist
# --debug: Enable verbose output for debugging
# --set imagePullSecrets[0].name=acr-registry-secret: Set the image pull secret to use
# --values values.yaml: Use values from the values.yaml file
# oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set-controller: OCI registry path for the Helm chart

echo "ARC installation/upgrade complete."
    
    #oci://${REGISTRY_NAME}.azurecr.io/${IMAGE_NAME}


        #oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set-controller