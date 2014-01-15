SSH Deployment Keys Plugin for Dokku
====================================

Provides a Dokku Plugin for injecting SSH deployment keys to the container.

This is useful if you hide your sourcecode in private repositories at VCS providers such as GitHub or Bitbucket.

If you need hostkeys being added to it, checkout [dokku-hostkeys-plugin](http://github.com/cedricziel/dokku-hostkeys-plugin)

Installation
------------

```
git clone https://github.com/cedricziel/dokku-deployment-keys.git /var/lib/dokku/plugins/deployment-keys
dokku plugins-install
```

How does it work?
-----------------

On installation, this plugin generates a pair of SSH Keys (rsa, 2048b) and will echo the resulting public key.
You can add this public key to your VCS Provider-which often allow read-only SSH keys to be added to a project for CI.

The exact command used for the key generation is `ssh-keygen -q -t rsa -b 2048 -f "$shared_key_folder/id_rsa" -N ""`

The generated key at this point is a shared one, which means it is valid for any app on your Dokku host.

After generation, every subsequent container being built will get the shared key injected if it doesnt have its own pair.

FAQ
---

**Q:** Can I replace it with an existing keypair?

**A:** Of course. But its a matter of lazyness. Every user-host combination should have its own keys so they can be revoked easily. Place existing ones in `$DOKKU_ROOT/.deployment-keys/shared/.ssh. Be careful with the permissions. `chmod 600` is mandatory for some ssh-executables and this is for a good reason!

License
-------

This project is under the MIT license which can be found [here](LICENSE.md).