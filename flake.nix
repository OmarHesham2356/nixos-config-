{
  description = "NixOS flake configuration with Niri, Home Manager, and DankMaterialShell";
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

    # DankMaterialShell - the shell/overlay
    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
outputs =
  {
    self,
    nixpkgs,
    home-manager,
    dms,
    LazyVim,
  }@inputs:
  {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs dms;
      };
      modules = [
        ./hosts/nixos/configuration.nix
      ];
    };
    
    homeConfigurations."omarnix@nixos" = home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
      modules = [
        ./modules/users/omarnix/home-manager.nix
      ];
      extraSpecialArgs = { inherit inputs dms; };
    };
  };
}
