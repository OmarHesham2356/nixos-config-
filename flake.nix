{
  description = "NixOS flake configuration with Hyprland, Home Manager, and Pywal";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    # LazyVim (Neovim distribution) via LazyVim-module
    LazyVim = {
      url = "github:matadaniel/LazyVim-module";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home-manager for user-level configuration
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };


    prismlauncher-cracked = {
      url = "github:Diegiwg/PrismLauncher-Cracked";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    windscribe-nixos = {
      url = "github:Varmisanth/windscribe-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      LazyVim,
      prismlauncher-cracked,
      noctalia,
      windscribe-nixos,
    }@inputs:
  let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
  in
  {
    devShells.x86_64-linux.default = pkgs.mkShell {
      buildInputs = with pkgs; [
        docker-client
        docker-compose
      ];
      shellHook = ''
        export DOCKER_HOST="unix:///run/user/$UID/podman/podman.sock"
        if ! systemctl --user is-active --quiet podman.socket 2>/dev/null; then
          systemctl --user start podman.socket 2>/dev/null || echo "Run 'systemctl --user enable --now podman.socket' once for auto-start"
        fi
      '';
    };

    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs; };
        
      
      modules = [
        ./hosts/nixos/configuration.nix
        windscribe-nixos.nixosModules.windscribe
        # PrismLauncher-Cracked overlay + fix for removed KDE5 extra-cmake-modules alias
        {
          nixpkgs.overlays = [
            (final: prev: {
              extra-cmake-modules = prev.kdePackages.extra-cmake-modules;
            })
            prismlauncher-cracked.overlays.default
            (final: prev: {
              prismlauncher-unwrapped = prev.prismlauncher-unwrapped.overrideAttrs (old: {
                nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ prev.pkg-config ];
              });
            })
          ];
        }
      ];
    };
  };
}
