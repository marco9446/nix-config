{ config, pkgs, ... }:

{
  home.username = "marco";
  home.homeDirectory = "/home/marco";

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

    yt-dlp
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
