{
  lib,
  pkgs,
  username,
  config,
  nixOsConfig,
  ...
}:
{

  imports = [
    ./git.nix
    ./zed-editor.nix
    ./starship.nix
    ./vsCode.nix
    ./xfce.nix
    ./yt-dlp.nix
    ./zsh.nix
    ./eza.nix
    ./yazi.nix
    ./zoxide.nix
    ./gtk.nix
    ./hyprland.nix
    ./wezterm.nix
  ];

  homeModules = {
    git.enable = lib.mkDefault true;
    starship.enable = lib.mkDefault true;
    vsCode.enable = lib.mkDefault false;
    xfce.enable = lib.mkDefault nixOsConfig.modules.xfce.enable;
    hyprland.enable = lib.mkDefault nixOsConfig.modules.hyprland.enable;
    yt-dlp.enable = lib.mkDefault false;
    zsh.enable = lib.mkDefault true;
    eza.enable = lib.mkDefault true;
    yazi.enable = lib.mkDefault true;
    zoxide.enable = lib.mkDefault true;
    gtk.enable = lib.mkDefault true;
    wezterm.enable = lib.mkDefault false;
    zed-editor.enable = lib.mkDefault false;
  };

  home.username = username;
  home.homeDirectory = "/home/${username}";

  # apply dotfile
  xdg.configFile."cosmic" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/${username}/nix-config/dotfiles/cosmic";
    recursive = true;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = nixOsConfig.modules.customConfig.xcursorSize;
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # archives
    zip
    unzip

    # utils
    jq # A lightweight and flexible command-line JSON processor

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
