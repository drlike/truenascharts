{{/*
<<<<<<< HEAD
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

`SPDX-License-Identifier: Apache-2.0`

This file is considered to be modified by the TrueCharts Project.
*/}}

{{/*
=======
>>>>>>> df05cf8ce687f8235ce0cb1d2ea042a31047123a
This template serves as a blueprint for all Ingress objects that are created
within the common library.
*/}}
{{- define "common.classes.ingress" -}}
{{- $ingressName := include "common.names.fullname" . -}}
<<<<<<< HEAD
{{- $values := .Values.ingress -}}
=======
{{- $values := .Values -}}
{{- $svcPort := 80 -}}
{{- $portProtocol := "" -}}
{{- $ingressService := $.Values -}}
>>>>>>> df05cf8ce687f8235ce0cb1d2ea042a31047123a
{{- if hasKey . "ObjectValues" -}}
  {{- with .ObjectValues.ingress -}}
    {{- $values = . -}}
  {{- end -}}
{{ end -}}
<<<<<<< HEAD
{{- if hasKey $values "nameSuffix" -}}
  {{- $ingressName = printf "%v-%v" $ingressName $values.nameSuffix -}}
{{ end -}}
{{- $svcName := $values.serviceName | default (include "common.names.fullname" .) -}}
{{- $svcPort := $values.servicePort | default $.Values.service.port.port -}}
=======

{{- if hasKey $values "nameSuffix" -}}
  {{- $ingressName = printf "%v-%v" $ingressName $values.nameSuffix -}}
  {{- if and ( $.Values.services ) ( not $values.servicePort ) }}
    {{- $ingressService := index  $.Values.services ( $values.nameSuffix | quote ) }}
    {{- $svcPort = $ingressService.port.port -}}
    {{- $portProtocol = $ingressService.port.protocol | default "" }}
  {{ end -}}
{{- else if and ( $.Values.services ) ( not $values.servicePort ) }}
  {{- $svcPort = $.Values.services.main.port.port -}}
  {{- $portProtocol = $.Values.services.main.port.protocol | default "" -}}
{{ end -}}

{{- $svcName := $values.serviceName | default $ingressName -}}

{{- if $values.dynamicServiceName }}
  {{- $dynamicServiceName := printf "%v-%v" .Release.Name $values.dynamicServiceName -}}
  {{- $svcName = $dynamicServiceName -}}
{{- end }}

{{- if $values.servicePort }}
  {{- $svcPort = $values.servicePort -}}
{{- end }}

{{- if $values.serviceType }}
  {{- $portProtocol = $values.serviceType -}}
{{- end }}

>>>>>>> df05cf8ce687f8235ce0cb1d2ea042a31047123a
apiVersion: {{ include "common.capabilities.ingress.apiVersion" . }}
kind: Ingress
metadata:
  name: {{ $ingressName }}
  labels:
    {{- include "common.labels" . | nindent 4 }}
<<<<<<< HEAD
  {{- with $values.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
=======
  annotations:
    {{- if eq $portProtocol "HTTPS" }}
    traefik.ingress.kubernetes.io/service.serversscheme: https
    {{- end }}
    traefik.ingress.kubernetes.io/router.entrypoints: {{ $values.entrypoint | default "websecure" }}
    traefik.ingress.kubernetes.io/router.middlewares: traefik-middlewares-chain-public@kubernetescrd{{ if $values.authForwardURL }},{{ $ingressName }}-auth-forward{{ end }}
    {{- with $values.annotations }}
      {{- toYaml . | nindent 4 }}
    {{- end }}
>>>>>>> df05cf8ce687f8235ce0cb1d2ea042a31047123a
spec:
  {{- if eq (include "common.capabilities.ingress.apiVersion" $) "networking.k8s.io/v1" }}
  {{- if $values.ingressClassName }}
  ingressClassName: {{ $values.ingressClassName }}
  {{- end }}
  {{- end }}
<<<<<<< HEAD
  {{- if $values.tls }}
  tls:
    {{- range $values.tls }}
    - hosts:
        {{- range .hosts }}
        - {{ . | quote }}
        {{- end }}
        {{- range .hostsTpl }}
        - {{ tpl . $ | quote }}
        {{- end }}
      {{- if .secretNameTpl }}
      secretName: {{ tpl .secretNameTpl $ | quote}}
      {{- else }}
      secretName: {{ .secretName }}
      {{- end }}
    {{- end }}
  {{- end }}
  rules:
  {{- range $values.hosts }}
  {{- if .hostTpl }}
    - host: {{ tpl .hostTpl $ | quote }}
  {{- else }}
    - host: {{ .host | quote }}
  {{- end }}
      http:
        paths:
          {{- range .paths }}
          - path: {{ .path }}
=======
  {{- if or ( eq $values.certType "selfsigned") (eq $values.certType "ixcert") }}
  tls:
    - hosts:
        {{- if $values.host}}
        - {{ $values.host | quote }}
        {{- else }}
        {{- range $values.hosts }}
        - {{ .host | quote }}
        {{- end }}
        {{- end }}
      {{- if eq $values.certType "ixcert" }}
      secretName: {{ $ingressName }}
      {{- end }}
  {{- end }}
  rules:
  {{- if $values.host }}
    - host: {{ $values.host | quote }}
      http:
        paths:
          - path: {{ $values.path | default "/" }}
            {{- if eq (include "common.capabilities.ingress.apiVersion" $) "networking.k8s.io/v1" }}
            pathType: Prefix
            {{- end }}
            backend:
            {{- if eq (include "common.capabilities.ingress.apiVersion" $) "networking.k8s.io/v1" }}
              service:
                name: {{ $svcName }}
                port:
                  number: {{ $svcPort }}
            {{- else }}
              serviceName: {{ $svcName }}
              servicePort: {{ $svcPort }}
            {{- end }}
  {{- end }}
  {{- range $values.hosts }}
    - host: {{ .host | quote }}
      http:
        paths:
          - path: {{ .path | default "/" }}
>>>>>>> df05cf8ce687f8235ce0cb1d2ea042a31047123a
            {{- if eq (include "common.capabilities.ingress.apiVersion" $) "networking.k8s.io/v1" }}
            pathType: Prefix
            {{- end }}
            backend:
            {{- if eq (include "common.capabilities.ingress.apiVersion" $) "networking.k8s.io/v1" }}
              service:
                name: {{ $svcName }}
                port:
                  number: {{ $svcPort }}
            {{- else }}
              serviceName: {{ $svcName }}
              servicePort: {{ $svcPort }}
            {{- end }}
<<<<<<< HEAD
          {{- end }}
=======
>>>>>>> df05cf8ce687f8235ce0cb1d2ea042a31047123a
  {{- end }}
{{- end }}
