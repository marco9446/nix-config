{ pkgs, nixOsConfig, ... }:

{

  imports = [
    ../../modules/homeManager
  ];

  homeModules = {
    vsCode.enable = true;
    yt-dlp.enable = true;
    gtk.enable = true;
    eza.enable = true;
    git.enable = true;
    starship.enable = true;
    xfce = {
      enable = nixOsConfig.modules.xfce.enable;
      scalingFactor = 2;
      dpi = 95;
    };
  };

  home.packages = [
  ];

}
