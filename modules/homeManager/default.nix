{ lib, pkgs, username, ... }: {

  imports = [
    ./git.nix
    ./starship.nix
    ./vsCodium.nix
    ./xfce.nix
    ./yt-dlp.nix
    ./zsh.nix
    ./eza.nix
    ./yazi.nix
  ];

  homeModules = {
    git.enable = lib.mkDefault true;
    starship.enable = lib.mkDefault true;
    vsCodium.enable = lib.mkDefault false;
    xfce.enable = lib.mkDefault false;
    yt-dlp.enable = lib.mkDefault false;
    zsh.enable = lib.mkDefault true;
    eza.enable = lib.mkDefault true;
    yazi.enable = lib.mkDefault true;
  };


  home.username = username;
  home.homeDirectory = "/home/${username}";

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # archives
    zip
    unzip

    # utils
    jq # A lightweight and flexible command-line JSON processor

    # nix related
    nh

    # system tools
    lm_sensors # for `sensors` command
    pciutils # lspci
    usbutils # lsusb

    # fonts
    nerd-fonts.jetbrains-mono
  ];

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.11";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
