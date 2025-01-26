{ pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules
    ];

  # local modules
  modules = {
    xfce.enable = true;
  };

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
    # Enable CUPS to print documents.
    printing.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    pulseaudio.enable = false;
  };

  # Enable sound with pipewire.
  security.rtkit.enable = true;

  programs = {
    zsh.enable = true;
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
