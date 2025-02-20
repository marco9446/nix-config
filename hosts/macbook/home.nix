{ pkgs, ... }:

{

  imports = [
    ../../modules/homeManager
  ];

  homeModules = {
    vsCodium.enable = true;
    vsCodium.withWailand = false;
    yt-dlp.enable = true;
    gtk.enable = true;
    eza.enable = true;
    git.enable = true;
    starship.enable = true;
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

}
