{
  description = "My nixOs configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs@{ nixpkgs, ... }:
    let
      systems = [ "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      hostNames = [ "acer-aspire" "lenovo-x1" "wsl" "macbook" "pve-nixos-lab" "pve-nixos-net" ];
      username = "marco";
      pkgsFor = system: import nixpkgs { inherit system; };
    in
    {
      # use it with nix fmt
      formatter = forAllSystems (system:
        let pkgs = pkgsFor system;
        in pkgs.writeShellScriptBin "format-nix" ''
          find . -name '*.nix' -print0 | xargs -0 ${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt
        '');
      # use it with nix develop
      devShells = forAllSystems (system:
        let pkgs = pkgsFor system;
        in {
          default = pkgs.mkShell {
            packages = with pkgs; [ git nixpkgs-fmt nil ];
          };
        });
      # use it with nix flake check
      checks = forAllSystems (system:
        let pkgs = pkgsFor system;
        in {
          # Formats all *.nix files; fails if any need changes.
          formatting = pkgs.stdenv.mkDerivation {
            name = "fmt-check";
            src = ./.;
            nativeBuildInputs = [ pkgs.nixpkgs-fmt ];
            phases = [ "buildPhase" ];
            buildPhase = ''
              # List all nix files and check formatting
              find "$src" -name '*.nix' -print0 | xargs -0 nixpkgs-fmt --check
              touch "$out"
            '';
          };
        });

      nixosConfigurations =
        nixpkgs.lib.genAttrs hostNames (host:
          let
            system = "x86_64-linux";
          in
          nixpkgs.lib.nixosSystem {
            inherit system;
            specialArgs = {
              inherit inputs host username;
            };
            modules = [ ./hosts/${host}/configuration.nix ];
          });
    };
}
