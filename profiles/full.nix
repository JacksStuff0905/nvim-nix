{config, pkgs, lib, ...}:
let
        cfg = config.programs.nvim-nix;
in
{
        config.programs.nvim-nix = lib.mkIf (cfg.enable && cfg.profile == "full") {
                plugins = {
                        colorizer.enable = lib.mkDefault true;
                        git.enable = lib.mkDefault true;
                };
        };
}
