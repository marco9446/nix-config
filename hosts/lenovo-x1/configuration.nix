# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, pkgs, ... }:

{
  imports =
    [
      inputs.nixos-hardware.nixosModules.common-cpu-intel
      inputs.nixos-hardware.nixosModules.common-gpu-nvidia
      inputs.nixos-hardware.nixosModules.common-pc-ssd
      inputs.nixvim.nixosModules.nixvim
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/common.nix
      ../../modules/nixVim.nix
      ../../modules/user.nix
      ./nvidia.nix
    ];

  # Bootloader.
  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 3;
      consoleMode = "1";
    };
    efi.canTouchEfiVariables = true;
  };

  # Enable networking
  networking = {
    hostName = "lenovo-x1"; # Define your hostname.
    networkmanager.enable = true;
  };

  # Fixes an issue with incorrect battery reporting. See
  # https://wiki.archlinux.org/index.php/Lenovo_ThinkPad_X1_Extreme_(Gen_2)#Invalid_Stats_Workaround
  # boot.initrd.availableKernelModules = [ "battery" ];

  # New ThinkPads have a different TrackPoint manufacturer/name.
  hardware.trackpoint.device = "TPPS/2 Elan TrackPoint";

  # Fix clickpad (clicking by depressing the touchpad).
  boot.kernelParams = [ "psmouse.synaptics_intertouch=0" ];

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
      monitorSection = "DisplaySize 344 215";
      videoDrivers = [ "nvidia" ];
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
    throttled.enable = true;
    pulseaudio.enable = false;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  programs = {
    zsh.enable = true;
    firefox.enable = true;
    xfconf.enable = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
  ];

  nixpkgs.config.nvidia.acceptLicense = true;
  nixpkgs.overlays = [
    (_self: super: {
      bumblebee = super.bumblebee.override {
        extraNvidiaDeviceOptions = ''
          Option "AllowEmptyInitialConfiguration"
        '';
      };
    })
  ];

  # Since the HDMI port is connected to the NVIDIA card.
  hardware.bumblebee = {
    enable = true;
    connectDisplay = true;
    pmMethod = "auto";
    driver = "nvidia";
  };

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
