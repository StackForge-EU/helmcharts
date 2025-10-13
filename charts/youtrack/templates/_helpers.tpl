{{/*
Expand the name of the chart.
*/}}
{{- define "youtrack.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "youtrack.fullname" -}}
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
{{- define "youtrack.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "youtrack.labels" -}}
helm.sh/chart: {{ include "youtrack.chart" . }}
{{ include "youtrack.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "youtrack.selectorLabels" -}}
app.kubernetes.io/name: {{ include "youtrack.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Data storage class
*/}}
{{- define "youtrack.data.storageClass" -}}
{{- .Values.persistence.data.storageClassName | default .Values.global.storageClass | default "" -}}
{{- end }}

{{/*
Logs storage class
*/}}
{{- define "youtrack.logs.storageClass" -}}
{{- .Values.persistence.logs.storageClassName | default .Values.global.storageClass | default "" -}}
{{- end }}

{{/*
Conf storage class
*/}}
{{- define "youtrack.conf.storageClass" -}}
{{- .Values.persistence.conf.storageClassName | default .Values.global.storageClass | default "" -}}
{{- end }}

{{/*
Backups storage class
*/}}
{{- define "youtrack.backups.storageClass" -}}
{{- if .Values.persistence.backups.storageClassName -}}
{{- .Values.persistence.backups.storageClassName -}}
{{- else if eq .Values.persistence.backups.backupType "volumeStorage" -}}
{{- .Values.persistence.backups.volumeStorage.storageClassName | default .Values.global.storageClass | default "" -}}
{{- else if eq .Values.persistence.backups.backupType "objectStorage" -}}
{{- .Values.persistence.backups.objectStorage.storageClassName | default .Values.global.storageClass | default "" -}}
{{- else -}}
{{- .Values.global.storageClass | default "" -}}
{{- end -}}
{{- end }}

{{/*
Data access modes
*/}}
{{- define "youtrack.data.accessModes" -}}
{{- if gt (len .Values.persistence.data.accessModes) 0 -}}
{{- .Values.persistence.data.accessModes -}}
{{- else -}}
{{- .Values.global.accessModes | default (list "ReadWriteOnce") -}}
{{- end -}}
{{- end }}

{{/*
Logs access modes
*/}}
{{- define "youtrack.logs.accessModes" -}}
{{- if gt (len .Values.persistence.logs.accessModes) 0 -}}
{{- .Values.persistence.logs.accessModes -}}
{{- else -}}
{{- .Values.global.accessModes | default (list "ReadWriteOnce") -}}
{{- end -}}
{{- end }}

{{/*
Conf access modes
*/}}
{{- define "youtrack.conf.accessModes" -}}
{{- if gt (len .Values.persistence.conf.accessModes) 0 -}}
{{- .Values.persistence.conf.accessModes -}}
{{- else -}}
{{- .Values.global.accessModes | default (list "ReadWriteOnce") -}}
{{- end -}}
{{- end }}

{{/*
Backups access modes
*/}}
{{- define "youtrack.backups.accessModes" -}}
{{- if gt (len .Values.persistence.backups.accessModes) 0 -}}
{{- .Values.persistence.backups.accessModes -}}
{{- else -}}
{{- $backupType := .Values.persistence.backups.backupType -}}
{{- if eq $backupType "objectStorage" -}}
{{- .Values.persistence.backups.objectStorage.accessModes | default (list "ReadWriteMany") -}}
{{- else if eq $backupType "volumeStorage" -}}
{{- .Values.persistence.backups.volumeStorage.accessModes | default (list "ReadWriteOnce") -}}
{{- else -}}
{{- .Values.global.accessModes | default (list "ReadWriteOnce") -}}
{{- end -}}
{{- end -}}
{{- end }}



