{ pkgs, ... }:

{

  imports = [
    ../../modules/homeManager
  ];

  homeModules = {
    vsCode.enable = true;
    yt-dlp.enable = true;
    gtk.enable = false;
    wezterm.enable = true;
    xfce = {
      scalingFactor = 2;
      dpi = 95;
    };
  };

  home.packages = [
    pkgs.python313
  ];

}
