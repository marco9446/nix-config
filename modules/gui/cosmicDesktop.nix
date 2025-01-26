{ lib, config, ... }: {

  options = {
    modules.cosmicDesktop.enable = lib.mkEnableOption "enable cosmic desktop";
  };
  config = lib.mkIf config.modules.cosmicDesktop.enable {

    services.desktopManager.cosmic.enable = true;
    services.displayManager.cosmic-greeter.enable = true;
    environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = 1;

    modules.bluetooh.withBlueman = false;
  };
}
