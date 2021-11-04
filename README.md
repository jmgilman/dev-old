# Development Tools

The purpose of this repository is to document and automate the process of
setting up my developmnt machine. It contains details about the machine, initial
setup steps, and all scripts and configuration files necessary to configure the
machine to a specific state. Idempotent tools like Ansible are heavily used
where possible to prevent configuration drift. 

## Specifications

* **Manufacturer**: Apple
* **Model**: 16-inch MacBook Pro (2021)
* **CPU**: Apple M1 Max chip (10-core CPU, 32-core GPU)
* **RAM**: 64GB unified memory
* **Disk**: 1TB SSD storage

## Bootstrapping

The below steps should be followed after a fresh installation:

1. Open up the default terminal
2. Clone this repository
3. Run `bootstrap.sh`
4. Close the default terminal and use iTerm2 going forward

## PGP

The git config is set to automatically sign commits. The `gpg` and `keybase` CLI
utilities are automatically installed by the Ansible playbook but need to be
configured before commit signing will work. As of the time of this writing, the
`keybase` CLI tool is built from source as the app doesn't support the M1 architecture.
Thus, a few steps are required for provisioning:

```
# Note: the updater will fail to start due to it not being installed
$> keybase ctl start

# Follow the process for provisioning the machine with Keybase
$> keybase login

# Import public PGP key
$> keybase pgp export | gpg --import

# Import private PGP key (the first prompt requires inputting Keybase password)
# Subsequent prompts should use a new password for protecting the local copy
$> keybase pgp export --secret | gpg --allow-secret-key --import

# Validate the keys were imported
$> gpg --list-secret-keys --keyid-format LONG
sec   rsa4096/2597B7B8631DA129 2021-09-03 [SC] [expires: 2037-08-30]
      1144FF814BB691F4E19358F92597B7B8631DA129
uid                 [ultimate] Joshua Gilman <joshuagilman@gmail.com>
ssb   rsa4096/60F87512A98BC942 2021-09-03 [E] [expires: 2037-08-30]

# Set the trust level for the key
$> gpg --edit-key 2597B7B8631DA129
gpg> trust
sec  rsa4096/2597B7B8631DA129
     created: 2021-09-03  expires: 2037-08-30  usage: SC
     trust: unknown       validity: unknown
ssb  rsa4096/60F87512A98BC942
     created: 2021-09-03  expires: 2037-08-30  usage: E
[ unknown] (1). Joshua Gilman <joshuagilman@gmail.com>

Please decide how far you trust this user to correctly verify other users' keys
(by looking at passports, checking fingerprints from different sources, etc.)

  1 = I don't know or won't say
  2 = I do NOT trust
  3 = I trust marginally
  4 = I trust fully
  5 = I trust ultimately
  m = back to the main menu

Your decision? 5

# Configure git
$> git config --global user.signingkey 2597B7B8631DA129
```