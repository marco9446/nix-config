{ ... }: {


  imports = [
    ../../modules/homeManager
  ];

  homeModules = {
    vsCodium.enable = true;
    yt-dlp.enable = true;
  };
}

 