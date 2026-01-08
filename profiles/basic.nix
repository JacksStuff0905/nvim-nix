{config, pkgs, lib, ...}:
let
        cfg = config.nvim-nix;
in
{
        config.nvim-nix = lib.mkIf (cfg.profile == "basic") {
                plugins = {
                        colorizer.enable = lib.mkDefault false;
                        git.enable = lib.mkDefault false;
                        rename.enable = lib.mkDefault false;
                };
        };
}
