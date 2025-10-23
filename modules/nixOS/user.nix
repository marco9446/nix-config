{ pkgs, username, config, lib, ... }:

{
  options = {
    modules.user.enable = lib.mkEnableOption "enable user module";
  };

  config = lib.mkIf config.modules.user.enable {
    # Allow user to change their own passwords
    users.mutableUsers = true;

    users.users.${username} = {
      isNormalUser = true;
      extraGroups = [ "networkmanager" "wheel" ];
      shell = config.modules.customConfig.userShell;
      initialPassword = "changeMe";

      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICVkOxsmgT2thGbGjDeqL8Bp/wxnxu1OQlqcFXLZ81h1 lenovo-x1"
      ];
    };
  };
}
