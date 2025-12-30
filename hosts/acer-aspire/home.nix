{ ... }:
{

  imports = [
    ../../modules/homeManager
  ];

  homeModules = {
    vsCode.enable = false;
    zed-editor.enable = true;
    yt-dlp.enable = true;
    wezterm.enable = true;
  };
}
