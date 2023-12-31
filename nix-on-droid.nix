{ config, lib, pkgs, ... }:

{
  imports = [
    ./core.nix
  ];
  # Simply install just the packages
  environment.packages = with pkgs; [
    chez-racket
  ];

  # Backup etc files instead of failing to activate generation if a file already exists in /etc
  environment.etcBackupExtension = ".bak";

  # Read the changelog before changing this value
  system.stateVersion = "22.11";

  # Set up nix for flakes
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Set your time zone
  #time.timeZone = "Europe/Berlin";

  # After installing home-manager channel like
  #   nix-channel --add https://github.com/rycee/home-manager/archive/release-22.11.tar.gz home-manager
  #   nix-channel --update
  # you can configure home-manager in here like
  #home-manager = {
  #  useGlobalPkgs = true;
  #
  #  config =
  #    { config, lib, pkgs, ... }:
  #    {
  #      # Read the changelog before changing this value
  #      home.stateVersion = "22.11";
  #
  #      # insert home-manager config
  #    };
  #};
}

# vim: ft=nix
