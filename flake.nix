{
  description = "Hyprland on Nixos";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # The official Catppuccin Nix module
    catppuccin.url = "github:catppuccin/nix";
    nvf.url = "github:notashelf/nvf";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nvf,
      catppuccin,
      ...
    }:
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nvf.nixosModules.default
          # Import the Catppuccin NixOS module if you want global SDDM/tty themes
          catppuccin.nixosModules.catppuccin
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              # This passes 'inputs' (including catppuccin) to home.nix
              extraSpecialArgs = { inherit (self) inputs; };
              users.skydive420dz = {
                imports = [
                  ./home.nix
                  # This enables catppuccin modules for your user
                  catppuccin.homeModules.catppuccin
                ];
              };
              backupFileExtension = "backup";
            };
          }
          ./configuration.nix
        ];
      };
    };
}
