{ pkgs, ... }:

{

  imports = [
    ../../modules/homeManager
  ];

  homeModules = {
    vsCodium.enable = true;
    yt-dlp.enable = true;
    gtk.enable = true;
    xfce = {
      scalingFactor = 2;
      dpi = 95;
    };
  };

  home.packages = [
    pkgs.bambu-studio
  ];

}
