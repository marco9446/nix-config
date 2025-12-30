{ lib, config, pkgs, ... }: {

  # imports = [
  #   {
  #     nix.settings = {
  #       substituters = [ "https://cosmic.cachix.org/" ];
  #       trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
  #     };
  #   }
  #   inputs.nixos-cosmic.nixosModules.default
  # ];

  options = {
    modules.cosmicDesktop.enable = lib.mkEnableOption "enable cosmic desktop";
  };

  config = lib.mkIf config.modules.cosmicDesktop.enable {
    # disable title bar in cosmic-comp(requires too much time to compile, leave it commented for now)
    # nixpkgs.overlays = lib.mkAfter [
    #   (_final: prev: {
    #     cosmic-comp = prev.cosmic-comp.overrideAttrs (old: {
    #       patches = (old.patches or [ ]) ++ [
    #         (prev.fetchpatch {
    #           url = "https://raw.githubusercontent.com/cramt/nixconf/main/patches/no_ssd.patch";
    #           hash = "sha256-eqjGcGspSpG3X++X8+LFOCksjhathHw7fjnr4IOCvmM=";
    #         })
    #       ];
    #     });
    #   })
    # ];

    # Enable the COSMIC login manager
    services.displayManager.cosmic-greeter.enable = true;

    # Enable the COSMIC desktop environment
    services.desktopManager.cosmic.enable = true;

    environment.cosmic.excludePackages = with pkgs; [
      cosmic-edit
    ];

    # improve performance
    services.system76-scheduler.enable = true;

    # Allow all windows to have access to clipboard
    environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = 1;
    # Disable blueman to avoid duplicates with gnome bluetooth manager
    modules.bluetooth.withBlueman = false;
  };
}
