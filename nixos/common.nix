{ pkgs, ... }:

{
  # pkgs.unstable comes from the nixpkgs-unstable flake input; see flake.nix.
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
    btop
    tree
    lsd
    ghostty.terminfo
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
    nrs = "sudo nixos-rebuild switch --flake ~/git/dotfiles/nixos";
    nfu = "nix flake update --flake ~/git/dotfiles/nixos";
  };

  environment.variables.EDITOR = "nvim";
}
