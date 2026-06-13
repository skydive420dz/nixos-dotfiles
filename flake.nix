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

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
      lanzaboote,
      ...
    }@inputs:
    let
      username = "skydive420dz";
      system = "x86_64-linux";
      homeDirectory = "/home/${username}";
      repoPath = "${homeDirectory}/Projects/nixos-dotfiles";

      mkNixos =
        {
          hostname,
          hostPath,
          gpuProfile,
        }:
        let
          specialArgs = {
            inherit
              inputs
              username
              hostname
              homeDirectory
              repoPath
              gpuProfile
              ;
          };
        in
        nixpkgs.lib.nixosSystem {
          inherit system specialArgs;

          modules = [
            nvf.nixosModules.default
            lanzaboote.nixosModules.lanzaboote
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = specialArgs;
                backupFileExtension = "backup";

                users.${username}.imports = [
                  ./home
                ];
              };
            }
            hostPath
          ];
        };
    in
    {
      nixosConfigurations = {
        # Keep the existing flake target and host name for the MSI laptop.
        nixos = mkNixos {
          hostname = "nixos";
          hostPath = ./hosts/msi;
          gpuProfile = "nvidia-hybrid";
        };

        desktop-amd = mkNixos {
          hostname = "desktop-amd";
          hostPath = ./hosts/desktop-amd;
          gpuProfile = "amd-rdna4";
        };
      };
    };
}
