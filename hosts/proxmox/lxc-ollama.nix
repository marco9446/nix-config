{ pkgs, ... }: {
  # you need to passthrough the GPU devices to the LXC container in proxmox ui
  # /dev/dri/renderD128 and /dev/kfd

  imports = [
    ../../modules/defaultPveLxcConfig.nix
  ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
    ];
  };
  # Add ollama user to render/video groups for GPU access
  users.users.ollama = {
    extraGroups = [ "render" "video" ];
  };

  services.ollama = {
    enable = true;
    user = "ollama";
    # Optional: preload models, see https://ollama.com/library
    loadModels = [ ];
    acceleration = "rocm";
    # Radeon 890M is RDNA 3.5. 
    # If 11.0.0 is unstable, try "11.0.2"
    rocmOverrideGfx = "11.0.0";
    openFirewall = true;
  };

  services.nextjs-ollama-llm-ui.enable = true;
}
