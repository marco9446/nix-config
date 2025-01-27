{ pkgs-stable, ... }:

{

  imports = [
    ../../homeManager
  ];

  homeModules = {
    vsCodium.enable = true;
    vsCodium.withWailand = true;
    yt-dlp.enable = true;
  };

  home.packages = [
    pkgs-stable.bambu-studio
  ];


  # xfce_scaligFactor = 2;
  # xfce_cursorSize = 56;
  # xfce_dpi = 110;
}
