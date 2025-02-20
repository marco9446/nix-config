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

  outputs = { nixpkgs, nixpkgs-stable, ... }@inputs: {
    nixosConfigurations =
      let
        hostNames = [ "acer-aspire" "lenovo-x1" "wsl"  "macbook"];
        username = "marco";
      in
      builtins.listToAttrs (map
        (host: {
          name = host;
          value = nixpkgs.lib.nixosSystem rec {
            system = "x86_64-linux";
            specialArgs = {
              inherit inputs host username; pkgs-stable = import nixpkgs-stable {
              inherit system;
              config.allowUnfree = true;
            };
            };
            modules = [ ./hosts/${host}/configuration.nix ];
          };
        })
        hostNames);
  };
}
