{lib, config, ...}:{

  options = {
    modules.docker.enable = lib.mkEnableOption "enable docker module";
  };

  config = lib.mkIf config.modules.docker.enable {
    # Documentation: https://wiki.nixos.org/wiki/Docker
    virtualisation.docker= {
      enable = true;
      enableOnBoot = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
      autoPrune = {
        enable = true;
        dates = "weekly";
        flags = [
          "--all"
          "--force"
        ];
      };
    };
  };
}