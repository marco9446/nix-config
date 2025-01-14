{ config, lib, ... }: {

  options = {
    bluetooth_withBlueman = lib.mkOption {
      default = true;
      type = lib.types.bool;
    };

  };

  config = {

    services.blueman.enable = config.bluetooth_withBlueman;
    hardware.bluetooth = {
      enable = true; # enables support for Bluetooth
      powerOnBoot = true; # powers up the default Bluetooth controller on boot
    };
  };
}
