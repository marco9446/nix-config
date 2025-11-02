# Copilot Instructions for nix-config

## Project Overview
This repository manages NixOS configurations using flakes, supporting multiple hosts and modular setups. The main entry point is `flake.nix`, which orchestrates host-specific and shared modules.

## Architecture & Structure
- **flake.nix**: Defines inputs, outputs, and generates `nixosConfigurations` for each host in `hosts/`.
- **hosts/**: Contains per-host configuration directories (e.g., `acer-aspire/`, `lenovo-x1/`, etc.), each with:
  - `configuration.nix`: Main system config for the host
  - `hardware-configuration.nix`: Hardware-specific settings
  - `home.nix`: Home-manager config (if present)
- **modules/**: Shared NixOS and Home Manager modules, organized by feature (e.g., `nixOS/`, `homeManager/`).

## Key Workflows
- **Format all Nix files**: `nix fmt` or use the provided formatter in `flake.nix`.
- **Development shell**: `nix develop` for a shell with essential tools (`git`, `nixpkgs-fmt`, `nil`).
- **Check formatting**: `nix flake check` runs a formatting check on all `.nix` files.
- **Deploy to host**: Use `nixos-rebuild --flake .#<host> --target-host user@remote-host --sudo --ask-sudo-password switch`.
- **Proxmox VM image generation**: Use `nixos-generate -f proxmox --flake .#<host>` (see README for details).

## Conventions & Patterns
- **Host names**: Defined in `flake.nix` as `hostNames`, must match directory names in `hosts/`.
- **Modularization**: Features and packages are split into reusable modules under `modules/`.
- **Special arguments**: `nixosConfigurations` passes `inputs`, `host`, and `username` to modules for customization.
- **Home Manager**: Integrated via flake input and modules, configured per-host in `home.nix` and `modules/homeManager/`.

## External Integrations
- **nixos-generators**: Used for Proxmox VM image creation.
- **Home Manager**: Managed as a flake input and used for user-level configuration.
- **NixOS Hardware**: Hardware profiles included via flake input.

## Examples
- Add a new host: Create a directory in `hosts/`, add `configuration.nix` and (optionally) `hardware-configuration.nix`/`home.nix`, then add the host name to `hostNames` in `flake.nix`.
- Add a new module: Place it in `modules/nixOS/` or `modules/homeManager/` and import it in the relevant host or shared config.

## References
- See `README.md` for deployment and VM generation instructions.
- Key files: `flake.nix`, `hosts/<host>/configuration.nix`, `modules/nixOS/`, `modules/homeManager/`.

---

**Feedback:** If any section is unclear or missing, please specify which workflows, conventions, or architectural details need further documentation.