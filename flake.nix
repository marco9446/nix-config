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
      # Discover host names of all non-proxmox hosts
      hostNames = builtins.filter
        (
          name: (builtins.readDir ./hosts).${name} == "directory" && name != "proxmox"
        )
        (builtins.attrNames (builtins.readDir ./hosts));
      # Discover proxmox configs
      proxmoxConfigs = builtins.map
        (name: builtins.replaceStrings [ ".nix" ] [ "" ] name)
        (builtins.filter
          (name: (builtins.readDir ./hosts/proxmox).${name} == "regular")
          (builtins.attrNames (builtins.readDir ./hosts/proxmox)));
      username = "marco";
      pkgsFor = system: import nixpkgs { inherit system; };
      proxmoxInfo = {
        "lxc-adguard" = { user = "root"; ip = "192.168.188.31"; };
        "lxc-tailscale" = { user = "root"; ip = "192.168.188.32"; };
      };
    in
    {
      # use it with nix run .#deploy-<host>
      apps = forAllSystems (system:
        let
          pkgs = pkgsFor system;
        in
        nixpkgs.lib.genAttrs (builtins.attrNames proxmoxInfo) (host:
          let
            deployInfo = proxmoxInfo.${host};
            target = "${deployInfo.user}@${deployInfo.ip}";
          in
          {
            type = "app";
            program = toString (pkgs.writeShellScript "deploy-${host}" ''
              boldBlue="\e[1;34m"
              reset="\e[0m"
              echo -e "🚀 Deploying ''${boldBlue}${host}''${reset} to ''${boldBlue}${target}''${reset}..."
              nixos-rebuild switch --flake .#${host} --target-host ${target}
              echo -e "✅ Deployment of ''${boldBlue}${host}''${reset} finished."
            '');
          }));
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
            packages = with pkgs; [
              git
              nixpkgs-fmt
              nil
              nixos-generators
            ];
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
        nixpkgs.lib.genAttrs hostNames
          (host:
            let
              system = "x86_64-linux";
            in
            nixpkgs.lib.nixosSystem {
              inherit system;
              specialArgs = {
                inherit inputs host username;
              };
              modules = [ ./hosts/${host}/configuration.nix ];
            }) //
        # Add proxmox VMs and LXCs as additional configurations
        nixpkgs.lib.genAttrs proxmoxConfigs (host:
          let
            system = "x86_64-linux";
          in
          nixpkgs.lib.nixosSystem {
            inherit system;
            specialArgs = {
              inherit inputs host username proxmoxInfo;
            };
            modules = [ ./hosts/proxmox/${host}.nix ];
          });
    };
}
