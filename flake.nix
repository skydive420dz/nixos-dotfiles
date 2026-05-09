{
  description = "Hyprland on Nixos";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Upstream Hyprland
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Upstream Quickshell
    quickshell = {
      # add ?ref=<tag> to track a tag
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";

      # THIS IS IMPORTANT
      # Mismatched system dependencies will lead to crashes and other issues.
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
      hyprland,
      nvf,
      catppuccin,
      firefox-addons,
      quickshell,
      ...
    }@inputs:
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        modules = [
          { nixpkgs.hostPlatform = "x86_64-linux"; }
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
