{ nixOsConfig, ... }:

{

  imports = [
    ../../modules/homeManager
  ];

  homeModules = {
    vsCode.enable = false;
    zed-editor.enable = true;
    yt-dlp.enable = true;
    gtk.enable = true;
    eza.enable = true;
    git.enable = true;
    starship.enable = true;
    wezterm.enable = true;
    xfce = {
      enable = nixOsConfig.modules.xfce.enable;
      scalingFactor = 2;
      dpi = 95;
    };
  };

  home.packages = [
  ];

}
