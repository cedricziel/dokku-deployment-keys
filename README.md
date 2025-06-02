# dokku deployment-keys [![Build Status](https://img.shields.io/github/actions/workflow/status/cedricziel/dokku-deployment-keys/ci.yaml?branch=master&style=flat-square "Build Status")](https://github.com/cedricziel/dokku-deployment-keys/actions/workflows/ci.yaml?query=branch%3Amaster) [![IRC Network](https://img.shields.io/badge/irc-libera-blue.svg?style=flat-square "IRC Libera")](https://webchat.libera.chat/?channels=dokku)

Manage SSH deployment keys that should get injected into your containers on-build

This is useful if you hide your sourcecode in private repositories at VCS providers such as GitHub or Bitbucket.

## Requirements

- dokku 0.19.x+
- docker 1.8.x

Optionally, if you need host keys to be added, install the [host-keys plugin](https://github.com/cedricziel/dokku-hostkeys-plugin) as well.

## Installation

```shell
# on 0.19.x+
sudo dokku plugin:install https://github.com/cedricziel/dokku-deployment-keys.git --name deployment-keys
```

## Commands

```
deployment-keys:create <app> # create a pair of app-specific deployment keys
deployment-keys:delete <app> # delete the current pair of deployment keys
deployment-keys:shared       # shows the current shared public key
deployment-keys:show <app>   # shows the current public key to add to your VCS
deployment-keys:status <app> # shows the current status of the deployment keys for an app
```

## Usage

Help for any commands can be displayed by specifying the command as an argument to deployment-keys:help. Plugin help output in conjunction with any files in the `docs/` folder is used to generate the plugin documentation. Please consult the `deployment-keys:help` command for any undocumented commands.

### Basic Usage

### create a pair of app-specific deployment keys

```shell
# usage
dokku deployment-keys:create <app>
```

Create a pair of app-specific deployment keys:

```shell
dokku deployment-keys:create my-app
```

### delete the current pair of deployment keys

```shell
# usage
dokku deployment-keys:delete <app>
```

Delete the current pair of deployment keys:

```shell
dokku deployment-keys:delete my-app
```

### shows the current shared public key

```shell
# usage
dokku deployment-keys:shared
```

Shows the current shared public key:

```shell
dokku deployment-keys:shared
```

### shows the current public key to add to your VCS

```shell
# usage
dokku deployment-keys:show <app>
```

Shows the current public key to add to your `VCS`:`

```shell
dokku deployment-keys:show my-app
```

### shows the current status of the deployment keys for an app

```shell
# usage
dokku deployment-keys:status <app>
```

Shows the current status of the deployment keys for an app:

```shell
dokku deployment-keys:status my-app
```

## How does it work?

On installation, this plugin generates a pair of SSH Keys (rsa, 2048b). The key can be shown via the `deployment-keys:show` command.
You can add this public key to your VCS Provider-which often allow read-only SSH keys to be added to a project for CI.

The exact command used for the key generation is `ssh-keygen -q -t rsa -b 2048 -f "$shared_key_folder/id_rsa" -N ""`

The generated key at this point is a shared one, which means it is valid for any app on your Dokku host.

After generation, every subsequent container being built will get the shared key injected if it doesnt have its own pair.

## FAQ

**Q:** Can I replace it with an existing keypair?

**A:** Of course. But its a matter of lazyness. Every user-host combination should have its own keys so they can be revoked easily. Place existing ones in `$DOKKU_ROOT/.deployment-keys/shared/.ssh. Be careful with the permissions.`chmod 600` is mandatory for some ssh-executables and this is for a good reason!

