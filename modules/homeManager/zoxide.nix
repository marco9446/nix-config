{ lib, config, ... }: {

  options = {
    homeModules.zoxide.enable = lib.mkEnableOption "enable zoxide";
  };

  config = lib.mkIf config.homeModules.zoxide.enable {
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [
        "--cmd cd"
      ];
    };
  };
}
