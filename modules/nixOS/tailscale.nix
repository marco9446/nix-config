{ config, lib, pkgs, ... }:

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
    webClient = {
      enable = lib.mkEnableOption "enable tailscale web client service";
      listenAddr = lib.mkOption {
        description = "IP address for Tailscale web client to listen on.";
        type = lib.types.str;
        default = "127.0.0.1";
      };
      port = lib.mkOption {
        description = "Port for Tailscale web client.";
        type = lib.types.port;
        default = 8080;
      };
    };
  };

  config = lib.mkIf cfg.enable {

    networking.firewall.allowedTCPPorts = [ 5252 ]
      ++ (lib.optionals cfg.webClient.enable [ cfg.webClient.port ]);

    # https://search.nixos.org/options?channel=unstable&query=services.tailscale.
    services = {
      # systemd-resolved is required for proper DNS integration
      resolved.enable = true;
      resolved.dnssec = "false";

      tailscale = {
        enable = true;
        useRoutingFeatures = "server";
        interfaceName = "tailscale0";
        # combine exit node + subnet routes
        extraSetFlags =
          (lib.optionals cfg.isExitNode [ "--advertise-exit-node" ]) ++
          (lib.optionals (cfg.advertiseRoutes != [ ])
            [ "--advertise-routes=${lib.concatStringsSep "," cfg.advertiseRoutes}" ]);
      };

    };
    systemd.services.tailscale-web = lib.mkIf cfg.webClient.enable {
      description = "Tailscale Web Client";
      after = [ "tailscaled.service" ];
      wants = [ "tailscaled.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = ''
          ${pkgs.tailscale}/bin/tailscale web --listen ${cfg.webClient.listenAddr}:${toString cfg.webClient.port} --readonly=false
        '';
        Restart = "on-failure";
        # Running as root is necessary to bind to privileged ports (<1024)
        # and to have the necessary permissions to interact with tailscaled.
        User = "root";
        Group = "root";
      };
    };
  };
}
