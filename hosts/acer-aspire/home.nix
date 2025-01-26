{ ... }: {


  imports = [
    ../../homeManager
  ];

  homeModules = {
    vsCodium.enable = true;
    vsCodium.withWailand = false;
    xfce.enable = true;
    yt-dlp.enable = true;
  };
}

 