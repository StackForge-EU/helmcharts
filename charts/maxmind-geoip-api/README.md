# MaxMind GeoIP API Helm Chart

A Helm chart for deploying the [MaxMind GeoIP API](https://github.com/stefansundin/maxmind-geoip-api) on Kubernetes.

## Description

This chart deploys a lightweight MaxMind GeoIP lookup API service. The API accepts IP addresses and returns GeoIP data from MaxMind databases.

Set `maxmind.dbUrl` and the API container downloads and auto-updates the database every 24 hours.

## Installation

```bash
helm install my-geoip ./charts/maxmind-geoip-api \
  --set maxmind.dbUrl="https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-City&license_key=YOUR_KEY&suffix=tar.gz"
```

## Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `image.repository` | API container image | `stefansundin/maxmind-geoip-api` |
| `image.tag` | Image tag | `v1.1.0` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `replicaCount` | Number of replicas | `1` |
| `maxmind.dbUrl` | URL to download the MaxMind database | `""` |
| `maxmind.existingSecret` | Name of an existing Secret containing `MAXMIND_DB_URL` | `""` |
| `maxmind.existingSecretKey` | Key in the existing Secret to read from | `MAXMIND_DB_URL` |
| `service.create` | Create a Service | `true` |
| `service.type` | Service type | `ClusterIP` |
| `service.port` | Service port | `80` |
| `service.containerPort` | Container port | `80` |
| `networkPolicy.create` | Create a NetworkPolicy | `false` |
| `networkPolicy.ingress.limit` | Restrict ingress traffic | `false` |
| `networkPolicy.ingress.from` | Allowed ingress sources | `[{podSelector: {}}]` |
| `networkPolicy.egress.limit` | Restrict egress traffic | `false` |
| `networkPolicy.egress.to` | Allowed egress destinations | `[{podSelector: {}}]` |
| `resources.limits.cpu` | CPU limit | `100m` |
| `resources.limits.memory` | Memory limit | `128Mi` |
| `resources.requests.cpu` | CPU request | `50m` |
| `resources.requests.memory` | Memory request | `64Mi` |

## Using an Existing Secret

Instead of providing credentials directly in values, you can reference a pre-existing Kubernetes Secret.

Create a Secret with the `MAXMIND_DB_URL` key:

```bash
kubectl create secret generic my-maxmind-secret \
  --from-literal=MAXMIND_DB_URL="https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-City&license_key=YOUR_KEY&suffix=tar.gz"
```

Then reference it:

```bash
helm install my-geoip ./charts/maxmind-geoip-api \
  --set maxmind.existingSecret=my-maxmind-secret
```

## Usage

Query an IP address:

```
GET http://<service>:3000/1.2.3.4
```

Get database metadata:

```
GET http://<service>:3000/metadata
```

## Disclaimer

This Helm chart is provided as a convenience for deploying the [MaxMind GeoIP API](https://github.com/stefansundin/maxmind-geoip-api). We are not responsible for the application itself. For any issues related to the application, please refer to the upstream repository.

## Maintainers

| Name | Email | URL |
|------|-------|-----|
| StackForge UG (haftungsbeschränkt) | support@stack-forge.cloud | https://stack-forge.eu |
