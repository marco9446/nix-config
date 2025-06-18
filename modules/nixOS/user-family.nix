{ pkgs, config, lib, ... }:

{
  options = {
    modules.user-family.enable = lib.mkEnableOption "enable second user module";
  };

  config = lib.mkIf config.modules.user-family.enable {
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.family = {
      isNormalUser = true;
      description = "family user";
      extraGroups = [ "networkmanager" ];
      initialHashedPassword = "$y$j9T$956hRZWWHGyKmwJ9T5KmG1$Q5TT.3vdlpqZy5/aLtjDggEXjya9RK0qp8zP.lVH3d7";
      shell = pkgs.bash;
    };
  };
}
