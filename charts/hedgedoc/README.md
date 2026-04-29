# hedgedoc

[hedgedoc](https://github.com/hackmdio/hedgedoc) is a realtime collaborative markdown notes on all platforms.

Look at [hedgedoc Documentation](https://hackmd.io/c/hedgedoc-documentation) for detail setting.

## Prerequisites

- Kubernetes 1.14+
- Helm 2.16+ or Helm 3.0+
- PV provisioner support in the underlying infrastructure

## How to use?

```bash
$ helm repo add hedgedoc https://helm.hedgedoc.dev/
$ helm install my-release hedgedoc/hedgedoc
```

## Parameters

### Common Helm parameters

If you use AWS EKS, please setup global.storageClass as `gp2`

| Parameter        | Description                                                                                           | Default |
| ---------------- | :---------------------------------------------------------------------------------------------------- | ------- |
| storageClass     | default storageClass for PersistenVolume                                                              | `nil`   |
| nameOverride     | String to partially override hedgedoc.fullname template with a string (will prepend the release name) | `nil`   |
| fullnameOverride | String to fully override hedgedoc.fullname template with a string                                     | `nil`   |

### Docker image parameters

| Parameter         | Description                        | Default             |
| ----------------- | :--------------------------------- | ------------------- |
| image.registry    | hedgedoc docker image registry     | `nabo.hedgedoc.dev` |
| image.repository  | hedgedoc docker image repository   | `hackmdio/hackmd`   |
| image.tag         | hedgedoc docker image version tag  | `2.2.0`             |
| image.pullPolicy  | hedgedoc docker image pull policy  | `IfNotPresent`      |
| image.pullSecrets | hedgedoc docker image pull secrets | `[]`                |

### Deploy an internal database parameters

This Helm chart contains `postgreSQL` and `mariaDB`, you just select one database to deploy. if you want to use external database (maybe cloud provider service or self-hosted database), just set `postgresql.enabled` and `mariadb.enabled` to be `false` and manuall assign database connection parameters in `hedgedoc.database`.

| Parameter                          | Description                            | Default    |
| ---------------------------------- | :------------------------------------- | ---------- |
| postgresql.enabled                 | Deploy a PostgreSQL server as database | `true`     |
| postgresql.volumePermissions       | Enable database persistence using PVC  | `true`     |
| postgresql.postgresqlUsername      | Database user to create                | `hedgedoc` |
| postgresql.postgresqlPassword      | Password for the database              | `changeme` |
| postgresql.postgresqlDatabase      | Database name to create                | `hedgedoc` |
| mariadb.enabled                    | Deploy a MariaDB server as database    | `false`    |
| mariadb.volumePermissions.enabled  | Enable database persistence using PVC  | `true`     |
| mariadb.db.user                    | Database user to create                | `hedgedoc` |
| mariadb.db.password                | Password for the database              | `changeme` |
| mariadb.db.name                    | Database name to create                | `hedgedoc` |
| mariadb.master.persistence.enabled | Enable database persistence using PVC  | `true`     |
| mariadb.replication.enabled        | MariaDB replication enabled            | `false`    |

### Networking conectivity parameters

If you want use ingress, please set `service.type` to be `ClusterIP`

| Parameter                     | Description                       | Default        |
| ----------------------------- | :-------------------------------- | -------------- |
| service.type                  | Kubernetes Service type           | `LoadBalancer` |
| service.port                  | Service HTTP port                 | `80`           |
| service.externalTrafficPolicy | Service externalTrafficPolicy     | `nil`          |
| service.loadBalancerIP        | Service loadBalancerIP            | `nil`          |
| ingress.enabled               | If `true` Ingress will be created | `false`        |
| ingress.annotations           | Ingress annotations               | `nil`          |
| ingress.hosts                 | Ingress hostnames                 | `nil`          |
| ingress.tls                   | Ingress TLS configuration (YAML)  | `nil`          |

### hedgedoc common parameters

| Parameter                                        | Description                                                                                               | Default                      |
| ------------------------------------------------ | :-------------------------------------------------------------------------------------------------------- | ---------------------------- |
| hedgedoc.affinity                                | Affinity for pod assignment                                                                               | `nil`                        |
| hedgedoc.tolerations                             | Tolerations for pod assignment                                                                            | `nil`                        |
| hedgedoc.nodeSelector                            | Node labels for pod assignment                                                                            | `nil`                        |
| hedgedoc.podAnnotations                          | Extra annotation for pod                                                                                  | `nil`                        |
| hedgedoc.securityContext.runAsGroup              | Group ID for the hedgedoc container                                                                       | `1500`                       |
| hedgedoc.securityContext.runAsUser               | User ID for the hedgedoc container                                                                        | `1500`                       |
| hedgedoc.securityContext.fsGroup                 | Group ID for the hedgedoc filesystem                                                                      | `1500`                       |
| hedgedoc.securityContext.runAsNonRoot            | Run non root in hedgedoc container                                                                        | `trrue`                      |
| hedgedoc.connection.domain                       | The domain name your service will be hosted.                                                              | `nil`                        |
| hedgedoc.connection.urlAddPort                   | Set to assign port for URL. (You don’t need this for ports 80 or 443. This only works when domain is set) | `false`                      |
| hedgedoc.connection.protocolUseSSL               | Use SSL protocol for resources path (applied only when domain is set).                                    | `false`                      |
| hedgedoc.database.type                           | The external database type (only accept `postgres`, `mysql`)                                              | `nil`                        |
| hedgedoc.database.host                           | The host of external database                                                                             | `nil`                        |
| hedgedoc.database.port                           | The port of external database                                                                             | `nil`                        |
| hedgedoc.database.username                       | The username that connects to external database                                                           | `nil`                        |
| hedgedoc.database.password                       | The password that connects to external database                                                           | `nil`                        |
| hedgedoc.database.databaseName                   | The external database name we used                                                                        | `nil`                        |
| hedgedoc.imageUpload.storeType                   | The type of image storage                                                                                 | `filesystem`                 |
| hedgedoc.imageUpload.imgur.clientId              | The Imgur OAuth ClientID                                                                                  | `nil`                        |
| hedgedoc.imageUpload.azure.connectionString      | The Azure image store connection string                                                                   | `nil`                        |
| hedgedoc.imageUpload.azure.container             | The Azure image store container name                                                                      | `nil`                        |
| hedgedoc.imageUpload.lutim.url                   | The lutim URL                                                                                             | `nil`                        |
| hedgedoc.imageUpload.minio.endpoint              | The minio endpoint                                                                                        | `nil`                        |
| hedgedoc.imageUpload.minio.secure                | The minio endpoint is secure or not                                                                       | `nil`                        |
| hedgedoc.imageUpload.minio.port                  | The minio port                                                                                            | `nil`                        |
| hedgedoc.imageUpload.minio.accessKey             | The minio access key                                                                                      | `nil`                        |
| hedgedoc.imageUpload.minio.secretKey             | The minio secret key                                                                                      | `nil`                        |
| hedgedoc.imageUpload.s3.endpoint                 | The AWS s3 endpoint                                                                                       | `nil`                        |
| hedgedoc.imageUpload.s3.region                   | The AWS s3 region                                                                                         | `nil`                        |
| hedgedoc.imageUpload.s3.accessKeyId              | The AWS s3 access key                                                                                     | `nil`                        |
| hedgedoc.imageUpload.s3.secretKey                | The AWS s3 secret key                                                                                     | `nil`                        |
| hedgedoc.imageUpload.s3.bucket                   | The AWS s3 bucket name                                                                                    | `nil`                        |
| hedgedoc.imageStorePersistentVolume.enabled      | Enable image persistence using PVC                                                                        | `true`                       |
| hedgedoc.imageStorePersistentVolume.size         | The size of persistence volume                                                                            | `10Gi`                       |
| hedgedoc.imageStorePersistentVolume.storageClass | The storageClass of persistence volume                                                                    | `-`                          |
| hedgedoc.imageStorePersistentVolume.accessModes  | The accessModes of persistence volume                                                                     | [`ReadWriteOnce`]            |
| hedgedoc.imageStorePersistentVolume.volumeMode   | The volumeMode of persistence volume                                                                      | `Filesystem`                 |
| hedgedoc.versionCheck                            | Enable automatically version checker                                                                      | `true`                       |
| hedgedoc.security.useCDN                         | Whether hedgedoc would use static assets served on CDN                                                    | `false`                      |
| hedgedoc.security.sessionSecret                  | The secret string to sign session, please must change this value                                          | `changeit`                   |
| hedgedoc.security.sessionLife                    | The time to expire for session                                                                            | `1209600000`                 |
| hedgedoc.security.hstsEnabled                    | Whether HTST is enabled or not                                                                            | `true`                       |
| hedgedoc.security.hstsMaxAge                     |                                                                                                           | `31536000`                   |
| hedgedoc.security.hstsIncludeSubdomain           |                                                                                                           | `false`                      |
| hedgedoc.security.hstsPreload                    |                                                                                                           | `true`                       |
| hedgedoc.security.cspEnabled                     | Whether CSP is enabled or not                                                                             | `true`                       |
| hedgedoc.security.cspReportUri                   |                                                                                                           | `nil`                        |
| hedgedoc.security.allowOrigin                    |                                                                                                           | `nil`                        |
| hedgedoc.security.allowGravatar                  |                                                                                                           | `true`                       |
| hedgedoc.allowPDFExport                          |                                                                                                           | `false`                      |
| hedgedoc.responseMaxLag                          |                                                                                                           | `70`                         |
| hedgedoc.noteCreation.freeUrlEnabled             | Allow using free url to create note                                                                       | `false`                      |
| hedgedoc.noteCreation.freeUrlForbiddenNoteIds    |                                                                                                           | `robots.txt,favicon.ico,api` |
| hedgedoc.noteCreation.defaultPermission          | The default permission for note created                                                                   | `editable`                   |
| hedgedoc.notePermission.allowAnonymousEdit       | Enable anonymouse edit                                                                                    | `true`                       |
| hedgedoc.notePermission.allowAnonymousView       | Enable anonymouse view                                                                                    | `true`                       |
| hedgedoc.markdown.plantUMLServer                 |                                                                                                           | `nil`                        |
| hedgedoc.markdown.useHardBreak                   |                                                                                                           | `true`                       |
| hedgedoc.markdown.linkifyHeaderStyle             |                                                                                                           | `keep-case`                  |
| hedgedoc.extraEnvironmentVariables               | Extra environment variable for hedgedoc container                                                         | `{}`                         |

### hedgedoc Authentication Method parameters

| Parameter                                                 | Description                                          | Default |
| --------------------------------------------------------- | :--------------------------------------------------- | ------- |
| hedgedoc.authentication.local.enabled                     | Enable to use email for auth                         | `true`  |
| hedgedoc.authentication.local.allowRegister               | Allow register with email                            | `true`  |
| hedgedoc.authentication.bitbucket.enabled                 | Enable to use BitBucket for auth                     | `false` |
| hedgedoc.authentication.bitbucket.key                     | OAuth key for BitBucket auth                         | `nil`   |
| hedgedoc.authentication.bitbucket.secret                  | OAuth secret for BitBucket auth                      | `nil`   |
| hedgedoc.authentication.dropbox.enabled                   | Enable to use Dropbox for auth                       | `false` |
| hedgedoc.authentication.dropbox.appKey                    | OAuth app key for Dropbox auth                       | `nil`   |
| hedgedoc.authentication.dropbox.appSecret                 | OAuth app secret for Dropbox auth                    | `nil`   |
| hedgedoc.authentication.facebook.enabled                  | Enable to use Facebook for auth                      | `false` |
| hedgedoc.authentication.facebook.clientId                 | OAuth client id for Facebook auth                    | `nil`   |
| hedgedoc.authentication.facebook.secret                   | OAuth secret for Facebook auth                       | `nil`   |
| hedgedoc.authentication.github.enabled                    | Enable to use GitHub for auth                        | `false` |
| hedgedoc.authentication.github.clientId                   | OAuth client id for GitHub auth                      | `nil`   |
| hedgedoc.authentication.github.secret                     | OAuth secret for GitHub auth                         | `nil`   |
| hedgedoc.authentication.github.enterpriseUrl              | GitHub Enterprise OAuth endpoint url for GitHub auth | `nil`   |
| hedgedoc.authentication.gitlab.enabled                    | Enable to use GitLab for auth                        | `false` |
| hedgedoc.authentication.gitlab.domain                     | GitLab instance domain for GitLab auth               | `nil`   |
| hedgedoc.authentication.gitlab.scope                      | OAuth scope for GitLab auth                          | `nil`   |
| hedgedoc.authentication.gitlab.applicationId              | OAuth application id for GitLab auth                 | `nil`   |
| hedgedoc.authentication.gitlab.secret                     | OAuth secret for GitLab auth                         | `nil`   |
| hedgedoc.authentication.google.enabled                    | Enable to use Google for auth                        | `false` |
| hedgedoc.authentication.google.clientId                   | OAuth client id for Google auth                      | `nil`   |
| hedgedoc.authentication.google.secret                     | OAuth secret for Google auth                         | `nil`   |
| hedgedoc.authentication.google.hostedDomain               | Google hosted OAuth domain for Google auth           | `nil`   |
| hedgedoc.authentication.ldap.enabled                      | Enable to use LDAP for auth                          | `false` |
| hedgedoc.authentication.ldap.providerName                 | See the LDAP doc                                     | `nil`   |
| hedgedoc.authentication.ldap.url                          |                                                      | `nil`   |
| hedgedoc.authentication.ldap.tlsCA                        |                                                      | `nil`   |
| hedgedoc.authentication.ldap.bindDN                       |                                                      | `nil`   |
| hedgedoc.authentication.ldap.bindCredentials              |                                                      | `nil`   |
| hedgedoc.authentication.ldap.searchBase                   |                                                      | `nil`   |
| hedgedoc.authentication.ldap.searchFilter                 |                                                      | `nil`   |
| hedgedoc.authentication.ldap.searchAttributes             |                                                      | `nil`   |
| hedgedoc.authentication.ldap.attributes.id                |                                                      | `nil`   |
| hedgedoc.authentication.ldap.attributes.username          |                                                      | `nil`   |
| hedgedoc.authentication.mattermost.enabled                | Enable to use Mattermost for auth                    | `false` |
| hedgedoc.authentication.mattermost.domain                 | OAuth doamin for Mattermost auth                     | `nil`   |
| hedgedoc.authentication.mattermost.clientId               | OAuth client id for Mattermost auth                  | `nil`   |
| hedgedoc.authentication.mattermost.secret                 | OAuth secret for Mattermost auth                     | `nil`   |
| hedgedoc.authentication.oauth2.enabled                    | See the OAuth2 doc                                   | `false` |
| hedgedoc.authentication.oauth2.providerName               |                                                      | `nil`   |
| hedgedoc.authentication.oauth2.domain                     |                                                      | `nil`   |
| hedgedoc.authentication.oauth2.clientId                   |                                                      | `nil`   |
| hedgedoc.authentication.oauth2.secret                     |                                                      | `nil`   |
| hedgedoc.authentication.oauth2.authorizationUrl           |                                                      | `nil`   |
| hedgedoc.authentication.oauth2.tokenUrl                   |                                                      | `nil`   |
| hedgedoc.authentication.oauth2.userProfileUrl             |                                                      | `nil`   |
| hedgedoc.authentication.oauth2.scope                      |                                                      | `nil`   |
| hedgedoc.authentication.oauth2.attributes.username        |                                                      | `nil`   |
| hedgedoc.authentication.oauth2.attributes.displayName     |                                                      | `nil`   |
| hedgedoc.authentication.oauth2.attributes.email           |                                                      | `nil`   |
| hedgedoc.authentication.openID.enabled                    | See the OpenID doc                                   | `false` |
| hedgedoc.authentication.saml.enabled                      | See the SAML doc                                     | `false` |
| hedgedoc.authentication.saml.idpSSOUrl                    |                                                      | `nil`   |
| hedgedoc.authentication.saml.idpCert                      |                                                      | `nil`   |
| hedgedoc.authentication.saml.issuer                       |                                                      | `nil`   |
| hedgedoc.authentication.saml.identifierFormat             |                                                      | `nil`   |
| hedgedoc.authentication.saml.disableRequestedAuthnContext |                                                      | `nil`   |
| hedgedoc.authentication.saml.groupAttribute               |                                                      | `nil`   |
| hedgedoc.authentication.saml.externalGroups               |                                                      | `nil`   |
| hedgedoc.authentication.saml.requiredGroups               |                                                      | `nil`   |
| hedgedoc.authentication.saml.attributes.id                |                                                      | `nil`   |
| hedgedoc.authentication.saml.attributes.username          |                                                      | `nil`   |
| hedgedoc.authentication.saml.attributes.email             |                                                      | `nil`   |
| hedgedoc.authentication.twitter.enabled                   | Enable to use Twitter for auth                       | `false` |
| hedgedoc.authentication.twitter.consumerKey               | OAuth consumer key for Twitter auth                  | `nil`   |
| hedgedoc.authentication.twitter.comsumerSecret            | OAuth consumer secret for Twitter auth               | `nil`   |
