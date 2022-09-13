FROM ubuntu:22.04

RUN apt-get update
RUN apt-get install -y curl git

# INSTALL KUBECONFORM
ENV KUBECONFORM_VERSION=v0.4.13
ENV KUBECONFORM_SHA256SUM=690ff27e79d634d98fe2597df522237c9eb7ad2f6ed207dd67b68c74e9f1ba9c
RUN curl -LO https://github.com/yannh/kubeconform/releases/download/${KUBECONFORM_VERSION}/kubeconform-linux-amd64.tar.gz && \
    echo "${KUBECONFORM_SHA256SUM}  kubeconform-linux-amd64.tar.gz" | sha256sum -c
RUN tar -xvf kubeconform-linux-amd64.tar.gz -C /usr/local/bin


# INSTALL KUSTOMIZE
ENV KUSTOMIZE_VERSION=3.6.1
ENV KUSTOMIZE_SHA256SUM=0aeca6a054183bd8e7c29307875c8162aba6d2d4e170d3e7751aa78660237126
RUN curl -LO https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VERSION}/kustomize_v${KUSTOMIZE_VERSION}_linux_amd64.tar.gz && \
    echo "${KUSTOMIZE_SHA256SUM}  kustomize_v${KUSTOMIZE_VERSION}_linux_amd64.tar.gz" | sha256sum -c
RUN tar -xzf kustomize_v${KUSTOMIZE_VERSION}_linux_amd64.tar.gz --directory /usr/local/bin

# SET KUBECONFORM ENVS
# Skipping all currently applied CRD (adding CustomResourceDefinition itself as it blocks argocd appset validation)
ENV SKIP=AnalysisRun,AnalysisTemplate,Application,AppProject,AuthRequest,Backup,BackupStorageLocation,\
CertificateRequest,Certificate,Challenge,ClusterIssuer,Connector,DeleteBackupRequest,DownloadRequest,ENIConfig,\
Experiment,Issuer,KfDef,OAuth2Client,OfflineSessions,Order,Password,PodVolumeBackup,PodVolumeRestore,\
RefreshToken,ResticRepository,Restore,Rollout,Schedule,SealedSecret,SecurityGroupPolicy,SeldonDeployment,\
ServerStatusRequest,ServiceProfile,SigningKey,TrafficSplit,VolumeSnapshotLocation,WorkflowTemplate,\
CustomResourceDefinition

ENV K8S_VERSIONS=1.20.15,1.21.13

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
