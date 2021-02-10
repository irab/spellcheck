#!/usr/bin/env bats

load '/usr/local/lib/bats/load.bash'

# Uncomment the following line to debug stub failures
# export BUILDKITE_AGENT_STUB_DEBUG=/dev/tty

@test "Creates an annotation with a list of misspelt words" {
  export BUILDKITE_PLUGIN_SPELLCHECK_PATTERN="*.testfile"

  stub buildkite-agent 'annotate "Found the following misspelt words: echo Annotation created'

  run "$PWD/hooks/post-command"

  assert_success
  assert_output --partial "Found the following misspelt words:"
  assert_output --partial "unconving"
  assert_output --partial "speshal"
  assert_output --partial "conect"
  refute_contains "correct"
  assert_output --partial "Annotation created"

  unstub buildkite-agent
}
