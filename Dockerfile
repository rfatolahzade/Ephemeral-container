# ==========================================
# Stage 1: Builder (Downloads and cleans up)
# ==========================================
FROM alpine:3.19 AS builder

ARG TARGETOS=linux
ARG TARGETARCH=amd64

ENV KUBECTL_VERSION=v1.29.2 \
    HELM_VERSION=v3.14.2 \
    VAULT_VERSION=1.15.4 \
    ARGOCD_VERSION=v2.10.3 \
    TERRAFORM_VERSION=1.7.5

# Download, extract, and CLEAN UP archives in a single layer
RUN apk add --no-cache curl unzip && \
    mkdir -p /tmp/devops && cd /tmp/devops && \
    \
    curl -fsSLO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/${TARGETOS}/${TARGETARCH}/kubectl" && \
    chmod +x kubectl && \
    \
    curl -fsSL "https://get.helm.sh/helm-${HELM_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz" | tar xz && \
    mv ${TARGETOS}-${TARGETARCH}/helm . && rm -rf ${TARGETOS}-${TARGETARCH} && \
    \
    curl -fsSLO "https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_${TARGETOS}_${TARGETARCH}.zip" && \
    unzip -q vault_${VAULT_VERSION}_${TARGETOS}_${TARGETARCH}.zip && \
    rm vault_${VAULT_VERSION}_${TARGETOS}_${TARGETARCH}.zip && \
    \
    curl -fsSLO "https://github.com/argoproj/argo-cd/releases/download/${ARGOCD_VERSION}/argocd-${TARGETOS}-${TARGETARCH}" && \
    mv argocd-${TARGETOS}-${TARGETARCH} argocd && chmod +x argocd && \
    \
    curl -fsSLO "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_${TARGETOS}_${TARGETARCH}.zip" && \
    unzip -q terraform_${TERRAFORM_VERSION}_${TARGETOS}_${TARGETARCH}.zip && \
    rm terraform_${TERRAFORM_VERSION}_${TARGETOS}_${TARGETARCH}.zip

# ==========================================
# Stage 2: Final Production Image
# ==========================================
FROM alpine:3.19

# Install OS-level utilities (Your exact pinned versions)
RUN apk update && \
    apk add --no-cache \
    bash=5.2.21-r0 busybox-extras=1.36.1-r21 coreutils=9.4-r2 tzdata=2025b-r0 \
    bind-tools=9.18.44-r0 curl=8.14.1-r2 wget=1.21.4-r0 iputils=20221126-r2 iproute2=6.6.0-r0 net-tools=2.10-r3 tcpdump=4.99.4-r1 nmap=7.94-r0 nmap-scripts=7.94-r0 mtr=0.95-r2 traceroute=2.1.3-r0 socat=1.8.0.0-r0 netcat-openbsd=1.226-r0 openssl=3.1.8-r1 \
    htop=3.2.2-r1 procps-ng=4.0.4-r0 strace=6.6-r0 lsof=4.99.0-r0 sysstat=12.6.2-r0 util-linux=2.39.3-r0 \
    jq=1.7.1-r0 yq=4.35.2-r4 \
    vim=9.0.2127-r0 less=643-r2 tree=2.1.1-r0 tar=1.35-r2 gzip=1.13-r0 unzip=6.0-r14 7zip=23.01-r0 \
    postgresql16-client=16.11-r0 mariadb-client=10.11.14-r0 redis=7.2.9-r0 \
    git=2.43.7-r0 openssh-client-default=9.6_p1-r2 ca-certificates=20250911-r0 \
    && rm -rf /var/cache/apk/*

# Copy ONLY the specific binaries (No wildcards, no directories)
COPY --from=builder /tmp/devops/kubectl /usr/local/bin/
COPY --from=builder /tmp/devops/helm /usr/local/bin/
COPY --from=builder /tmp/devops/vault /usr/local/bin/
COPY --from=builder /tmp/devops/argocd /usr/local/bin/
COPY --from=builder /tmp/devops/terraform /usr/local/bin/

SHELL ["/bin/bash", "-c"]
ENV TZ=UTC
CMD ["sleep", "infinity"]
