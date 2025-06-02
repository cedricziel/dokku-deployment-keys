## How does it work?

On installation, this plugin generates a pair of SSH Keys (rsa, 2048b). The key can be shown via the `deployment-keys:show` command.
You can add this public key to your VCS Provider-which often allow read-only SSH keys to be added to a project for CI.

The exact command used for the key generation is `ssh-keygen -q -t rsa -b 2048 -f "$shared_key_folder/id_rsa" -N ""`

The generated key at this point is a shared one, which means it is valid for any app on your Dokku host.

After generation, every subsequent container being built will get the shared key injected if it doesnt have its own pair.

## FAQ

**Q:** Can I replace it with an existing keypair?

**A:** Of course. But its a matter of lazyness. Every user-host combination should have its own keys so they can be revoked easily. Place existing ones in `$DOKKU_ROOT/.deployment-keys/shared/.ssh. Be careful with the permissions.`chmod 600` is mandatory for some ssh-executables and this is for a good reason!
