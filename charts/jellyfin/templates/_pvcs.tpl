{{/*
Renders the Persistent Volume Claim objects required by the chart.
*/}}
{{- define "common.render.pvcs" -}}
  {{- /* Generate pvc as required */ -}}
  {{- range $key, $pvc := .Values.persistence -}}
    {{- if and $pvc.enabled (eq (default "persistentVolumeClaim" $pvc.type) "persistentVolumeClaim") (not $pvc.existingClaim) -}}
      {{- $pvcValues := (mustDeepCopy $pvc) -}}

      {{- /* Determine and inject the PVC name */ -}}
      {{- $objectName := (include "jellyfin.fullname" $) -}}

      {{- if $pvcValues.nameOverride -}}
        {{- if ne $pvcValues.nameOverride "-" -}}
          {{- $objectName = printf "%s-%s" $objectName $pvcValues.nameOverride -}}
        {{- end -}}
      {{- else -}}
        {{- $objectName = printf "%s-%s" $objectName $key -}}
      {{- end -}}
      {{- $_ := set $pvcValues "name" $objectName -}}

      {{- /* Include the PVC class */ -}}
      {{- include "common.class.pvc" (dict "rootContext" $ "object" $pvcValues) | nindent 0 -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
