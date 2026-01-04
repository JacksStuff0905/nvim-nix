{config, pkgs, lib, ...}:
let
        cfg = config.programs.nvim-nix;
in
{
        config.programs.nvim-nix = lib.mkIf (cfg.profile == "full") {
                plugins = {
                        colorizer.enable = lib.mkDefault true;
                };
        };
}
