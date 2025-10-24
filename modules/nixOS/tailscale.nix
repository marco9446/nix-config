{ config, lib, ... }:

let
  cfg = config.modules.tailscale;
in
{
  options.modules.tailscale = {
    enable = lib.mkEnableOption "enable tailscale desktop";

    isExitNode = lib.mkOption {
      description = "Whether the node should be advertised as an exit node.";
      type = lib.types.bool;
      default = false;
    };
    advertiseRoutes = lib.mkOption {
      description = "List of subnet routes to advertise (e.g. [ \"192.168.188.0/24\" ]).";
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      # systemd-resolved is required for proper DNS integration
      resolved.enable = true;
      resolved.dnssec = "false";

      tailscale = {
        enable = true;
        useRoutingFeatures = "client";
        interfaceName = "tailscale0";
        # combine exit node + subnet routes
        extraSetFlags =
          (lib.optionals cfg.isExitNode [ "--advertise-exit-node" ]) ++
          (lib.optionals (cfg.advertiseRoutes != [ ])
            [ "--advertise-routes=${lib.concatStringsSep "," cfg.advertiseRoutes}" ]);

      };

      # --- Firewall configuration not sure if needed ---
      # networking.firewall = {
      #   allowedUDPPorts = lib.mkForce (config.networking.firewall.allowedUDPPorts ++ [ 41641 ]);
      #   trustedInterfaces = lib.mkForce (config.networking.firewall.trustedInterfaces ++ [ "tailscale0" ]);
      # };
    };
  };
}
