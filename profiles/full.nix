{config, pkgs, lib, ...}:
let
        cfg = config.programs.nvim-nix;
in
{
        config.programs.nvim-nix = lib.mkIf (cfg.profile == "full") {
                plugins = {
                        colorizer.enable = lib.mkDefault true;
                        git.enable = lib.mkDefault true;
                        rename.enable = lib.mkDefault true;
                };

                languages = {
                        enable = lib.mkDefault true;
                };
        };
}
