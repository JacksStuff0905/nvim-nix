{config, pkgs, lib, ...}:
let
        cfg = config.programs.nvim-nix;
in
{
        config.programs.nvim-nix = lib.mkIf (cfg.profile == "basic") {
                opts.enable = true;
        };
}
