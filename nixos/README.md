# NixOS

`common.nix` is the portable, hardware-agnostic module: packages, shell, aliases, starship, GC policy.

It deliberately contains nothing machine-specific. Bootloader, filesystems, `hardware-configuration.nix`,
`networking.hostName` and `system.stateVersion` stay in each host's own `configuration.nix`.

## Use it on a machine

```sh
sudo ln -s ~/git/dotfiles/nixos/common.nix /etc/nixos/common.nix
```

Then add it to the `imports` list in `/etc/nixos/configuration.nix`:

```nix
imports = [
  ./hardware-configuration.nix
  ./common.nix
];
```

and `sudo nixos-rebuild switch`.

## Pinned unstable

Packages that move faster than the stable channel (`pixi`, `bun`, `pi-coding-agent`) come from a pinned
nixos-unstable tarball rather than the system channel, so every machine gets the same versions.

To bump it, pick a commit from https://github.com/NixOS/nixpkgs/commits/nixos-unstable and hash it:

```sh
nix-prefetch-url --unpack https://github.com/NixOS/nixpkgs/archive/<rev>.tar.gz
```

Use a rev from the `nixos-unstable` branch, not `master` — master commits have not been through Hydra,
so nothing is in the binary cache and everything builds from source.

## Starship on NixOS

`programs.starship.settings` here generates a read-only `starship.toml` in the nix store, but starship prefers
`~/.config/starship.toml` if it exists. Running `install.sh` on a NixOS host symlinks that file and it wins over
this module. Pick one — either drop `programs.starship.settings` or don't link starship in `install.sh`.
