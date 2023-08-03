resource "shoreline_notebook" "too_many_processes_running_on_the_host" {
  name       = "too_many_processes_running_on_the_host"
  data       = file("${path.module}/data/too_many_processes_running_on_the_host.json")
  depends_on = [shoreline_action.invoke_regex_pattern_terminator]
}

resource "shoreline_file" "regex_pattern_terminator" {
  name             = "regex_pattern_terminator"
  input_file       = "${path.module}/data/regex_pattern_terminator.sh"
  md5              = filemd5("${path.module}/data/regex_pattern_terminator.sh")
  description      = "Killing process that match a certain regex pattern"
  destination_path = "/agent/scripts/regex_pattern_terminator.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_regex_pattern_terminator" {
  name        = "invoke_regex_pattern_terminator"
  description = "Killing process that match a certain regex pattern"
  command     = "`chmod +x /agent/scripts/regex_pattern_terminator.sh && /agent/scripts/regex_pattern_terminator.sh`"
  params      = ["REGEX_PATTERN"]
  file_deps   = ["regex_pattern_terminator"]
  enabled     = true
  depends_on  = [shoreline_file.regex_pattern_terminator]
}

