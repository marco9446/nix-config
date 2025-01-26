{ config, lib, ... }: {

  options = {
    bluetoohModule.withBlueman = lib.mkOption {
      default = true;
      type = lib.types.bool;
    };
    bluetoohModule.enable = lib.mkEnableOption "enable bluetooth module";
  };


  config = lib.mkIf config.bluetoohModule.enable {
    # Blueman is the GUI app to manage bluetooh, make sure is not already installe in the desktop manager to avoid duplicates
    services.blueman.enable = config.bluetooth_withBlueman;
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true; # powers up the default Bluetooth controller on boot
    };
  };
}
