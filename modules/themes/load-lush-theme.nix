{ pkgs, theme, path }:
let 
        load-theme = file: fallback:
                if (builtins.pathExists file) then
                        (builtins.readFile file)
                else
                        (builtins.readFile (builtins.trace path fallback));

        lush-theme =
                if (theme.style == "dark") then
                        load-theme (path + "/lua/dark-theme.lua") (path + "/lua/lush-theme.lua")
                else
                        load-theme (path + "/lua/light-theme.lua") (path + "/lua/lush-theme.lua");
in
{
        lush-nvim = {
                package = pkgs.vimPlugins.lush-nvim;

                setup = ''
                        ${lush-theme}
                '';
        };
}
