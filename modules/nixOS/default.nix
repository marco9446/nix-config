{ lib, pkgs, inputs, host, config, ... }: {

  imports = [
    ./cosmicDesktop.nix
    ./xfce.nix
    ./nvidia.nix
    ./bluetooth.nix
    ./nixVim.nix
    ./user.nix
    ./tailscale.nix
    ./homeManager.nix
    ./ssh.nix
    ./docker.nix
    ./nh.nix
  ];

  options = {
    modules.customConfig = {
      desktop = lib.mkOption {
        description = "The desktop environment you intend to use";
        type = lib.types.enum [ "none" "xfce" "cosmic" ];
      };
      xcursorSize = lib.mkOption {
        type = lib.types.str;
        default = "20";
      };
    };
  };

  config = {
    modules = {
      nvidia.enable = lib.mkDefault false;
      cosmicDesktop.enable = config.modules.customConfig.desktop == "cosmic";
      xfce.enable = config.modules.customConfig.desktop == "xfce";
      bluetooth.enable = lib.mkDefault true;
      nixVim.enable = lib.mkDefault true;
      tailscale.enable = lib.mkDefault false;
      homeManager.enable = lib.mkDefault false;
      ssh.enable = lib.mkDefault false;
      docker.enable = lib.mkDefault false;
      user.enable = lib.mkDefault true;
      nh.enable = lib.mkDefault true;
    };

    environment.sessionVariables = {
      XCURSOR_SIZE = config.modules.customConfig.xcursorSize;
    };

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;
    nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

    # Enable the Flakes feature and the accompanying new nix command-line tool
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    nix.settings.warn-dirty = false;

    # Enable networking
    networking = {
      hostName = host;
      networkmanager.enable = true;
    };

    # Set your time zone.
    time.timeZone = "Europe/Rome";

    # Select internationalisation properties.
    i18n = {
      defaultLocale = "en_US.UTF-8";
      extraLocaleSettings = {
        LC_ADDRESS = "it_IT.UTF-8";
        LC_IDENTIFICATION = "it_IT.UTF-8";
        LC_MEASUREMENT = "it_IT.UTF-8";
        LC_MONETARY = "it_IT.UTF-8";
        LC_NAME = "it_IT.UTF-8";
        LC_NUMERIC = "it_IT.UTF-8";
        LC_PAPER = "it_IT.UTF-8";
        LC_TELEPHONE = "it_IT.UTF-8";
        LC_TIME = "it_IT.UTF-8";
      };
    };


    # Perform garbage collection weekly to maintain low disk usage
    nix.gc = {
      automatic = lib.mkIf config.programs.nh.enable == false;
      dates = "weekly";
      options = "--delete-older-than 1w";
    };

    programs = {
      zsh.enable = true;
    };

    # List packages installed in system profile.
    environment.systemPackages = with pkgs; [
      wget
      git
      htop
      lshw
    ];
  };
}
