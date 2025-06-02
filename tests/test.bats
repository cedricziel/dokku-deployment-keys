#!/usr/bin/env bats
load test_helper

setup() {
  dokku apps:create my-app
}

teardown() {
  dokku --force apps:destroy my-app || true
}

@test "($PLUGIN_COMMAND_PREFIX:help) displays help" {
  run dokku "$PLUGIN_COMMAND_PREFIX:help"
  echo "output: $output"
  echo "status: $status"
  assert_success
  assert_output_contains "Manage deployment keys for an app"
}

@test "($PLUGIN_COMMAND_PREFIX:create) creates a new deployment key" {
  run dokku "$PLUGIN_COMMAND_PREFIX:create" my-app
  echo "output: $output"
  echo "status: $status"
  assert_success
  assert_output_contains "Keys created"
  assert_output_contains "ssh-rsa"
  assert_output_contains "The key will be baked into the container on next push/rebuild"
}

@test "($PLUGIN_COMMAND_PREFIX:delete) deletes a deployment key" {
  run dokku "$PLUGIN_COMMAND_PREFIX:create" my-app
  echo "output: $output"
  echo "status: $status"
  assert_success
  assert_output_contains "Keys created"

  run ls -lah "$DOKKU_ROOT/.deployment-keys/my-app/.ssh"
  echo "output: $output"
  echo "status: $status"
  assert_success
  assert_output_contains "id_rsa"
  assert_output_contains "id_rsa.pub"

  run dokku "$PLUGIN_COMMAND_PREFIX:delete" my-app
  echo "output: $output"
  echo "status: $status"
  assert_success
  assert_output_contains "Removed deployment keys for my-app"
}

@test "($PLUGIN_COMMAND_PREFIX:shared) shows the shared key" {
  run dokku --trace "$PLUGIN_COMMAND_PREFIX:shared" my-app
  echo "output: $output"
  echo "status: $status"
  assert_success
  assert_output_contains "ssh-rsa"
}

@test "($PLUGIN_COMMAND_PREFIX:show) shows a deployment key" {
  run dokku "$PLUGIN_COMMAND_PREFIX:show" my-app
  echo "output: $output"
  echo "status: $status"
  assert_success
  assert_output_contains "ssh-rsa"
}

@test "($PLUGIN_COMMAND_PREFIX:status) show which key is used" {
  run dokku "$PLUGIN_COMMAND_PREFIX:status" my-app
  echo "output: $output"
  echo "status: $status"
  assert_success
  assert_output_contains "This app uses the shared set of deployment keys."

  run dokku "$PLUGIN_COMMAND_PREFIX:create" my-app
  echo "output: $output"
  echo "status: $status"
  assert_success
  assert_output_contains "Keys created"
  assert_output_contains "ssh-rsa"
  assert_output_contains "The key will be baked into the container on next push/rebuild"

  run dokku "$PLUGIN_COMMAND_PREFIX:status" my-app
  echo "output: $output"
  echo "status: $status"
  assert_success
  assert_output_contains "This app uses a private set of deployment keys."
}

@test "($PLUGIN_COMMAND_PREFIX:deploy) ensure the app-specific key is baked into the container" {
  run dokku "$PLUGIN_COMMAND_PREFIX:create" my-app
  echo "output: $output"
  echo "status: $status"
  assert_success
  assert_output_contains "Keys created"
  assert_output_contains "ssh-rsa"
  assert_output_contains "The key will be baked into the container on next push/rebuild"

  run dokku git:sync --build my-app https://github.com/dokku/smoke-test-app.git
  echo "output: $output"
  echo "status: $status"
  assert_success
  assert_output_contains "Adding app specific deployment-keys to build environment"
  assert_output_contains "Creating .ssh folder for deployment-keys"
  assert_output_contains "Transferring app specific private key to container"
  assert_output_contains "Transferring app specific public key to container"
  assert_output_contains "Adding identity file option to global SSH config"
}
