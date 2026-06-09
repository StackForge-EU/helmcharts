{{/*
Expand the name of the chart.
*/}}
{{- define "open-archiver.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "open-archiver.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "open-archiver.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "open-archiver.labels" -}}
helm.sh/chart: {{ include "open-archiver.chart" . }}
{{ include "open-archiver.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "open-archiver.selectorLabels" -}}
app.kubernetes.io/name: {{ include "open-archiver.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Valkey selector labels
*/}}
{{- define "open-archiver.selectorLabelsValkey" -}}
app.kubernetes.io/name: {{ include "open-archiver.name" . }}-valkey
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Tika selector labels
*/}}
{{- define "open-archiver.selectorLabelsTika" -}}
app.kubernetes.io/name: {{ include "open-archiver.name" . }}-tika
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Data storage class
*/}}
{{- define "open-archiver.data.storageClass" -}}
{{- .Values.persistence.data.storageClassName | default .Values.global.storageClass | default "" -}}
{{- end }}

{{/*
Resolve Valkey host - official valkey-helm subchart creates service as <release>-valkey
*/}}
{{- define "open-archiver.valkeyHost" -}}
{{- if .Values.config.redisHost -}}
{{- .Values.config.redisHost -}}
{{- else -}}
{{- printf "%s-valkey" .Release.Name -}}
{{- end -}}
{{- end }}

{{/*
Resolve Meilisearch host - official subchart creates service as <release>-meilisearch
*/}}
{{- define "open-archiver.meiliHost" -}}
{{- if .Values.config.meiliHost -}}
{{- .Values.config.meiliHost -}}
{{- else -}}
http://{{ printf "%s-meilisearch" .Release.Name }}:7700
{{- end -}}
{{- end }}

{{/*
Resolve Tika URL
*/}}
{{- define "open-archiver.tikaUrl" -}}
{{- if .Values.config.tikaUrl -}}
{{- .Values.config.tikaUrl -}}
{{- else -}}
http://{{ include "open-archiver.fullname" . }}-tika:9998
{{- end -}}
{{- end }}

{{/*
Resolve Valkey password secret name - official valkey-helm stores ACL secret in <release>-valkey-acl
We use our own secret-keys secret since the official chart uses ACL config
*/}}
{{- define "open-archiver.valkeySecretName" -}}
{{- include "open-archiver.fullname" . }}-secret-keys
{{- end }}

{{/*
Resolve Meilisearch master key secret name
*/}}
{{- define "open-archiver.meiliSecretName" -}}
{{- if (index .Values "meilisearch" "auth" "existingMasterKeySecret") -}}
{{- index .Values "meilisearch" "auth" "existingMasterKeySecret" -}}
{{- else -}}
{{- include "open-archiver.fullname" . }}-secret-keys
{{- end -}}
{{- end }}
