# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, pkgs, ... }:
{
  imports =
    [
      inputs.nixos-hardware.nixosModules.common-pc-ssd
      ./hardware-configuration.nix
      ../../modules
    ];

  # module to enable
  nvidiaModule.enable = true;
  cosmicDesktopModule.enable = true;

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
    # throttled.enable = true; # TODO check if makes a difference
    pulseaudio.enable = false;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  programs = {
    zsh.enable = true;
    firefox.enable = true;
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
