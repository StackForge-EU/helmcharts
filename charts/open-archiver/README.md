# Open Archiver Helm Chart

A Helm chart for deploying [Open Archiver](https://github.com/LogicLabs-OU/OpenArchiver) on Kubernetes with CloudNativePG for PostgreSQL, the official [Valkey Helm chart](https://github.com/valkey-io/valkey-helm), and the official [Meilisearch Helm chart](https://github.com/meilisearch/meilisearch-kubernetes).

## Prerequisites

- Kubernetes 1.25+
- Helm 3.x
- [CloudNativePG Operator](https://cloudnative-pg.io/) installed in the cluster
- A storage class that supports the required access modes

## Installation

```bash
helm repo add valkey https://valkey.io/valkey-helm/
helm repo add meilisearch https://meilisearch.github.io/meilisearch-kubernetes

helm install open-archiver ./charts/open-archiver \
  --namespace open-archiver \
  --create-namespace \
  --set config.appUrl="https://archive.yourdomain.com" \
  --set valkey.auth.aclUsers.default.password="your-secure-password" \
  --set secret.redisPassword="your-secure-password"
```

## Components

| Component     | Description                                        | Chart                                                                 |
| ------------- | -------------------------------------------------- | --------------------------------------------------------------------- |
| Open Archiver | Main application (frontend + backend)              | This chart                                                            |
| PostgreSQL    | Database via CloudNativePG operator                | [CNPG](https://cloudnative-pg.io/)                                    |
| Valkey        | Redis-compatible cache and job queue               | [valkey-helm](https://github.com/valkey-io/valkey-helm) (subchart)    |
| Meilisearch   | Full-text search engine                            | [meilisearch-kubernetes](https://github.com/meilisearch/meilisearch-kubernetes) (subchart) |
| Apache Tika   | Document text extraction                           | This chart                                                            |

## Configuration

### Required Values

| Parameter                                 | Description                                         |
| ----------------------------------------- | --------------------------------------------------- |
| `config.appUrl`                           | The public-facing URL of your application           |
| `valkey.auth.aclUsers.default.password`   | Password for Valkey default user                    |
| `secret.redisPassword`                    | Must match the Valkey password (used by the app)    |

### Application Settings

| Parameter                           | Default                     | Description                       |
| ----------------------------------- | --------------------------- | --------------------------------- |
| `image.repository`                  | `logiclabshq/open-archiver` | Container image                   |
| `image.tag`                         | `v0.5.0`                    | Image tag                         |
| `config.nodeEnv`                    | `production`                | Node environment                  |
| `config.syncFrequency`              | `* * * * *`                 | Email sync cron schedule          |
| `config.ingestionWorkerConcurrency` | `5`                         | Concurrent ingestion workers      |
| `config.bodySizeLimit`              | `100M`                      | Max request body size             |
| `config.storageType`                | `local`                     | Storage backend (`local` or `s3`) |
| `config.storageLocalRootPath`       | `/var/data/open-archiver`   | Local storage mount path          |
| `config.allInclusiveArchive`        | `false`                     | Include Junk/Trash in archive     |
| `config.enableDeletion`             | `false`                     | Allow email deletion              |

### Storage (S3)

| Parameter                        | Default | Description                   |
| -------------------------------- | ------- | ----------------------------- |
| `config.storageS3Endpoint`       | `""`    | S3 endpoint URL               |
| `config.storageS3Bucket`         | `""`    | S3 bucket name                |
| `config.storageS3Region`         | `""`    | S3 region                     |
| `config.storageS3ForcePathStyle` | `false` | Use path-style for non-AWS S3 |

### Secrets

| Parameter                     | Default               | Description                                    |
| ----------------------------- | --------------------- | ---------------------------------------------- |
| `existingSecret`              | `""`                  | Use an existing secret instead of creating one |
| `secret.createKeys`           | `true`                | Auto-generate secret keys on install           |
| `secret.jwtSecret`            | `""` (auto-generated) | JWT signing secret                             |
| `secret.encryptionKey`        | `""` (auto-generated) | Master encryption key (32-byte hex)            |
| `secret.storageEncryptionKey` | `""` (auto-generated) | File encryption key (32-byte hex)              |
| `secret.redisPassword`        | `""` (auto-generated) | Valkey/Redis password                          |
| `secret.meiliMasterKey`       | `""` (auto-generated) | Meilisearch master key                         |

### PostgreSQL (CloudNativePG)

| Parameter                   | Default                   | Description                            |
| --------------------------- | ------------------------- | -------------------------------------- |
| `postgres.create`           | `true`                    | Create a CNPG PostgreSQL cluster       |
| `postgres.name`             | `open-archiver-postgres`  | Name of the CNPG cluster               |
| `postgres.imageCatalogName` | `postgresql`              | ClusterImageCatalog reference name     |
| `postgres.instances`        | `1`                       | Number of PostgreSQL instances         |
| `postgres.major`            | `18`                      | PostgreSQL major version               |
| `postgres.storage.size`     | `10Gi`                    | Database storage size                  |
| `postgres.enablePodMonitor` | `true`                    | Enable Prometheus PodMonitor           |

### Valkey (official valkey-helm subchart)

See [valkey-helm values](https://github.com/valkey-io/valkey-helm/blob/main/valkey/values.yaml) for all options.

| Parameter                                  | Default       | Description                   |
| ------------------------------------------ | ------------- | ----------------------------- |
| `valkey.enabled`                           | `true`        | Deploy Valkey                 |
| `valkey.replica.enabled`                   | `false`       | Enable replicas (standalone)  |
| `valkey.auth.enabled`                      | `true`        | Enable ACL authentication     |
| `valkey.auth.aclUsers.default.password`    | `""`          | Default user password         |
| `valkey.dataStorage.enabled`               | `true`        | Enable persistent storage     |
| `valkey.dataStorage.requestedSize`         | `2Gi`         | Storage size                  |

### Meilisearch (official subchart)

See [meilisearch-kubernetes values](https://github.com/meilisearch/meilisearch-kubernetes/blob/main/charts/meilisearch/values.yaml) for all options.

| Parameter                    | Default      | Description           |
| ---------------------------- | ------------ | --------------------- |
| `meilisearch.enabled`        | `true`       | Deploy Meilisearch    |
| `meilisearch.image.tag`      | `v1.38`      | Meilisearch image tag |
| `meilisearch.persistence.enabled` | `true`  | Enable persistence    |
| `meilisearch.persistence.size`    | `5Gi`   | Storage size          |

### Apache Tika

| Parameter        | Default        | Description        |
| ---------------- | -------------- | ------------------ |
| `tika.enabled`   | `true`         | Deploy Apache Tika |
| `tika.image.tag` | `3.2.2.0-full` | Tika image tag     |

### Ingress

| Parameter             | Default                | Description         |
| --------------------- | ---------------------- | ------------------- |
| `ingress.enabled`     | `true`                 | Enable ingress      |
| `ingress.annotations` | Traefik + cert-manager | Ingress annotations |

### Persistence

| Parameter                       | Default              | Description              |
| ------------------------------- | -------------------- | ------------------------ |
| `persistence.data.name`         | `open-archiver-data` | PVC name for app data    |
| `persistence.data.storageSize`  | `10Gi`               | Storage size             |
| `persistence.data.accessModes`  | `[ReadWriteOnce]`    | PVC access modes         |

## Using External Services

To use external PostgreSQL, Valkey, or Meilisearch instead of the chart-managed ones:

```yaml
# Disable built-in services
postgres:
  create: false
valkey:
  enabled: false
meilisearch:
  enabled: false
tika:
  enabled: false

# Point to external services
config:
  redisHost: "my-redis.example.com"
  meiliHost: "http://my-meilisearch.example.com:7700"
  tikaUrl: "http://my-tika.example.com:9998"
```

For external PostgreSQL, provide the `DATABASE_URL` via an `existingSecret`.

## License

AGPL-3.0
