# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, pkgs, ... }:
{
  imports =
    [
      inputs.nixos-hardware.nixosModules.common-pc-ssd
      ./hardware-configuration.nix
      ../../modules/nixOS
    ];

  # local modules
  modules = {
    customConfig = rec {
      desktop = "cosmic";
      xcursorSize =
        if (desktop == "xfce") then "42"
        else if (desktop == "gnome") then "24"
        else "20";
    };
    nvidia.enable = true;
    homeManager = {
      enable = true;
      path = ./home.nix;
    };
  };

  # Bootloader.
  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 2;
      consoleMode = "1";
      # uncomment the echo comman if you wnat windows as default boot
      extraInstallCommands = ''
        {
          # echo "default auto-windows"
          echo "beep true"
          echo "timeout 2"
        } >> /boot/loader/loader.conf
      '';
    };
    efi.canTouchEfiVariables = true;
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
    # Enable CUPS to print documents.
    printing.enable = false;
    power-profiles-daemon.enable = true;
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
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  programs = {
    firefox.enable = true;
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    gparted
    gvfs
    xfce.thunar
  ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  system.stateVersion = "24.11"; # Did you read the comment?
}
