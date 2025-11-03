{ proxmoxInfo, ... }: {

  imports = [
    ../../modules/defaultPveLxcConfig.nix
    ../../modules/nixOS/tailscale.nix
  ];

  # Read this documentation for tailscale unprivileged LXC configuration:
  # https://tailscale.com/kb/1130/lxc-unprivileged

  modules = {
    tailscale = {
      enable = true;
      isExitNode = true;
      advertiseRoutes = [ "192.168.188.0/24" ];
      webClient = {
        enable = true;
        listenAddr = proxmoxInfo."lxc-tailscale".ip;
        port = 80;
      };
    };
  };
}
