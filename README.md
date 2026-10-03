# Ephemeral Container

A tiny, tool-rich Alpine image used as an **ephemeral container**, **init container**, or a general-purpose debug sidecar in Kubernetes.

Built and published automatically to **GitHub Container Registry (GHCR)** via GitHub Actions.

## 📦 Image

```
ghcr.io/rfatolahzade/ephemeral-container:latest
ghcr.io/rfatolahzade/ephemeral-container:master
ghcr.io/rfatolahzade/ephemeral-container:sha-<commit>
ghcr.io/rfatolahzade/ephemeral-container:v1.2.3   # on tag push
```

## 🛠 Included tools

| Category | Tools |
|---|---|
| Core | `bash`, `curl`, `wget`, `ca-certificates` |
| DNS | `bind-tools` (`dig`, `nslookup`, `host`) |
| Network | `iputils`, `iproute2`, `net-tools`, `tcpdump`, `nmap`, `nmap-scripts`, `mtr`, `traceroute`, `socat` |
| System | `htop`, `procps`, `strace`, `lsof`, `sysstat` |
| DB / Cache | `postgresql16-client`, `mysql-client`, `redis` |
| Data | `jq`, `yq` |
| Misc | `vim`, `less`, `tree`, `telnet`, `busybox-extras` |

## 🚀 Usage

### Pull the image

```bash
# Public package
docker pull ghcr.io/rfatolahzade/ephemeral-container:latest

# Private package
echo $CR_PAT | docker login ghcr.io -u <your-user> --password-stdin
docker pull ghcr.io/rfatolahzade/ephemeral-container:latest
```

### Use as an ephemeral container (kubectl debug)

```bash
kubectl debug -it <pod-name> \
  --image=ghcr.io/rfatolahzade/ephemeral-container:latest \
  --target=<container-name>
```

### Use as an init container

See [`k8s/init-container.yaml`](k8s/init-container.yaml).

### Use as a standalone pod

```bash
kubectl apply -f k8s/pod.yaml
kubectl exec -it troubleshooter -- bash
```

## 🔐 Kubernetes pull secret (`regcred`)

If the GHCR package is **private**, create a pull secret:

```bash
kubectl create secret docker-registry regcred \
  --docker-server=ghcr.io \
  --docker-username=<github-username> \
  --docker-password=<PAT-with-read:packages> \
  --docker-email=<your-email>
```

Then reference it from your pod spec:

```yaml
spec:
  imagePullSecrets:
    - name: regcred
```

## 🔄 CI / CD

Every push to `master` (and every `v*.*.*` tag) triggers `.github/workflows/ci.yml`, which:

1. Builds the image with Buildx.
2. Caches layers with `type=gha` for fast rebuilds.
3. Pushes to GHCR with multiple tags.

No extra secrets are needed — the workflow authenticates with the built-in `GITHUB_TOKEN`.

## 📝 License

MIT
