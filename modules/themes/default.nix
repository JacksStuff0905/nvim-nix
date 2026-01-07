{config, lib, pkgs, ...}:
let
        cfg = config.programs.nvim-nix.themes;

        custom-themes = builtins.attrNames (builtins.readDir ./available-themes);

        theme = import ./get-theme.nix config;

        load-lush-theme = path: import ./load-lush-theme.nix {
                inherit pkgs;
                inherit theme;
                inherit path;
        };
        
in
{
        options.programs.nvim-nix.themes = {
                enable = lib.mkEnableOption "Enable theme managment module";

                
                # This value will be automatically set if using either the HM or NixOS module
                theme = {
                        name = lib.mkOption {
                                type = lib.types.str;
                                default = "godot";
                        };
                        style = lib.mkOption {
                                type = lib.types.enum ["light" "dark"];
                                default = "dark";
                        };
                        path = lib.mkOption {
                                type = lib.types.nullOr lib.types.path;
                                default = null;
                        };
                };
        };


        config.vim = lib.mkIf (cfg.enable) (
                if (theme.path != null) then
                {
                        theme = {
                                enable = false;
                        };

                        extraPlugins = load-lush-theme (theme.path);
                }
                else if (builtins.elem theme.name custom-themes) then
                {
                        theme = {
                                enable = false;
                        };

                        extraPlugins = load-lush-theme (./available-themes + ("/" + theme.name));
                }
                else
                {
                        # The theme should be considered a builtin theme 
                        theme = {
                                enable = true;
                                name = theme.name;
                                style = theme.style;
                        };
                }
        );
}
