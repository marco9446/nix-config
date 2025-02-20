{ pkgs, ... }:

{

  imports = [
    ../../modules/homeManager
  ];

  homeModules = {
    vsCodium.enable = true;
    vsCodium.withWailand = true;
    yt-dlp.enable = true;
    gtk.enable = true;
    xfce = {
      enable = false;
      scalingFactor = 2;
      cursorSize = 42;
      dpi = 95;
    };
  };

  home.packages = [
    pkgs.bambu-studio
  ];


  # xfce_scaligFactor = 2;
  # xfce_cursorSize = 56;
  # xfce_dpi = 110;
}
