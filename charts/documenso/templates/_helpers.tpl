{{/*
Expand the name of the chart.
*/}}
{{- define "documenso.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "documenso.fullname" -}}
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
{{- define "documenso.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "documenso.labels" -}}
helm.sh/chart: {{ include "documenso.chart" . }}
{{ include "documenso.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "documenso.selectorLabels" -}}
app.kubernetes.io/name: {{ include "documenso.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Data storage class
*/}}
{{- define "documenso.data.storageClass" -}}
{{- .Values.persistence.data.storageClassName | default .Values.global.storageClass | default "" -}}
{{- end }}

{{/*
Logs storage class
*/}}
{{- define "documenso.logs.storageClass" -}}
{{- .Values.persistence.logs.storageClassName | default .Values.global.storageClass | default "" -}}
{{- end }}

{{/*
Conf storage class
*/}}
{{- define "documenso.conf.storageClass" -}}
{{- .Values.persistence.conf.storageClassName | default .Values.global.storageClass | default "" -}}
{{- end }}

{{/*
Backups storage class
*/}}
{{- define "documenso.backups.storageClass" -}}
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
{{- define "documenso.data.accessModes" -}}
{{- if gt (len .Values.persistence.data.accessModes) 0 -}}
{{- .Values.persistence.data.accessModes -}}
{{- else -}}
{{- .Values.global.accessModes | default (list "ReadWriteOnce") -}}
{{- end -}}
{{- end }}

{{/*
Logs access modes
*/}}
{{- define "documenso.logs.accessModes" -}}
{{- if gt (len .Values.persistence.logs.accessModes) 0 -}}
{{- .Values.persistence.logs.accessModes -}}
{{- else -}}
{{- .Values.global.accessModes | default (list "ReadWriteOnce") -}}
{{- end -}}
{{- end }}

{{/*
Conf access modes
*/}}
{{- define "documenso.conf.accessModes" -}}
{{- if gt (len .Values.persistence.conf.accessModes) 0 -}}
{{- .Values.persistence.conf.accessModes -}}
{{- else -}}
{{- .Values.global.accessModes | default (list "ReadWriteOnce") -}}
{{- end -}}
{{- end }}

{{/*
Backups access modes
*/}}
{{- define "documenso.backups.accessModes" -}}
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



