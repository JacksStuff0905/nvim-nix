{config, lib, ...}:
let 
        theme = import ./get-theme.nix config;
        cfg = config.programs.nvim-nix.themes;
in
{
        config.vim = lib.mkIf (cfg.enable && theme.name == "godot") {
                
        };
}
