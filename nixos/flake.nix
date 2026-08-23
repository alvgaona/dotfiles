{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, ... }: {
    # The portable module, so other flakes can import it directly.
    nixosModules.common = ./common.nix;

    # Named for the host's hostname so `nixos-rebuild --flake <dir>` selects it automatically.
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        ./hosts/orbstack/configuration.nix
        {
          nixpkgs.overlays = [
            (final: prev: {
              unstable = import nixpkgs-unstable {
                inherit (prev.stdenv.hostPlatform) system;
              };
            })
          ];
        }
      ];
    };
  };
}
