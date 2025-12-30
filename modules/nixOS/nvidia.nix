{
  config,
  lib,
  host,
  ...
}:
{

  options = {
    modules.nvidia.enable = lib.mkEnableOption "enable nvidia";
  };
  config = lib.mkIf config.modules.nvidia.enable {

    # Enable OpenGL
    hardware.graphics.enable = true;
    services.xserver.videoDrivers = if (host == "macbook") then [ "intel" ] else [ "nvidia" ];

    nixpkgs.config.nvidia.acceptLicense = true;

    hardware.nvidia = {

      # Modesetting is required.
      modesetting.enable = host != "macbook";

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      # Enable this if you have graphical corruption issues or application crashes after waking
      # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
      # of just the bare essentials.
      powerManagement.enable = false;

      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      powerManagement.finegrained = host != "macbook";

      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures. Full list of
      # supported GPUs is at:
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
      # Only available from driver 515.43.04+
      # Currently alpha-quality/buggy, so false is currently the recommended setting.
      open = false;

      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      nvidiaSettings = true;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package =
        if host == "macbook" then
          config.boot.kernelPackages.nvidiaPackages.legacy_470
        else
          config.boot.kernelPackages.nvidiaPackages.stable;

      prime = {
        # Make sure to use the correct Bus ID values for your system!
        intelBusId = if host == "macbook" then "PCI:0:2:0" else "PCI:2@0:0:0";
        nvidiaBusId = if host == "macbook" then "PCI:1:0:0" else "PCI:1@0:0:0";
        offload = {
          enable = true;
          enableOffloadCmd = true; # Provides `nvidia-offload` command.
        };
      };
    };

    boot.kernelParams = lib.mkIf (host == "macbook") [
      "acpi_osi=Darwin"
    ];

    # Explicitly disable on Mac
    systemd.services.nvidia-powerd.enable = lib.mkIf (host == "mackbook") false;
    systemd.services.nvidia-persistenced.enable = lib.mkIf (host == "mackbook") false;
    systemd.services.nvidia-suspend.enable = lib.mkIf (host == "mackbook") false;
    systemd.services.nvidia-resume.enable = lib.mkIf (host == "mackbook") false;
  };
}
