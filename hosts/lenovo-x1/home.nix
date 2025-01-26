{ pkgs, ... }: {

  imports = [
    ../../homeManager
  ];

  homeModules = {
    vsCodium.enable = true;
    vsCodium.withWailand = true;
    yt-dlp.enable = true;
  };

  home.packages = with pkgs; [
    bambu-studio
  ];


  # xfce_scaligFactor = 2;
  # xfce_cursorSize = 56;
  # xfce_dpi = 110;
}
