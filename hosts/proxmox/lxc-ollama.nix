{ pkgs, ... }: {

  imports = [
    ../../modules/defaultPveLxcConfig.nix
  ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
    ];
  };

  modules = { };

  services.ollama = {
    enable = true;
    # Optional: preload models, see https://ollama.com/library
    loadModels = [ ];
    acceleration = "rocm";
    rocmOverrideGfx = "11.0.0"; # Required for Radeon 890M (RDNA 3.5)
    openFirewall = true;
  };

  services.nextjs-ollama-llm-ui.enable = true;
}
