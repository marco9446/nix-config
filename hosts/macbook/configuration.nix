# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, inputs, ... }:

{
  imports =
    [
      inputs.nixos-hardware.nixosModules.common-pc-ssd
      ./hardware-configuration.nix
      ../../modules/nixOS
    ];

  # local modules 
  modules = {
    customConfig = rec{
      desktop = "cosmic";
      xcursorSize = if (desktop == "xfce") then 42 else 22;
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
      configurationLimit = 3;
      consoleMode = "1";
    };
    efi.canTouchEfiVariables = true;
  };

  # Enable the X11 windowing system.
  services = {
    # Enable CUPS to print documents.
    printing.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    fwupd.enable = true;

    # throttled.enable = true; # TODO check if makes a difference
    pulseaudio.enable = false;
  };

  # set initial backlight to 50%
  systemd.services.set-backlight = {
    description = "Set backlight to desired brightness";
    wantedBy = [ "multi-user.target" ]; # Ensure it runs after the system is ready

    script = "echo 515 | tee /sys/class/backlight/gmux_backlight/brightness";
    serviceConfig.User = "root"; # Ensure the command runs as root
  };

  nixpkgs.config.permittedInsecurePackages = [
    "broadcom-sta-6.30.223.271-59-6.12.63"
  ];

  programs = {
    firefox.enable = true;
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    gparted
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
