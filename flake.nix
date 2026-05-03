{
  description = "Hyprland on Nixos";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Catppuccin theming
    catppuccin.url = "github:catppuccin/nix";

    # Neovim configuration framework
    nvf.url = "github:notashelf/nvf";

    # Firefox addons via NUR (rycee's repo). Provides extensions as
    # Nix packages so they can be installed declaratively.
    # See: https://nur.nix-community.org/repos/rycee/
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nvf,
      catppuccin,
      firefox-addons,
      ...
    }@inputs:
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nvf.nixosModules.default
          catppuccin.nixosModules.catppuccin
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              # Pass all flake inputs (including firefox-addons) to home modules
              extraSpecialArgs = { inherit inputs; };
              users.skydive420dz = {
                imports = [
                  ./home.nix
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
