# NixOS

A flake defining every NixOS host. `common.nix` is the portable, hardware-agnostic module: packages,
shell, aliases, starship, GC policy.

`common.nix` deliberately contains nothing machine-specific. Bootloader, filesystems,
`hardware-configuration.nix`, `networking.hostName` and `system.stateVersion` live under `hosts/<name>/`.

```
flake.nix              inputs (nixpkgs, nixpkgs-unstable) and one entry per host
flake.lock             exact revisions — this is what makes the config reproducible
common.nix             portable module, shared by every host
hosts/orbstack/        the OrbStack dev VM
```

## Rebuild

```sh
sudo nixos-rebuild switch --flake ~/git/dotfiles/nixos
```

Aliased to `nrs`. With no `#name`, nixos-rebuild picks the `nixosConfigurations` entry matching the
machine's hostname, so the same command works on every host.

## Updating

```sh
nix flake update                    # bump every input
nix flake update nixpkgs-unstable   # bump just one
```

Then rebuild. `flake.lock` records the exact revisions, so committing it is what lets another machine
reproduce this system.

## Adding a host

Create `hosts/<name>/configuration.nix` and add a `nixosConfigurations.<hostname>` entry to `flake.nix`
importing it plus `../../common.nix`. Name it after the machine's hostname.

## Gotchas

**Flakes only see git-tracked files.** A new file that has not been `git add`ed is invisible to the
build — you will edit it, rebuild, and see no change. Modified tracked files are picked up fine.

**Secrets stay out of this repo — it is public.** The OrbStack host's user password is referenced with
`hashedPasswordFile = "/etc/nixos/enjin.passwd"`, a root-only file created per machine:

```sh
mkpasswd -m yescrypt | sudo tee /etc/nixos/enjin.passwd && sudo chmod 600 /etc/nixos/enjin.passwd
```

**`hosts/orbstack/orbstack.nix` is a copy** of a file OrbStack generates in `/etc/nixos` and overwrites.
Re-copy it if an OrbStack upgrade changes the original.

**`/etc/nixos` is no longer the source of truth.** The old config is kept there as
`configuration.nix.pre-flake`; a bare `nixos-rebuild switch` fails on purpose so it cannot silently
build the stale one.

## Starship

`programs.starship.settings` generates a read-only `starship.toml` in the nix store, but starship prefers
`~/.config/starship.toml` if it exists — so linking the repo's copy would silently shadow the module.

`install.sh` therefore skips that one link when `/etc/NIXOS` is present. The module owns the prompt on
NixOS, the repo file owns it everywhere else. The two are kept in sync by hand; they currently differ
only in `add_newline`, which is `false` on NixOS for a compact prompt.
