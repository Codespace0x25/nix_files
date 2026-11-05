# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nixpkgs.config.allowUnfree = true;
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # networking.hostName = "nixos"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 wiomdowing system.
  services.xserver.enable = true;

  services.xserver.displayManager.startx.enable = true;
  services.getty.autologinUser = "ivy";

nix.settings.experimental-features = [
  "nix-command"
  "flakes"
];


  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

 security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

services.pipewire.wireplumber.extraConfig = {
  "51-alsa-profile" = {
    "monitor.alsa.rules" = [
      {
        matches = [
          {
            "device.name" = "alsa_card.pci-0000_00_0e.0";
          }
        ];
        actions = {
          update-props = {
            "device.profile" = "output:analog-stereo";
          };
        };
      }
    ];
  };
};



programs.appimage = {
  enable = true;
  binfmt = true;
};
  # Enable touchpad support (enabled default in most desktopManager).
   # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ivy = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio"];
    shell=pkgs.bash;
    home="/home/ivy";
    packages = with pkgs; [
      emacs
      libtool
      git
      emacsPackages.vterm
      tree
      xdotool
      discord
      putty
      ocaml-ng.ocamlPackages.ocaml
      ocaml-ng.ocamlPackages.dune_3
      ocaml-ng.ocamlPackages.ocaml-lsp
      ocaml-ng.ocamlPackages.ocamlformat
      opam
      nautilus
      qemu
      espeak
      fasm
      prismlauncher
      discount
      (prismlauncher.override {
      # Add binary required by some mod
      additionalPrograms = [ ffmpeg ];
      # Change Java runtimes available to Prism Launcher
      jdks = [
       graalvmPackages.graalvm-ce
       zulu8
       zulu17
       zulu
       ];
      })
    ];
  };


  services.udev.extraRules = ''
   SUBSYSTEM=="usb", ATTR{idVendor}=="10f5", ATTR{idProduct}=="223a", MODE="0660", GROUP="wheel"
    '';
  programs.firefox.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  programs.gamemode.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    emacs
    wget
    pulseaudio
    libvterm
    cmake
    gnumake
    clang
    gcc
    feh
    picom
    alsa-utils
    unzip
    clang-tools
];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

}

