{{/*
This template serves as the blueprint for the mountPermissions job that is run
before chart installation.
*/}}
{{- define "common.storage.permissions" -}}
<<<<<<< HEAD
{{- if and .Values.appVolumeMounts .Values.fixMountPermissions }}
{{- range $name, $avm := .Values.appVolumeMounts -}}
{{- if and $avm.enabled $avm.setPermissions}}
{{- print "---" | nindent 0 -}}

{{- $VMValues := $avm -}}
=======
{{- if .Values.fixMountPermissions }}

{{- if .Values.appVolumeMounts }}
{{- range $name, $vm := .Values.appVolumeMounts -}}
{{- if and $vm.enabled $vm.setPermissions}}
{{- print "---" | nindent 0 -}}

{{- $VMValues := $vm -}}
>>>>>>> df05cf8ce687f8235ce0cb1d2ea042a31047123a
{{- if not $VMValues.nameSuffix -}}
  {{- $_ := set $VMValues "nameSuffix" $name -}}
{{ end -}}
{{- $_ := set $ "ObjectValues" (dict "appVolumeMounts" $VMValues) -}}

{{ include "common.storage.permissions.job" $  | nindent 0 }}
{{- end }}
{{- end }}
{{- end }}
<<<<<<< HEAD
=======


{{- if .Values.additionalAppVolumeMounts }}
{{- range $index, $avm := .Values.additionalAppVolumeMounts -}}
{{- if and $avm.enabled $avm.setPermissions}}
{{- print "---" | nindent 0 -}}

{{- $AVMValues := $avm -}}
{{- if not $AVMValues.nameSuffix -}}
  {{- $_ := set $AVMValues "nameSuffix" $index -}}
{{ end -}}
{{- $_ := set $ "ObjectValues" (dict "appVolumeMounts" $AVMValues) -}}

{{ include "common.storage.permissions.job" $  | nindent 0 }}
{{- end }}
{{- end }}
{{- end }}

{{- end }}
>>>>>>> df05cf8ce687f8235ce0cb1d2ea042a31047123a
{{- end }}
