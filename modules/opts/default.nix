{config, lib, pkgs, ...}:

let
        cfg = config.programs.nvim-nix.opts;
in
{
        options.programs.nvim-nix.opts = {
                enable = lib.mkEnableOption "Enable the opts module";

                leader = lib.mkOption {
                        type = lib.types.str;
                        default = " ";
                };

                clipboard = {
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
                
        };


        config.vim = lib.mkIf cfg.enable {
                globals.mapleader = cfg.leader;
                clipboard = cfg.clipboard;
        };
}
