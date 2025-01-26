# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/common.nix
      ../../modules/nixVim.nix
      ../../modules/user.nix
    ];

  # Bootloader.
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
    useOSProber = true;
    # Limit the number of generations to keep
    configurationLimit = 3;
  };

  networking = {
    networkmanager.enable = true;
    hostName = "acer-aspire"; # Define your hostname.
    wireless.enable = false; # Enables wireless support via wpa_supplicant.
  };

  # Enable the X11 windowing system.
  services = {
    # needed for tailscale
    resolved.enable = true;
    xserver = {
      enable = true;
      # Enable the XFCE Desktop Environment.
      desktopManager.xfce.enable = true;
      # Configure keymap in X11
      xkb = {
        layout = "us";
        variant = "";
        options = "caps:backspace";
      };
      displayManager.lightdm.enable = true;
    };
    displayManager.autoLogin = {
      enable = false;
      user = "marco";
    };

    # Enable CUPS to print documents.
    printing.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    tailscale = {
      enable = true;
      useRoutingFeatures = "client";
    };

    pulseaudio.enable = false;
  };

  # Enable sound with pipewire.
  security.rtkit.enable = true;


  programs = {
    zsh.enable = true;
    firefox.enable = true;
    xfconf.enable = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    gparted
  ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
