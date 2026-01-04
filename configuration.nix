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
        ];

        options.nvim-nix = {
        };

        config.vim = {
                theme = {
                        enable = true;
                        name = "dracula";
                        style = "dark";
                };

        };
}
