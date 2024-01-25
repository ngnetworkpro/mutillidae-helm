#!/bin/bash

err_code=0

kubectl version --client=true

cluster=${!ORB_ENV_GKE_CLUSTER}

gcloud container clusters get-credentials "${cluster}" || err_code=1

kubectl config get-contexts || err_code=2

kubectl version --client=false || err_code=3

# Google Artifact Registry
mkdir -p "$HOME/.docker"
if [[ "$ORB_VAL_REGISTRY_URL" == *"docker.pkg.dev" ]]; then
    gcloud auth configure-docker --quiet "$ORB_VAL_REGISTRY_URL" || err_code=4
else
    gcloud auth configure-docker --quiet || err_code=4
fi

case "${err_code}" in 
  1)
    echo "Failed authentication with Google Cloud.  Check JSON credential is properly defined as GCLOUD_SERVICE_KEY in circleci context."
    exit 1
    ;;
  2)
    echo "Failed to render the Kubernetes configuration. Check that JSON credential has loaded and compute region matches cluster."
    exit 1
    ;;
  3)
    echo "Failed to connect to Kubernetes API. Check job is running within authorized network. circleci_ip_ranges: true"
    exit 1
    ;;
  4)
    echo "Failed to connect to authenticate Docker Registry. Checkt that service account is granted roles/artifactregistry.reader."
    exit 1
    ;;
esac