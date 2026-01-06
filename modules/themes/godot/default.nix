{config, lib, pkgs, ...}:
let 
        name = "godot";

        theme = import ../get-theme.nix config;
        cfg = config.programs.nvim-nix.themes;

        lush-theme = builtins.readFile ./lua/lush-theme.lua;
in
{
        config.vim = lib.mkIf (cfg.enable && theme.name == name) {
                theme = {
                        enable = false;
                };

                extraPlugins = with pkgs.vimPlugins; {
                        lush-nvim = {
                                package = lush-nvim;

                                setup = ''
                                        ${lush-theme}
                                '';
                        };
                };
        };
}
