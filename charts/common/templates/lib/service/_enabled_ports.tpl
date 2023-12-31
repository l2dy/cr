{{/*
Return the enabled ports for a given Service object.
*/}}
{{- define "bjw-s.common.lib.service.enabledPorts" -}}
  {{- $rootContext := .rootContext -}}
  {{- $serviceObject := .serviceObject -}}

  {{- $enabledPorts := dict -}}

  {{- range $name, $port := $serviceObject.ports -}}
    {{- if kindIs "map" $port -}}
      {{- $portEnabled := true -}}
      {{- if hasKey $port "enabled" -}}
        {{- $portEnabled = $port.enabled -}}
      {{- end -}}
      {{- if $portEnabled -}}
        {{- $_ := set $enabledPorts $name . -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
  {{- $enabledPorts | toYaml -}}
{{- end -}}
