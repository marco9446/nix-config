{ ... }:

{
  imports = [
    ../../modules/defaultProxmoxConfig.nix
  ];

  modules = {
    adguard.enable = true;
    tailscale = {
      enable = true;
      isExitNode = true;
      advertiseRoutes = [ "192.168.188.0/24" ];
    };
  };
}
