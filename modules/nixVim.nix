{ lib, config, inputs, ... }:

{
  imports = [
    inputs.nixvim.nixosModules.nixvim
  ];
  options = {
    nixVimModule.enable = lib.mkEnableOption "enable nixVim";
  };
  config = lib.mkIf config.nixVimModule.enable {

    programs.nixvim = {
      enable = true;

      colorschemes.catppuccin.enable = true;
      plugins.lualine.enable = true;
      opts = {
        number = true; # Show line numbers
        relativenumber = true; # Show relative line numbers

        shiftwidth = 2; # Tab width should be 2
      };
    };
  };
}
