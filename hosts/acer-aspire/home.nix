{ ... }: {


  imports = [
    ../../modules/homeManager
  ];

  homeModules = {
    vsCode.enable = true;
    yt-dlp.enable = true;
  };
}

 