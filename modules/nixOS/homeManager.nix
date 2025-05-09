{ config, lib, inputs, host, username, pkgs-stable, ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  options = {

    modules.homeManager.enable = lib.mkEnableOption "enable home manager module";
    modules.homeManager.path = lib.mkOption {
      type = lib.types.path;
    };
  };

  config = lib.mkIf config.modules.homeManager.enable {

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {
        inherit inputs host username pkgs-stable;
        nixOsConfig = config;
      };
      users.${username} = import config.modules.homeManager.path;
    };
  };
}
