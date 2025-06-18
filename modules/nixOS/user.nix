{ pkgs, username, config, lib, ... }:

{
  options = {
    modules.user.enable = lib.mkEnableOption "enable user module";
  };

  config = lib.mkIf config.modules.user.enable {
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.${username} = {
      isNormalUser = true;
      extraGroups = [ "networkmanager" "wheel" ];
      shell = pkgs.zsh;
    };
  };
}
