{config, pkgs, lib, ...}:
let
        cfg = config.nvim-nix;
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

        options.nvim-nix = {
                enable = lib.mkEnableOption "Enable the nvim-nix module";
        };

        config.vim = {

        };
}
