{ pkgs, ... }:

let
  # Pinned nixos-unstable, for packages that move faster than the stable channel.
  # Bump: nix-prefetch-url --unpack https://github.com/NixOS/nixpkgs/archive/<rev>.tar.gz
  unstable = import
    (fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/2c423e03bbafcff28bfadc6781a4a8257f205cb5.tar.gz";
      sha256 = "0sncav0zwd301731dh1pqdfgwiak5af6b5gg178wy0zcrdsidpkn";
    })
    { inherit (pkgs.stdenv.hostPlatform) system; };
in
{
  time.timeZone = "Europe/Madrid";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  environment.systemPackages = with pkgs; [
    gh
    git
    neovim
    curl
    wget
    ripgrep
    fd
    jq
    htop
    tree
    lsd
    nodejs_24
    unstable.pixi
    unstable.pi-coding-agent
    unstable.bun
  ];

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      container.disabled = true;
      gcloud.disabled = true;
      pixi.disabled = false;
    };
  };

  environment.shellAliases = {
    ls = "lsd";
    ll = "lsd -la";
    lt = "lsd --tree";
    gs = "git status";
    gd = "git diff";
    nrs = "sudo nixos-rebuild switch";
  };

  environment.variables.EDITOR = "nvim";
}
