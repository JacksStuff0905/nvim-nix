{config, pkgs, lib, ...}:
let
        cfg = config.nvim-nix;
in
{
        config.nvim-nix = lib.mkIf (cfg.profile == "full") {
                plugins = {
                        colorizer.enable = lib.mkDefault true;
                        git.enable = lib.mkDefault true;
                        rename.enable = lib.mkDefault true;
                };
        };
}
