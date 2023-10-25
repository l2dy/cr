{{/*
volumeMounts used by the container.
*/}}
{{- define "container.field.volumeMounts" -}}
  {{- /* Default to empty dict */ -}}
  {{- $persistenceItemsToProcess := dict -}}
  {{- $enabledVolumeMounts := list -}}

  {{- /* Collect regular persistence items */ -}}
  {{- range $identifier, $persistenceValues := .persistence -}}
    {{- /* Enable persistence item by default, but allow override */ -}}
    {{- $persistenceEnabled := true -}}
    {{- if hasKey $persistenceValues "enabled" -}}
      {{- $persistenceEnabled = $persistenceValues.enabled -}}
    {{- end -}}

    {{- if $persistenceEnabled -}}
      {{- $_ := set $persistenceItemsToProcess $identifier $persistenceValues -}}
    {{- end -}}
  {{- end -}}

  {{- range $identifier, $persistenceValues := $persistenceItemsToProcess -}}
    {{- /* Set some default values */ -}}

    {{- /* Set the default mountPath to /<name_of_the_peristence_item> */ -}}
    {{- $mountPath := (printf "/%v" $identifier) -}}
    {{- if eq "hostPath" (default "pvc" $persistenceValues.type) -}}
      {{- $mountPath = $persistenceValues.hostPath -}}
    {{- end -}}

    {{- /* Process configured mounts */ -}}
    {{- $volumeMount := dict -}}
    {{- $_ := set $volumeMount "name" $identifier -}}

    {{- /* Use the specified mountPath if provided */ -}}
    {{- with .path -}}
      {{- $mountPath = . -}}
    {{- end -}}
    {{- $_ := set $volumeMount "mountPath" $mountPath -}}

    {{- /* Use the specified subPath if provided */ -}}
    {{- with .subPath -}}
      {{- $subPath := . -}}
      {{- $_ := set $volumeMount "subPath" $subPath -}}
    {{- end -}}

    {{- /* Use the specified readOnly setting if provided */ -}}
    {{- with .readOnly -}}
      {{- $readOnly := . -}}
      {{- $_ := set $volumeMount "readOnly" $readOnly -}}
    {{- end -}}

    {{- $enabledVolumeMounts = append $enabledVolumeMounts $volumeMount -}}
  {{- end -}}

  {{- with $enabledVolumeMounts -}}
    {{- . | toYaml -}}
  {{- end -}}
{{- end -}}
