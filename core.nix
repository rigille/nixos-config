{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    curl
    htop
    git
    zoxide
    fzf
    openssh
    silver-searcher
    tmate
    findutils
    diffutils
    man
    nil
    ripgrep
    ccls
  ];

}

