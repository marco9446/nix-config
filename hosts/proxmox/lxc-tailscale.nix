{ ... }: {

  imports = [
    ../../modules/defaultPveLxcConfig.nix
    ../../modules/nixOS/tailscale.nix
  ];

  modules = {
    tailscale = {
      enable = true;
      isExitNode = true;
      advertiseRoutes = [ "192.168.188.0/24" ];
    };
  };
}
