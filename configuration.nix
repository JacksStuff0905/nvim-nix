{config, pkgs, lib, ...}:
let
        cfg = config.programs.nvim-nix;
in
{
        imports = [
                ./profiles
                ./modules/languages
                ./modules/plugins
                ./modules/opts
                ./modules/keymaps
                ./modules/themes
        ];

        options.programs.nvim-nix = {
                test = lib.mkEnableOption "";
                enable = lib.mkEnableOption "Enable the nvim-nix module";
        };

        config.vim = {
                theme = {
                        enable = true;
                        name = "dracula";
                        style = "dark";
                };

        };
}
