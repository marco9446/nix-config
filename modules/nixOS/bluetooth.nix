{ config, lib, ... }: {

  options = {
    modules.bluetooth.withBlueman = lib.mkOption {
      default = true;
      type = lib.types.bool;
    };
    modules.bluetooth.enable = lib.mkEnableOption "enable bluetooth module";
  };

  config = lib.mkIf config.modules.bluetooth.enable {
    # Blueman is the GUI app to manage bluetooth, make sure is not already installe in the desktop manager to avoid duplicates
    services.blueman.enable = config.modules.bluetooth.withBlueman;
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true; # powers up the default Bluetooth controller on boot
    };
  };
}
