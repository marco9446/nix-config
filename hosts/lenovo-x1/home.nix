{ pkgs, ... }:

{

  imports = [
    ../../modules/homeManager
  ];

  homeModules = {
    vsCode.enable = true;
    yt-dlp.enable = true;
    gtk.enable = false;
    xfce = {
      scalingFactor = 2;
      dpi = 95;
    };
  };

  home.packages = [
    pkgs.python313
  ];

}
