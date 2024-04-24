# Validate Kubernetes Manifests

GitHub reusable workflow to run Kubernetes manifest validation using Attest internal validation image

## Usage

To use this workflow, add a new workflow file to your `.github/workflows` directory containing the following:
```yaml
name: Validate Kubernetes Manifests
on:
  - pull_request
  - workflow_dispatch

jobs:
  validate-kubernetes-manifests:
    uses: attest/kubernetes-manifest-validation/.github/workflows/validate.yaml@v1.1.1
    secrets:
      AWS_ACCESS_KEY: ${{ secrets.AWS_ACCESS_KEY_ID }}
      AWS_SECRET_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
      PAT_ATTEST_ADMIN_CI: ${{ secrets.PAT_ATTEST_ADMIN_CI }}
      VALIDATION_IMAGE: 391094253726.dkr.ecr.eu-west-1.amazonaws.com/kubernetes-manifest-validation
```

This workflow will look for manifests in either the `k8s` or `.infra/k8s` directory. If your repository has 
subdirectories containing manifests, you can specify these using the `service` field. Given a repository with
manifests in the `maker` and `taker` subdirectories, it can be configured like this:
```yaml
validate-kubernetes-manifests:
  uses: attest/kubernetes-manifest-validation/.github/workflows/validate.yaml@v1.1.1
  with:
    service: 'maker,taker'
  secrets:
    ...
```
