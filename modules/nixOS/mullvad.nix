
{ lib, config, pkgs, ... }: {

  options = {
    modules.mullvad.enable = lib.mkEnableOption "enable mullvad module";
  };

  config = lib.mkIf config.modules.mullvad.enable {
    # Enable the Mullvad VPN client
    services.mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };
  };

}
