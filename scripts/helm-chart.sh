#!/bin/bash
# shellcheck disable=SC2086

if [ -n "${ORB_PARAM_NAMESPACE}" ]; then
  set -- "$@" --namespace="$(eval echo ${ORB_PARAM_NAMESPACE})"
fi
if [ -n "${TIMEOUT}" ]; then
  set -- "$@" --timeout "${TIMEOUT}"
fi
if [ -n "${NO_HOOKS}" ]; then
  set -- "$@" --no-hooks="${NO_HOOKS}"
fi
if [ "${RECREATE_PODS}"  == "true" ]; then
  set -- "$@" --recreate-pods
fi
if [ "${ATOMIC}" == "true" ]; then
  set -- "$@" --atomic
fi
if [ "${ORB_PARAM_WAIT}" == "true" ]; then
  set -- "$@" --wait
fi
if [ -n "${DEVEL}" ]; then
  set -- "$@" --devel "${DEVEL}"
fi
if [ "${DRY_RUN}" == "true" ]; then
  set -- "$@" --dry-run
fi
if [ "${RESET_VALUES}" == "true" ]; then
  set -- "$@" --reset-values
fi
if [ "${REUSE_VALUES}" == "true" ]; then
  set -- "$@" --reuse-values
fi
if [ -n "${VALUES}" ]; then
  set -- "$@" --values "$(eval echo ${VALUES})"
fi
if [ -n "${VALUES_TO_OVERRIDE}" ]; then
  set -- "$@" --set "$(eval echo ${VALUES_TO_OVERRIDE})"
fi
if [ -n "${VERSION}" ]; then
  set -- "$@" --version="$(eval echo ${VERSION})"
fi

ORB_PARAM_RELEASE_NAME=$(eval echo ${ORB_PARAM_RELEASE_NAME})

if [[ "$ORB_PARAM_REPO" =~ https* ]]; then

  helm repo add "charts" "${ORB_PARAM_REPO}"
  helm repo update

  helm upgrade --install "${ORB_PARAM_RELEASE_NAME}" "charts/${ORB_PARAM_CHART}" --create-namespace "$@"
else
  helm upgrade --install "${ORB_PARAM_RELEASE_NAME}" "${ORB_PARAM_REPO}/${ORB_PARAM_CHART}" --create-namespace "$@"
fi