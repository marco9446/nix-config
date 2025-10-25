{ ... }:

{
  imports = [
    ../../modules/defaultProxmoxConfig.nix
  ];

  modules = {
    adguard.enable = true;
    tailscale.enable = true;
  };
}
