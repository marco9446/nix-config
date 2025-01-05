{ config, pkgs, ... }:

{
  home.username = "marco";
  home.homeDirectory = "/home/marco";

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # set cursor size and dpi for 4k monitor
#   xresources.properties = {
#     "Xcursor.size" = 16;
#     "Xft.dpi" = 172;
#   };

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

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName = "marco";
    userEmail = "marco@test.com";
  };

  # starship - an customizable prompt for any shell
  programs.starship = {
    enable = true;
    # custom settings
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = true;
    };
  };



  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:"
    '';

    # set some aliases, feel free to add more or remove some
    shellAliases = {
      gt = "git status";
     };
  };

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