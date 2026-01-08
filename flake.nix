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
        neovim-configuration = {
          inherit pkgs;
          
          modules = [ 
                ./configuration.nix
                {nvim-nix.enable = true;}
          ];
        };
      in {
        default = (nvf.lib.neovimConfiguration (neovim-configuration)).neovim;

        # Basic profile - run with #basic
        basic = (nvf.lib.neovimConfiguration (neovim-configuration
                // {modules = neovim-configuration.modules ++ [
                    # Modules to be appended
                    ({ ... }: { nvim-nix.profile = "basic"; }) 
                ];}
        )).neovim;

        # Full profile - run with #full
        full = (nvf.lib.neovimConfiguration (neovim-configuration
                // {modules = neovim-configuration.modules ++ [
                    # Modules to be appended
                    ({ ... }: { nvim-nix.profile = "full"; }) 
                ];}
        )).neovim;
      });

      # NixOS
      nixosModules.default = { config, pkgs, lib, ... }: {
        imports = [
                nvf.nixosModules.default
        ];

        config = lib.mkIf config.programs.nvf.settings.nvim-nix.enable {
                programs.nvf = {
                        enable = true;
                        settings = {
                                imports = [
                                        ./configuration.nix
                                ];
                        };
                };

                # Set shell aliases
                environment.shellAliases = lib.mkMerge (
                        builtins.map (alias: {"${alias}" = lib.getExe config.programs.nvf.finalPackage;}) config.programs.nvf.settings.nvim-nix.opts.aliases
                );
        };
      };
      
      # Home Manager
      homeManagerModules.default = { config, pkgs, lib, ... }: {
        imports = [
                nvf.homeManagerModules.default
        ];
        
        config = lib.mkIf config.programs.nvf.settings.nvim-nix.enable {
                programs.nvf = {
                        enable = true;
                        settings = {
                                imports = [
                                        ./configuration.nix
                                ];
                        };
                };

                # Set shell aliases
                home.shellAliases = lib.mkMerge (
                        builtins.map (alias: {"${alias}" = lib.getExe config.programs.nvf.finalPackage;}) config.programs.nvf.settings.nvim-nix.opts.aliases
                );
        };
      };
    };
}
