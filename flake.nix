{
  description = "Hyprland on Nixos";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";
    nvf.url = "github:notashelf/nvf";

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nvf,
      catppuccin,
      ...
    }@inputs:
    let
      username = "skydive420dz";
      hostname = "nixos";
      system = "x86_64-linux";
      homeDirectory = "/home/${username}";
      repoPath = "${homeDirectory}/nixos-dotfiles";

      specialArgs = {
        inherit
          inputs
          username
          hostname
          homeDirectory
          repoPath
          ;
      };

      mkNixosConfiguration =
        hardwareConfiguration:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = specialArgs // {
            inherit hardwareConfiguration;
          };

          modules = [
            nvf.nixosModules.default
            catppuccin.nixosModules.catppuccin
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = specialArgs;
                backupFileExtension = "backup";

                users.${username}.imports = [
                  ./home
                  catppuccin.homeModules.catppuccin
                ];
              };
            }
            ./hosts/nixos
          ];
        };
    in
    {
      nixosConfigurations.${hostname} =
        mkNixosConfiguration /etc/nixos/hardware-configuration.nix;

      nixosConfigurations.nixos-check =
        mkNixosConfiguration ./hosts/nixos/hardware-check.nix;
    };
}
