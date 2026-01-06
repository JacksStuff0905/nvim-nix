{config, lib, pkgs, ...}:
let
        cfg = config.programs.nvim-nix.themes;

        custom-themes = [
                "godot"
        ];

        theme = import ./get-theme.nix config;
in
{
        imports = builtins.map (name: ./. + ("/" + name)) custom-themes;

        options.programs.nvim-nix.themes = {
                enable = lib.mkEnableOption "Enable theme managment module";

                
                # This value will be automatically set if using either the HM or NixOS module
                theme = {
                        name = lib.mkOption {
                                type = lib.types.str;
                                default = "dracula";
                        };
                        style = lib.mkOption {
                                type = lib.types.enum ["light" "dark"];
                                default = "dark";
                        };
                };
                
                override = {
                        enable = lib.mkEnableOption "Enable the theme override" ;
                        theme = {
                                name = lib.mkOption {
                                        type = lib.types.str;
                                        description = "The theme that should be used instead of the system theme";
                                };
                                style = lib.mkOption {
                                        type = lib.types.enum ["light" "dark"];
                                        default = "dark";
                                };
                        };
                };
        };


        config.vim = lib.mkIf (cfg.enable && !(builtins.elem theme.name custom-themes)) {
                # The theme should be considered a builtin theme 
                theme = {
                        enable = true;
                        name = theme.name;
                        style = theme.style;
                };
        };
}
