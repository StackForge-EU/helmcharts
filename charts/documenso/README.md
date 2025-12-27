# ☸️ Documenso Helm Chart

Maintained by [StackForge](https://stack-forge.eu)

A Helm chart for deploying [Documenso](https://documenso.com), the open-source DocuSign alternative, on Kubernetes. This chart provisions Documenso along with a Cloud Native Postgres cluster.

## 📋 Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- **[CloudNativePG Operator](https://cloudnative-pg.io/)** must be installed in the cluster if `postgres.create` is set to `true` (default). This chart creates a `Cluster` resource (apiVersion: `postgresql.cnpg.io/v1`).

## 🚀 Installation

### Add the repository

```bash
helm repo add stackforge https://stack-forge.eu
helm repo update
```

### Install the chart

```bash
helm install documenso stackforge/documenso \
  --set config.baseUrl="https://documenso.your-domain.com"
```

> **Note:** You must set `config.baseUrl` to the URL where Documenso will be accessible.

## 🗑️ Uninstallation

To uninstall/delete the `documenso` deployment:

```bash
helm delete documenso
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## ⚙️ Configuration

The following table lists the configurable parameters of the Documenso chart and their default values.

### General Parameters

| Key                | Description                                        | Default               |
| ------------------ | -------------------------------------------------- | --------------------- |
| `image.repository` | Documenso image repository                         | `documenso/documenso` |
| `image.tag`        | Documenso image tag                                | `v2.3.1`              |
| `image.pullPolicy` | Image pull policy                                  | `IfNotPresent`        |
| `imagePullSecrets` | Secrets for pulling images from a private registry | `[]`                  |
| `nameOverride`     | Override the name of the chart                     | `""`                  |
| `fullnameOverride` | Override the full name of the chart                | `""`                  |

### Application Configuration

| Key                        | Description                                     | Default                           |
| -------------------------- | ----------------------------------------------- | --------------------------------- |
| `config.baseUrl`           | **Required.** The public URL of the application | `"https://documenso.example.com"` |
| `config.documentSizeLimit` | Upload limit for documents (in MB)              | `5`                               |
| `config.disableSignup`     | Disable new user signups                        | `false`                           |

### Secrets & Environment Variables

You can provide sensitive configuration via `secret` values. If `existingSecret` is set, these values are ignored.

| Key                                            | Description                                    | Default                            |
| ---------------------------------------------- | ---------------------------------------------- | ---------------------------------- |
| `existingSecret`                               | Name of an existing secret containing env vars | `""`                               |
| `secret.create`                                | Whether to create a new secret                 | `true`                             |
| `secret.NEXTAUTH_SECRET`                       | NextAuth secret                                | `""` (randomly generated if empty) |
| `secret.NEXT_PRIVATE_ENCRYPTION_KEY`           | Encryption key                                 | `""` (randomly generated if empty) |
| `secret.NEXT_PRIVATE_SMTP_HOST`                | SMTP Host                                      | `""`                               |
| `secret.NEXT_PRIVATE_SMTP_USERNAME`            | SMTP Username                                  | `""`                               |
| `secret.NEXT_PRIVATE_SMTP_PASSWORD`            | SMTP Password                                  | `""`                               |
| `secret.NEXT_PRIVATE_UPLOAD_BUCKET`            | S3 Bucket name                                 | `""`                               |
| `secret.NEXT_PRIVATE_UPLOAD_ACCESS_KEY_ID`     | S3 Access Key                                  | `""`                               |
| `secret.NEXT_PRIVATE_UPLOAD_SECRET_ACCESS_KEY` | S3 Secret Key                                  | `""`                               |

*See `values.yaml` for the full list of supported environment variables.*

### Database (CloudNativePG)

This chart deploys a Postgres cluster using the CloudNativePG operator.

| Key                             | Description                               | Default              |
| ------------------------------- | ----------------------------------------- | -------------------- |
| `postgres.create`               | Create a new Postgres cluster             | `true`               |
| `postgres.name`                 | Name of the Postgres cluster              | `documenso-postgres` |
| `postgres.instances`            | Number of Postgres instances              | `1`                  |
| `postgres.major`                | Postgres major version                    | `18`                 |
| `postgres.storage.size`         | Database storage size                     | `4Gi`                |
| `postgres.storage.storageClass` | Storage class for database PVC            | `""`                 |
| `postgres.enablePodMonitor`     | Enable Prometheus PodMonitor for Postgres | `true`               |

### Persistence

| Key                                 | Description                | Default             |
| ----------------------------------- | -------------------------- | ------------------- |
| `persistence.data.name`             | Name of the PVC            | `documenso-data`    |
| `persistence.data.storageSize`      | Size of the data volume    | `1Gi`               |
| `persistence.data.storageClassName` | Storage class for data PVC | `""`                |
| `persistence.data.accessModes`      | Access modes for data PVC  | `["ReadWriteMany"]` |

### Networking (Service & Ingress)

| Key                       | Description                       | Default |
| ------------------------- | --------------------------------- | ------- |
| `service.enabled`         | Enable Service                    | `true`  |
| `service.port`            | Service port                      | `3000`  |
| `ingress.enabled`         | Enable Ingress                    | `true`  |
| `ingress.annotations`     | Ingress annotations               | `{}`    |
| `ingress.hosts`           | Ingress hosts                     | `[]`    |
| `ipWhitelist.enabled`     | Enable IP whitelisting middleware | `false` |
| `ipWhitelist.sourceRange` | List of allowed CIDRs             | `[]`    |

### Security

| Key                                      | Description               | Default |
| ---------------------------------------- | ------------------------- | ------- |
| `podSecurityContext.fsGroup`             | Pod filesystem group ID   | `13001` |
| `securityContext.runAsUser`              | Container user ID         | `13001` |
| `securityContext.runAsGroup`             | Container group ID        | `13001` |
| `securityContext.readOnlyRootFilesystem` | Read-only root filesystem | `false` |

## 🔒 Security Notes

- The container runs as non-root user `13001` by default.
- `readOnlyRootFilesystem` is set to `false` by default as required by the application.
- Network Policies can be enabled to restrict traffic to Traefik and Cert-Manager.

## 💾 Persistence

The chart mounts a Persistent Volume at `/data` (configured via `persistence.data`). This is used for storing application data if not using S3/Object storage.

The database uses its own Persistent Volume Claims managed by the CloudNativePG operator.
