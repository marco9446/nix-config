{ config, lib, ... }: {

  options = {
    modules.bluetooh.withBlueman = lib.mkOption {
      default = true;
      type = lib.types.bool;
    };
    modules.bluetooh.enable = lib.mkEnableOption "enable bluetooth module";
  };


  config = lib.mkIf config.modules.bluetooh.enable {
    # Blueman is the GUI app to manage bluetooh, make sure is not already installe in the desktop manager to avoid duplicates
    services.blueman.enable = config.modules.bluetooh.withBlueman;
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true; # powers up the default Bluetooth controller on boot
    };
  };
}
