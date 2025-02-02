{lib, config, ...}:{

  options = {
    modules.ssh.enable = lib.mkEnableOption "enable ssh module";
    modules.ssh.withPassword = lib.mkOption {
      default = true;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf config.modules.ssh.enable {
    # Documentation: https://wiki.nixos.org/wiki/SSH_public_key_authentication#SSH_server_config
    services.openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        passwordAuthentication = config.modules.ssh.withPassword; # set to false when you have ssh keys configured
        permitRootLogin = "no";
        UseDns = true;
      };
    };
  };
}