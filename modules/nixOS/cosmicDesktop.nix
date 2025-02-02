{ lib, config, inputs, ... }: {

  imports = [
    {
      nix.settings = {
        substituters = [ "https://cosmic.cachix.org/" ];
        trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
      };
    }
    inputs.nixos-cosmic.nixosModules.default
  ];

  options = {
    modules.cosmicDesktop.enable = lib.mkEnableOption "enable cosmic desktop";
  };

  config = lib.mkIf config.modules.cosmicDesktop.enable {
    services.desktopManager.cosmic.enable = true;
    services.displayManager.cosmic-greeter.enable = true;
    environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = 1;
    modules.bluetooth.withBlueman = false;
  };
}
