{
  description = "Portable nvim/nvf configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nvf.url = "github:notashelf/nvf";

    dirtytalk-src = {
      url = "github:psliwka/vim-dirtytalk";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nvf,
      ...
    }@inputs:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {

      # Standalone
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          neovim-configuration = {
            inherit pkgs;

            extraSpecialArgs = {
              dirtytalkSrc = inputs.dirtytalk-src;
            };

            modules = [
              ./configuration.nix
              { programs.nvim-nix.enable = true; }
            ];
          };

          caskaydiaFont = pkgs.nerd-fonts.caskaydia-cove;

          makeNeovim =
            profile:
            pkgs.symlinkJoin {
              name = "nvim";
              nativeBuildInputs = [ pkgs.makeWrapper ];
              paths = [
                (nvf.lib.neovimConfiguration (
                  neovim-configuration
                  // {
                    modules = neovim-configuration.modules ++ [
                      # Modules to be appended
                      (
                        { ... }:
                        {
                          programs.nvim-nix.profile = profile;
                        }
                      )
                    ];
                  }
                )).neovim
              ];

              postBuild = ''
                wrapProgram $out/bin/nvim \
                --set FONTCONFIG_FILE ${pkgs.writeText "fonts.conf" ''
                  <?xml version="1.0"?>
                  <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
                  <fontconfig>
                    <dir>${caskaydiaFont}/share/fonts</dir>
                    <cachedir>/tmp/fontconfig-cache</cachedir>
                  </fontconfig>
                ''}
              '';
            };
        in
        {
          default = (nvf.lib.neovimConfiguration (neovim-configuration)).neovim;

          # Basic profile - run with #basic
          basic = makeNeovim "basic";

          # Full profile - run with #full
          full = makeNeovim "full";

          # DevBox profile - run with #devbox
          devbox = makeNeovim "devbox";
        }
      );

      # NixOS
      nixosModules.default =
        {
          config,
          pkgs,
          lib,
          ...
        }:
        {
          imports = [
            nvf.nixosModules.default
            ./configuration.nix
          ];

          # Fix for the scope issues - a dummy option acting as a sink
          options.vim = lib.mkOption {
            type = lib.types.attrsOf lib.types.anything;
            default = { };
            visible = false;
            internal = true;
          };

          config = lib.mkIf config.programs.nvim-nix.enable {
            _module.args = {
              dirtytalkSrc = inputs.dirtytalk-src;
            };

            programs.nvf = {
              enable = true;
              settings = {
                imports = [
                  ./configuration.nix
                ];

                _module.args = {
                  dirtytalkSrc = inputs.dirtytalk-src;
                };

                programs.nvim-nix = config.programs.nvim-nix;
              };
            };

            # Set shell aliases
            environment.shellAliases = lib.mkMerge (
              builtins.map (alias: {
                "${alias}" = lib.getExe config.programs.nvf.finalPackage;
              }) config.programs.nvim-nix.opts.aliases
            );
          };
        };

      # Home Manager
      homeManagerModules.default =
        {
          config,
          pkgs,
          lib,
          ...
        }:
        {
          imports = [
            nvf.homeManagerModules.default
            ./configuration.nix
          ];

          # Fix for the scope issues - a dummy option acting as a sink
          options.vim = lib.mkOption {
            type = lib.types.attrsOf lib.types.anything;
            default = { };
            visible = false;
            internal = true;
          };

          config = lib.mkIf config.programs.nvim-nix.enable {
            _module.args = {
              dirtytalkSrc = inputs.dirtytalk-src;
            };

            programs.nvf = {
              enable = true;
              settings = {
                imports = [
                  ./configuration.nix
                ];

                _module.args = {
                  dirtytalkSrc = inputs.dirtytalk-src;
                };

                programs.nvim-nix = config.programs.nvim-nix;
              };
            };

            # Set shell aliases
            home.shellAliases = lib.mkMerge (
              builtins.map (alias: {
                "${alias}" = lib.getExe config.programs.nvf.finalPackage;
              }) config.programs.nvim-nix.opts.aliases
            );
          };
        };
    };
}
