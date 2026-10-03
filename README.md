# Ephemeral Container

A tiny, tool-rich Alpine image used as an ephemeral container, init container, or general-purpose debug sidecar in Kubernetes.

## Images

**Docker Hub**
```bash
docker pull rfinland/ephemeral-container:latest
docker pull rfinland/ephemeral-container:v1.0.0
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

```bash
kubectl debug -it <pod-name> --image=rfinland/ephemeral-container:latest --target=<container-name>
```
