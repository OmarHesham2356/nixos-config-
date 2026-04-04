{
  description = "A very basic flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    
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
    
    # Niri from nixpkgs (niri-flake removed due to build issues)
  };
  outputs =
    { self, nixpkgs, home-manager, dms }:
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          # Pass flake inputs to the NixOS configuration
          inherit dms;
        };
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
        ];
      };
    };
}
