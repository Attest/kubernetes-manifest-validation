#!/bin/bash

set -euo pipefail

echo "Validating Kubernetes Manifests..."
echo "KubeConform version:"
kubeconform -v
echo "Kustomize version:"
kustomize version

DIR_ROOT="/github/workspace"

for service in $(echo "$2" | sed "s/,/ /g")
do
  cd $DIR_ROOT/$service
  cd k8s || cd .infra/k8s
  # Dynamically finding overlays to validate if envs is set to 'auto'
  envs=$1
  if [[ $envs == 'auto' ]]; then
    envs=$(find ./overlays -mindepth 1 -maxdepth 1 -type d -printf '%f,')
  fi
  for version in $(echo $K8S_VERSIONS | sed "s/,/ /g")
  do
    for env in $(echo $envs | sed "s/,/ /g")
    do
      echo "validating $service in $env for k8s version $version"
      # Due to https://github.com/yannh/kubeconform/issues/100 it is necessary to define the schema locations in
      # order for CRDs to pass validation.
      kustomize build overlays/$env | kubeconform \
        -schema-location "default" \
        -schema-location "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/{{ .NormalizedKubernetesVersion }}/{{ .ResourceKind }}{{ .KindSuffix }}.json" \
        -summary \
        -skip "$SKIP" \
        -kubernetes-version "$version" \
        -
      done
    done
  done
