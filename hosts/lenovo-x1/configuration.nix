# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
# config for Lenovo ThinkPad X1 Extreme Gen 2
{ inputs, pkgs, ... }:
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    ./hardware-configuration.nix
    ../../modules/nixOS
  ];

  # local modules
  modules = {
    customConfig = rec {
      desktop = "cosmic";
      xcursorSize = if (desktop == "xfce") then 42 else 24;
    };
    nvidia.enable = true;
    homeManager = {
      enable = true;
      path = ./home.nix;
    };
    mullvad.enable = true;
  };

  # Bootloader.
  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 2;
      consoleMode = "1";
      # uncomment the echo comman if you want windows as default boot
      extraInstallCommands = ''
        {
          # echo "default auto-windows"
          echo "beep true"
          echo "timeout 3"
        } >> /boot/loader/loader.conf
      '';
    };
    efi.canTouchEfiVariables = true;
  };

  # New ThinkPads have a different TrackPoint manufacturer/name.
  hardware.trackpoint.device = "TPPS/2 Elan TrackPoint";

  # Fix clickpad (clicking by depressing the touchpad).
  boot.kernelParams = [ "psmouse.synaptics_intertouch=0" ];

  # Enable the X11 windowing system.
  services = {
    gnome.gnome-keyring.enable = true;
    # Enable CUPS to print documents.
    printing.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    fwupd.enable = true;
    # throttled.enable = true; # TODO check if makes a difference
    pulseaudio.enable = false;
    flatpak.enable = true;

    # Enable remapping for Logitech Wireless Mouse MX Master 3.
    # To see the list of input events, run `sudo evremap list-devices`
    evremap = {
      enable = true;
      settings.device_name = "Logitech Wireless Mouse MX Master 3";
      settings.remap = [
        {
          input = [ "BTN_EXTRA" ];
          output = [
            "KEY_LEFTCTRL"
            "KEY_LEFTMETA"
            "KEY_RIGHT"
          ];
        }
        {
          input = [ "BTN_SIDE" ];
          output = [
            "KEY_LEFTCTRL"
            "KEY_LEFTMETA"
            "KEY_LEFT"
          ];
        }
      ];
    };

    thermald.enable = true;
    power-profiles-daemon.enable = true;
    # tlp = {
    #   enable = true;
    #   settings = {
    #     CPU_SCALING_GOVERNOR_ON_AC = "performance";
    #     CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

    #     CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
    #     CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

    #     CPU_MIN_PERF_ON_AC = 0;
    #     CPU_MAX_PERF_ON_AC = 100;
    #     CPU_MIN_PERF_ON_BAT = 0;
    #     CPU_MAX_PERF_ON_BAT = 20;

    #     START_CHARGE_THRESH_BAT0 = 70;
    #     STOP_CHARGE_THRESH_BAT0 = 80;
    #   };
    # };
  };
  programs = {
    firefox.enable = true;
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    gparted
    gvfs
    thunar
  ];

  # Battery and performance Management
  powerManagement.enable = true;

  system.stateVersion = "24.11"; # Did you read the comment?
}
