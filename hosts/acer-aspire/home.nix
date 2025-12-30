{ ... }:
{

  imports = [
    ../../modules/homeManager
  ];

  homeModules = {
    vsCode.enable = true;
    zed-editor.enable = true;
    yt-dlp.enable = true;
    wezterm.enable = true;
  };
}
