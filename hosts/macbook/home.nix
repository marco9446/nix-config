{ pkgs-stable, ... }:

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
    pkgs-stable.bambu-studio
  ];

}
