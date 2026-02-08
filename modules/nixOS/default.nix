{ lib
, pkgs
, inputs
, host
, config
, ...
}:
{

  imports = [
    ./cosmicDesktop.nix
    ./xfce.nix
    ./nvidia.nix
    ./bluetooth.nix
    ./nixVim.nix
    ./user.nix
    ./user-family.nix
    ./tailscale.nix
    ./homeManager.nix
    ./ssh.nix
    ./docker.nix
    ./nh.nix
    ./niri.nix
    ./gnome.nix
    ./mullvad.nix
    ./defaultPackages.nix
  ];

  options = {
    modules.customConfig = {
      desktop = lib.mkOption {
        description = "The desktop environment you intend to use";
        type = lib.types.enum [
          "none"
          "xfce"
          "cosmic"
          "gnome"
          "niri"
        ];
      };
      xcursorSize = lib.mkOption {
        type = lib.types.int;
        default = 20;
      };
      userShell = lib.mkOption {
        type = lib.types.package;
        default = pkgs.zsh;
        description = "Shell package to use for the user (set to e.g. pkgs.zsh).";
      };
    };
  };

  config = {
    modules = {
      defaultPackages.enable = lib.mkDefault true;
      nvidia.enable = lib.mkDefault false;
      cosmicDesktop.enable = config.modules.customConfig.desktop == "cosmic";
      xfce.enable = config.modules.customConfig.desktop == "xfce";
      gnome.enable = config.modules.customConfig.desktop == "gnome";
      niriDesktop.enable = config.modules.customConfig.desktop == "niri";
      bluetooth.enable = lib.mkDefault true;
      nixVim.enable = lib.mkDefault true;
      tailscale.enable = lib.mkDefault false;
      homeManager.enable = lib.mkDefault false;
      ssh.enable = lib.mkDefault false;
      docker.enable = lib.mkDefault false;
      user.enable = lib.mkDefault true;
      nh.enable = lib.mkDefault true;
      mullvad.enable = lib.mkDefault false;
    };

    # environment.sessionVariables = {
    #   XCURSOR_SIZE = config.modules.customConfig.xcursorSize;
    # };

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;
    nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

    # Enable the Flakes feature and the accompanying new nix command-line tool
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    nix.settings.warn-dirty = false;

    # Enable networking
    networking = {
      hostName = host;
      networkmanager.enable = true;
    };

    # Set your time zone.
    time.timeZone = "Europe/Zurich";

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
      # wsl does not have proper timekeeping when suspended
      automatic = config.programs.nh.clean.enable == false && host != "wsl";
      dates = "18:00";
    };

    programs = {
      zsh.enable = config.modules.customConfig.userShell == pkgs.zsh;
      bash.enable = config.modules.customConfig.userShell == pkgs.bash;
    };

  };
}
