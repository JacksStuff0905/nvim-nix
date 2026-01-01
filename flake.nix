{
  description = "Portable nvim/nvf configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nvf.url = "github:notashelf/nvf";
  };

  outputs = { self, nixpkgs, nvf, ... }: 
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in {
    
      # Standalone
      packages = forAllSystems (system: let
        pkgs = nixpkgs.legacyPackages.${system};
        
        # Build neovim with nvf
        configured-neovim = nvf.lib.neovimConfiguration {
          inherit pkgs;
          modules = [ ./configuration.nix ];
        };
      in {
        default = configured-neovim.neovim;
      });

      # NixOS
      nixosModules.default = { config, pkgs, ... }: {
        imports = [ nvf.nixosModules.default ];

        programs.nvf = {
          enable = true;

          settings = ./configuration.nix;
        };
      };
      
      # Home Manager
      homeManagerModules.default = { config, pkgs, ... }: {
        imports = [ nvf.homeManagerModules.default ];

        programs.nvf = {
          enable = true;

          settings = ./configuration.nix;
        };
      };
    };
}
