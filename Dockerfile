# ==========================================
# Stage 1: Builder (Downloads DevOps binaries)
# ==========================================
FROM alpine:3.19 AS builder

ARG TARGETOS
ARG TARGETARCH

ENV KUBECTL_VERSION=v1.29.2 \
    HELM_VERSION=v3.14.2 \
    VAULT_VERSION=1.15.4 \
    ARGOCD_VERSION=v2.10.3 \
    TERRAFORM_VERSION=1.7.5

# Install ONLY what is needed for downloading/extracting
RUN apk add --no-cache curl unzip

WORKDIR /tmp/devops-tools

# Download and extract all binaries
RUN curl -fsSLO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${TARGETARCH}/kubectl" && \
    chmod +x kubectl && \
    curl -fsSL "https://get.helm.sh/helm-${HELM_VERSION}-linux-${TARGETARCH}.tar.gz" | tar xz && \
    curl -fsSLO "https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_${TARGETARCH}.zip" && \
    unzip -q vault_${VAULT_VERSION}_linux_${TARGETARCH}.zip && \
    curl -fsSLO "https://github.com/argoproj/argo-cd/releases/download/${ARGOCD_VERSION}/argocd-linux-${TARGETARCH}" && \
    chmod +x argocd-linux-${TARGETARCH} && \
    curl -fsSLO "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${TARGETARCH}.zip" && \
    unzip -q terraform_${TERRAFORM_VERSION}_linux_${TARGETARCH}.zip

# ==========================================
# Stage 2: Final Production Image
# ==========================================
FROM alpine:3.19

# Install OS-level utilities (Using your exact pinned versions)
RUN apk update && \
    apk add --no-cache \
    # --- Core & Shell ---
    bash=5.2.21-r0 \
    busybox-extras=1.36.1-r21 \
    coreutils=9.4-r2 \
    tzdata=2025b-r0 \
    \
    # --- Network Troubleshooting ---
    bind-tools=9.18.44-r0 \
    curl=8.14.1-r2 \
    wget=1.21.4-r0 \
    iputils=20221126-r2 \
    iproute2=6.6.0-r0 \
    net-tools=2.10-r3 \
    tcpdump=4.99.4-r1 \
    nmap=7.94-r0 \
    nmap-scripts=7.94-r0 \
    mtr=0.95-r2 \
    traceroute=2.1.3-r0 \
    socat=1.8.0.0-r0 \
    netcat-openbsd=1.226-r0 \
    openssl=3.1.8-r1 \
    \
    # --- System & Process Monitoring ---
    htop=3.2.2-r1 \
    procps-ng=4.0.4-r0 \
    strace=6.6-r0 \
    lsof=4.99.0-r0 \
    sysstat=12.6.2-r0 \
    util-linux=2.39.3-r0 \
    \
    # --- Data & Config Parsing ---
    jq=1.7.1-r0 \
    yq=4.35.2-r4 \
    \
    # --- Editors & File Management ---
    vim=9.0.2127-r0 \
    less=643-r2 \
    tree=2.1.1-r0 \
    tar=1.35-r2 \
    gzip=1.13-r0 \
    unzip=6.0-r14 \
    7zip=23.01-r0 \
    \
    # --- Database & Cache Clients ---
    postgresql16-client=16.11-r0 \
    mariadb-client=10.11.14-r0 \
    redis=7.2.9-r0 \
    \
    # --- DevOps & Remote Access ---
    git=2.43.7-r0 \
    openssh-client-default=9.6_p1-r2 \
    ca-certificates=20250911-r0 \
    \
    # --- Cleanup ---
    && rm -rf /var/cache/apk/*

# Copy ONLY the extracted binaries from the builder stage
# This leaves the temporary curl/unzip tools and archives behind, saving space!
COPY --from=builder /tmp/devops-tools/kubectl /usr/local/bin/
COPY --from=builder /tmp/devops-tools/linux-*/helm /usr/local/bin/
COPY --from=builder /tmp/devops-tools/vault /usr/local/bin/
COPY --from=builder /tmp/devops-tools/argocd-linux-* /usr/local/bin/argocd
COPY --from=builder /tmp/devops-tools/terraform /usr/local/bin/

# Set a useful default shell
SHELL ["/bin/bash", "-c"]

# Set a default timezone
ENV TZ=UTC

# Default command: keep container alive for ephemeral debugging
CMD ["sleep", "infinity"]
