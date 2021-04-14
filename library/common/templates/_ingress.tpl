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
Renders the Ingress objects required by the chart by returning a concatinated list
of the main Ingress and any additionalIngresses.
*/}}
{{- define "common.ingress" -}}
  {{- if .Values.ingress.enabled -}}
    {{- $svcPort := .Values.service.port.port -}}

    {{- /* Generate primary ingress */ -}}
    {{- $ingressValues := .Values.ingress -}}
    {{- $_ := set . "ObjectValues" (dict "ingress" $ingressValues) -}}
    {{- include "common.classes.ingress" . }}

    {{- /* Generate additional ingresses as required */ -}}
    {{- range $index, $extraIngress := .Values.ingress.additionalIngresses }}
      {{- if $extraIngress.enabled -}}
        {{- print ("---") | nindent 0 -}}
        {{- $ingressValues := $extraIngress -}}
        {{- if not $ingressValues.nameSuffix -}}
          {{- $_ := set $ingressValues "nameSuffix" $index -}}
        {{ end -}}
        {{- $_ := set $ "ObjectValues" (dict "ingress" $ingressValues) -}}
        {{- include "common.classes.ingress" $ -}}
      {{- end }}
    {{- end }}
  {{- end }}
=======
Renders the Ingress objects required by the chart by returning a concatinated list
of the main Ingress and any additionalIngresses.
*/}}
{{- define "common.ingress" -}}
    {{- /* Generate named ingresses as required */ -}}
    {{- range $name, $ingress := .Values.ingress }}
      {{- if $ingress.enabled -}}
        {{- print ("---") | nindent 0 -}}
        {{- $ingressValues := $ingress -}}

        {{/* set defaults */}}
        {{- if and (not $ingressValues.nameSuffix) ( ne $name "main" ) -}}
          {{- $_ := set $ingressValues "nameSuffix" $name -}}
        {{ end -}}

        {{- $_ := set $ "ObjectValues" (dict "ingress" $ingressValues) -}}
        {{- if not $ingressValues.type -}}
          {{- $_ := set $ingressValues "type" "HTTP" -}}
        {{ end -}}
        {{- if not $ingressValues.certType -}}
          {{- $_ := set $ingressValues "certType" "" -}}
        {{ end -}}

        {{- if or ( eq $ingressValues.type "TCP" ) ( eq $ingressValues.type "UDP" )  ( eq $ingressValues.type "HTTP-IR" ) -}}
        {{- include "common.classes.ingressRoute" $ -}}
        {{- else -}}
        {{- include "common.classes.ingress" $ -}}
        {{ end -}}

        {{- if $ingressValues.authForwardURL -}}
        {{- print ("---") | nindent 0 -}}
        {{- include "common.classes.ingress.authForward" $ }}
        {{ end -}}

        {{- if eq $ingressValues.certType "ixcert" -}}
        {{- $_ := set $ "ObjectValues" (dict "certHolder" $ingressValues) -}}
        {{- print ("---") | nindent 0 -}}
        {{- include "common.resources.cert.secret" $ }}
        {{ end -}}
      {{- end }}
    {{- end }}


    {{- /* Generate additional ingresses as required */ -}}
    {{- range $index, $additionalIngress := .Values.additionalIngress }}
      {{- if $additionalIngress.enabled -}}
        {{- print ("---") | nindent 0 -}}
        {{- $ingressValues := $additionalIngress -}}

        {{/* set defaults */}}
        {{- $name := $index -}}
        {{- if  $ingressValues.name -}}
          {{- $name := $ingressValues.name -}}
        {{- end }}

        {{- if or (not $ingressValues.nameSuffix) ( ne ( $name | quote ) "main" ) -}}
          {{- $_ := set $ingressValues "nameSuffix" $name -}}
        {{ end -}}
        {{- $_ := set $ "ObjectValues" (dict "ingress" $ingressValues) -}}
        {{- if not $ingressValues.type -}}
          {{- $_ := set $ingressValues "type" "HTTP" -}}
        {{ end -}}
        {{- if not $ingressValues.certType -}}
          {{- $_ := set $ingressValues "certType" "" -}}
        {{ end -}}

        {{- if or ( eq $ingressValues.type "TCP" ) ( eq $ingressValues.type "UDP" ) ( eq $ingressValues.type "HTTP-IR" ) -}}
        {{- include "common.classes.ingressRoute" $ -}}
        {{- else -}}
        {{- include "common.classes.ingress" $ -}}
        {{ end -}}

        {{- if $ingressValues.authForwardURL -}}
        {{- print ("---") | nindent 0 -}}
        {{- include "common.classes.ingress.authForward" $ }}
        {{ end -}}

        {{- if eq $ingressValues.certType "ixcert" -}}
        {{- $_ := set $ "ObjectValues" (dict "certHolder" $ingressValues) -}}
        {{- print ("---") | nindent 0 -}}
        {{- include "common.resources.cert.secret" $ }}
        {{ end -}}
      {{- end }}
    {{- end }}

    {{- /* Generate externalService ingresses as required */ -}}
    {{- range $index, $externalService := .Values.externalServices }}
      {{- if $externalService.enabled -}}
        {{- print ("---") | nindent 0 -}}
        {{- $ingressValues := $externalService -}}

        {{/* set defaults */}}
        {{- $name := $index -}}
        {{- if  $ingressValues.name -}}
          {{- $name := $ingressValues.name -}}
        {{- end }}
        {{- $name = printf "%v-%v" "external" $name -}}

        {{- if or (not $ingressValues.nameSuffix) -}}
          {{- $_ := set $ingressValues "nameSuffix" $name -}}
        {{ end -}}
        {{- $_ := set $ "ObjectValues" (dict "ingress" $ingressValues) -}}
        {{- if not $ingressValues.type -}}
          {{- $_ := set $ingressValues "type" "HTTP" -}}
        {{ end -}}
        {{- if not $ingressValues.certType -}}
          {{- $_ := set $ingressValues "certType" "" -}}
        {{ end -}}

        {{- if or ( eq $ingressValues.type "TCP" ) ( eq $ingressValues.type "UDP" ) ( eq $ingressValues.type "HTTP-IR" ) -}}
        {{- include "common.classes.ingressRoute" $ -}}
        {{- else -}}
        {{- include "common.classes.ingress" $ -}}
        {{ end -}}

        {{- print ("---") | nindent 0 -}}
        {{- include "common.classes.externalService" $ }}

        {{- if $ingressValues.authForwardURL -}}
        {{- print ("---") | nindent 0 -}}
        {{- include "common.classes.ingress.authForward" $ }}
        {{ end -}}

        {{- if eq $ingressValues.certType "ixcert" -}}
        {{- $_ := set $ "ObjectValues" (dict "certHolder" $ingressValues) -}}
        {{- print ("---") | nindent 0 -}}
        {{- include "common.resources.cert.secret" $ }}
        {{ end -}}
      {{- end }}
    {{- end }}

>>>>>>> df05cf8ce687f8235ce0cb1d2ea042a31047123a
{{- end }}
