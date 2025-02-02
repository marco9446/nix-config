{ lib, config, ... }: {

  options = {
    homeModules.yt-dlp.enable = lib.mkEnableOption "enable yt-dlp";
  };

  config = lib.mkIf config.homeModules.yt-dlp.enable {
    programs.yt-dlp = {
      enable = true;
    };
  };
}
