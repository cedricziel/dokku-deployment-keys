#!/usr/bin/env bats
load test_helper

setup() {
  dokku apps:create my-app
}

teardown() {
  dokku --force apps:destroy my-app || true
}

@test "($PLUGIN_COMMAND_PREFIX:create) creates a new deployment key" {
  dokku "$PLUGIN_COMMAND_PREFIX:create" my-app
  assert_output_contains "Keys created"
  assert_output_contains "ssh-rsa"
  assert_output_contains "They will be baked into the container on next push/rebuild"
}
