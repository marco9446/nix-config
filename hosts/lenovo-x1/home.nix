{ pkgs, nixOsConfig, ... }:

{

  imports = [
    ../../modules/homeManager
  ];

  homeModules = {
    vsCodium.enable = true;
    vsCodium.withWailand = !nixOsConfig.modules.xfce.enable;
    yt-dlp.enable = true;
    gtk.enable = true;
    xfce = {
      enable = nixOsConfig.modules.xfce.enable;
      scalingFactor = 2;
      cursorSize = 42;
      dpi = 95;
    };
  };

  home.packages = [
    pkgs.bambu-studio
  ];

}
