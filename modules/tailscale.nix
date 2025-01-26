{ config, lib, ... }: {

  options = {
    modules.tailscale.enable = lib.mkEnableOption "enable tailscale desktop";
  };
  config = lib.mkIf config.modules.tailscale.enable {
    services = {
      # needed for tailscale
      resolved.enable = true;

      tailscale = {
        enable = true;
        useRoutingFeatures = "client";
      };
    };
  };
}
