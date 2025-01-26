{ lib, config, ... }: {

  options = {
    cosmicDesktopModule.enable = lib.mkEnableOption "enable cosmic desktop";
  };
  config = lib.mkIf config.cosmicDesktopModule.enable {

    services.desktopManager.cosmic.enable = true;
    services.displayManager.cosmic-greeter.enable = true;
    environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = 1;

    bluetoohModule.withBlueman = false;
  };
}
