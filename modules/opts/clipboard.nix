{config, lib, ...}:

let
        cfg = config.programs.nvim-nix.opts.clipboard;
in
{

        options.programs.nvim-nix.opts.clipboard = {
                enable = lib.mkOption {
                        type = lib.types.bool;
                        default = true;
                };

                registers = lib.mkOption {
                        type = lib.types.str;
                        default = "unnamedplus";
                };

                providers = {
                        wl-copy.enable = lib.mkOption {
                                type = lib.types.bool;
                                default = true;
                        };

                        xclip.enable = lib.mkOption {
                                type = lib.types.bool;
                                default = true;
                        };
                };
        };

        config.vim = lib.mkIf config.programs.nvim-nix.opts.enable {
                clipboard = lib.mkIf config.programs.nvim-nix.opts.clipboard.enable cfg;
        };
}
