# GhostCMS Helm Chart

This Helm chart deploys GhostCMS with MariaDB using mariadb-operator.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.0+
- mariadb-operator installed in the cluster

## Installing the Chart

To install the chart with the release name `my-ghost`:

```bash
helm install my-ghost ./charts/ghostcms
```

## Uninstalling the Chart

To uninstall the chart:

```bash
helm uninstall my-ghost
```

## Configuration

The following table lists the configurable parameters of the GhostCMS chart and their default values.

| Parameter                             | Description                                           | Default                 |
| ------------------------------------- | ----------------------------------------------------- | ----------------------- |
| `replicaCount`                        | Number of replicas                                    | `1`                     |
| `image.repository`                    | Ghost image repository                                | `ghost`                 |
| `image.tag`                           | Ghost image tag                                       | `alpine`                |
| `ghost.url`                           | Ghost URL                                             | `http://ghostcms.local` |
| `mariadb.enabled`                     | Enable managed MariaDB                                | `true`                  |
| `mariadb.existingSecret`              | Name of existing secret for passwords                 | `""`                    |
| `mariadb.rootPassword`                | MariaDB root password (leave empty for auto-generate) | `""`                    |
| `mariadb.database`                    | MariaDB database name                                 | `ghost`                 |
| `mariadb.username`                    | MariaDB username                                      | `ghost`                 |
| `mariadb.password`                    | MariaDB user password (leave empty for auto-generate) | `""`                    |
| `mariadb.storage.size`                | MariaDB storage size                                  | `1Gi`                   |
| `mariadb.storage.storageClass`        | MariaDB storage class                                 | `""`                    |
| `mariadb.replicas`                    | MariaDB replicas                                      | `1`                     |
| `mariadb.galera.enabled`              | Enable Galera                                         | `false`                 |
| `externalDatabase.enabled`            | Use external database                                 | `false`                 |
| `externalDatabase.host`               | External database host                                | `""`                    |
| `externalDatabase.database`           | External database name                                | `""`                    |
| `externalDatabase.username`           | External database username                            | `""`                    |
| `externalDatabase.passwordSecretName` | Secret name for external DB password                  | `""`                    |
| `externalDatabase.passwordSecretKey`  | Key in secret for password                            | `password`              |
| `persistence.size`                    | PVC size for Ghost content                            | `1Gi`                   |
| `persistence.storageClass`            | Storage class for Ghost content PVC                   | `""`                    |
| `service.type`                        | Service type                                          | `ClusterIP`             |
| `service.port`                        | Service port                                          | `2368`                  |
| `ingress.enabled`                     | Enable ingress                                        | `false`                 |
| `ingress.hosts[0].host`               | Ingress host                                          | `ghostcms.local`        |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

## Using External Database

To use an existing MariaDB instance instead of the managed one, set `mariadb.enabled=false` and `externalDatabase.enabled=true`, then provide the connection details:

```yaml
mariadb:
  enabled: false

externalDatabase:
  enabled: true
  host: "my-external-db.example.com"
  database: "ghost"
  username: "ghostuser"
  passwordSecretName: "my-db-secret"
  passwordSecretKey: "password"
```

Ensure the secret exists in the same namespace with the password.

## Using Existing Secrets

To use an existing secret for the managed MariaDB passwords, set `mariadb.existingSecret` to the name of your secret. The secret must contain `rootPassword` and `password` keys.

```yaml
mariadb:
  existingSecret: "my-mariadb-secret"
```

## Password Generation

If `mariadb.rootPassword` or `mariadb.password` are left empty, random 16-character passwords will be generated automatically at install time for the respective fields.