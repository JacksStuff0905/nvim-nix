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


      util = {
              get-import-dir = dir: ignore: import ./util/get-import-dir.nix {lib = nixpkgs.lib; inherit dir; inherit ignore;};
      };
    in {
    
      # Standalone
      packages = forAllSystems (system: let
        pkgs = nixpkgs.legacyPackages.${system};
        neovim-configuration = {
          inherit pkgs;
          
          extraSpecialArgs = {
                inherit util;
          };
          
          modules = [ 
                ./configuration.nix
                {programs.nvim-nix.enable = true;}
          ];
        };
      in {
        default = (nvf.lib.neovimConfiguration (neovim-configuration)).neovim;

        # Basic profile - run with #basic
        basic = (nvf.lib.neovimConfiguration (neovim-configuration
                // {modules = neovim-configuration.modules ++ [
                    # Modules to be appended
                    ({ ... }: { programs.nvim-nix.profile = "basic"; }) 
                ];}
        )).neovim;

        # Full profile - run with #full
        full = (nvf.lib.neovimConfiguration (neovim-configuration
                // {modules = neovim-configuration.modules ++ [
                    # Modules to be appended
                    ({ ... }: { programs.nvim-nix.profile = "full"; }) 
                ];}
        )).neovim;
      });

      # NixOS
      nixosModules.default = { config, pkgs, ... }: {
        imports = [ 
                nvf.nixosModules.default
                ./configuration.nix
        ];

        # Fix for the scope issues - an dummy option acting as a sink
        options.vim = lib.mkOption {
          type = lib.types.attrsOf lib.types.anything;
          default = {};
          visible = false;
          internal = true;
        };

        programs.nvf = {
                enable = true;
                settings = {
                        imports = [./configuration.nix];

                        _module.args = {
                                inherit util;
                        };

                        programs.nvim-nix = config.programs.nvim-nix;
                };
        };
      };
      
      # Home Manager
      homeManagerModules.default = { config, pkgs, ... }: {
                imports = [ 
                        nvf.homeManagerModules.default
                ];
                programs.nvf = {
                        enable = true;
                        settings = {
                                imports = [./configuration.nix];
                                _module.args = {
                                        inherit util;
                                };
                        };
                };
        };
    };
}
