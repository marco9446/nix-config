{
  description = "My nixOs configuration";

  inputs = {
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, ... }@inputs: {
    nixosConfigurations =
      let
        hostNames = [ "acer-aspire" "lenovo-x1" "wsl" ];
      in
      builtins.listToAttrs (map
        (host: {
          name = host;
          value = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules = [ ./hosts/${host}/configuration.nix ];
          };
        })
        hostNames);
  };
}
