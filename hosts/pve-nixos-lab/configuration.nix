{ ... }:

{
  imports = [
    ../../modules/defaultProxmoxConfig.nix
  ];

  modules = {
    docker.enable = true;
  };
}
