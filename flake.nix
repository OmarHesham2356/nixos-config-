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

    pi-mono = {
      url = "github:lukasl-dev/pi-mono.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
outputs =
  {
    self,
    nixpkgs,
    home-manager,
    LazyVim,
    pi-mono,
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
      specialArgs = {
        inherit inputs pi-mono;
      };
      modules = [
        ./hosts/nixos/configuration.nix
      ];
    };
  };
}
