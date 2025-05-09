# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./s3nixcache-mixrank.nix
      ./core.nix
    ];
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    users.rigille = { pkgs, ... }: {
      home.stateVersion = "22.11";  # Use the same version as your NixOS

      programs = {
        bash.enable = true;
        kitty = {
          enable = true;
          settings = {
            shell = "bash";
            scrollback_pager = "nvim -c 'set signcolumn=no nonumber nolist showtabline=0 foldcolumn=0' -c '%s/\\%x1b\\[[0-9;]*[a-zA-Z]//g' -c 'normal G' -c 'map q :qa!<CR>' -";
          };
          font.name = "JuliaMono";
          shellIntegration = {
            enableBashIntegration = true;
          };
        };
        zoxide.enable = true;
      };
    
      # This is important to manage your dotfiles
      home.file = {
        # Example: .bashrc
        #".bashrc".source = ./bashrc;
      };
    };
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.initrd.kernelModules = [ "amdgpu" "i2c-dev" "i2c-piix4" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ xone ];

  

  networking.hostName = "rigille-workstation"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Bahia";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.yggdrasil.enable = true;
  services.yggdrasil.settings.Peers = ["tcp://95.164.4.146:7676"];
  services.xserver.videoDrivers = [ "amdgpu" ];
  services.hardware.openrgb.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = false;
  services.xserver.desktopManager.gnome.enable = true;
  #services.xserver.windowManager.xmonad = {
  #  enable = true;
  #  enableContribAndExtras = true;
  #  config = builtins.readFile ./xmonad.hs;
  #};

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "br";
    xkb.variant = "";
  };

  # Configure console keymap
  console.keyMap = "br-abnt2";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.bluetooth.enable = true;
  hardware.i2c.enable = true;
  hardware.firmware = [ pkgs.rtl8761b-firmware ];
  hardware.pulseaudio.enable = false;
  hardware.graphics.extraPackages = with pkgs; [
    rocmPackages.clr.icd
  ];
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.rigille = {
    isNormalUser = true;
    description = "Rígille";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    ];
  };
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;
  nixpkgs.config.tarball-ttl = 0;

  nix.package = pkgs.lib.mkForce pkgs.nixVersions.latest;
  nix.settings.experimental-features = [ "nix-command" "flakes" "ca-derivations" ];
  nix.settings.keep-outputs = true;
  nix.settings.keep-derivations = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    ed
    inputs.neovim.outputs.packages.x86_64-linux.default
    firefox-esr
    radeontop
    prismlauncher
    xonotic-glx
    discord
    tdesktop
    spotify
    snes9x-gtk
    tree
    google-cloud-sdk
    vim
    pyright
    nil
    element-desktop
    compcert
    openrgb
    libsForQt5.okular
    tor
    tor-browser-bundle-bin
    calibre
    mdcat
    xclip
    blender
    wget
    (pkgs.writeShellScriptBin "reliable-download" ''
      wget -c --timeout=60 --tries=0 --retry-connrefused --waitretry=5 "$@"
    '')
  ];
  fonts.packages = with pkgs; [
    julia-mono
  ];
  environment.variables.EDITOR = "nvim";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  services.flatpak.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [];
  networking.firewall.allowedUDPPorts = [];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}
