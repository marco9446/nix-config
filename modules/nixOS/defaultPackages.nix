{ lib, config, pkgs, ... }: {

  options = {
    modules.defaultPackages.enable = lib.mkEnableOption "enable default packages module";
  };

  config = lib.mkIf config.modules.defaultPackages.enable {
    # List packages installed in system profile.
    environment.systemPackages = with pkgs; [
      wget
      git
      htop
      lshw
      vlc
      sslscan
    ];
  };
}
