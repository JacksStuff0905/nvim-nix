config:
let
        cfg = config.programs.nvim-nix.themes;
in
if (cfg.override.enable) then cfg.override.theme else cfg.theme
