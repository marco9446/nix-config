{ nixOsConfig, ... }: {


  imports = [
    ../../modules/homeManager
  ];

  homeModules = {
    vsCodium.enable = true;
    vsCodium.withWailand = !nixOsConfig.modules.xfce.enable;
    yt-dlp.enable = true;
    xfce = {
      enable = nixOsConfig.modules.xfce.enable;
    };
  };
}

 