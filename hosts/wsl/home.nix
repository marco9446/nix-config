{ ... }: {


  imports = [
    ../../modules/homeManager
  ];

  homeModules = {
    git.enable = true;
    starship.enable = true;
    vsCodium.enable = false;
    xfce.enable = false;
    yt-dlp.enable = false;
    zsh.enable = true;
    eza.enable = true;
    yazi.enable = true;
    zoxide.enable = true;
    gtk.enable = false;
  };
}
