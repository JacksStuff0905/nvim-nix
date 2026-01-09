{config, lib, ...}:

let
        cfg = config.programs.nvim-nix.opts.undo;
in
{

        options.programs.nvim-nix.opts.undo = {
                enable = lib.mkOption {
                        type = lib.types.bool;
                        default = true;
                };

                persistent = {
                        enable = lib.mkOption {
                                type = lib.types.bool;
                                default = true;
                        };
                };
        };

        config.vim = lib.mkIf config.programs.nvim-nix.opts.enable {
                undoFile = lib.mkIf (cfg.enable && cfg.persistent.enable) {
                        enable = true;
                };
        };
}
