{config, lib, pkgs, ...}:
let 
        name = "godot";

        theme = import ../get-theme.nix config;
        cfg = config.programs.nvim-nix.themes;

        load-theme = file: fallback:
                if (builtins.pathExists file) then
                        (builtins.readFile file)
                else
                        (builtins.readFile fallback);

        lush-theme =
                if (theme.style == "dark") then
                        load-theme ./lua/dark-theme.lua ./lua/lush-theme.lua
                else
                        load-theme ./lua/light-theme.lua ./lua/lush-theme.lua;
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
