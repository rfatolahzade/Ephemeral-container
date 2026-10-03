# Ephemeral Container

A tiny, tool-rich Alpine image used as an ephemeral container, init container, or general-purpose debug sidecar in Kubernetes.

## Images

**Docker Hub**
```bash
# Pull the latest stable build
docker pull rfinland/ephemeral-container:latest

# Pull a specific version tag
docker pull rfinland/ephemeral-container:v1.0.0

# Pull the beta build (if available)
docker pull rfinland/ephemeral-container:beta
```

**GitHub Container Registry (GHCR)**
```bash
docker pull ghcr.io/rfatolahzade/ephemeral-container:latest
docker pull ghcr.io/rfatolahzade/ephemeral-container:v1.0.0
```

## Included Tools

| Category | Tools |
|---|---|
| Core | bash, curl, wget, ca-certificates |
| DNS | bind-tools (dig, nslookup, host) |
| Network | iputils, iproute2, net-tools, tcpdump, nmap, mtr, traceroute, socat |
| System | htop, procps-ng, strace, lsof, sysstat |
| DB / Cache | postgresql16-client, mariadb-client, redis |
| Data | jq, yq |
| Misc | vim, less, tree, telnet, busybox-extras |
| DevOps CLIs | kubectl, helm, vault, argocd, terraform |

## Usage
Start an interactive bash shell inside the container:
```bash
docker run -it --rm rfinland/ephemeral-container:latest bash
```
Test tools directly without opening an interactive session:
```bash
# Check DevOps CLI versions
docker run --rm rfinland/ephemeral-container:latest kubectl version --client
docker run --rm rfinland/ephemeral-container:latest vault version
docker run --rm rfinland/ephemeral-container:latest terraform version

# Check network tools
docker run --rm rfinland/ephemeral-container:latest curl -I https://github.com
docker run --rm rfinland/ephemeral-container:latest dig google.com

# Check database clients
docker run --rm rfinland/ephemeral-container:latest psql --version
docker run --rm rfinland/ephemeral-container:latest redis-cli --version
```
For kubernetes:
```bash
kubectl debug -it <pod-name> --image=rfinland/ephemeral-container:latest --target=<container-name>

UPDATING...
```
