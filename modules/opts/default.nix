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

                clipboard-registers = lib.mkOption {
                        type = lib.types.str;
                        default = "unnamedplus";
                };
        };


        config.vim = lib.mkIf cfg.enable {
                globals.mapleader = cfg.leader;
                clipboard.registers = cfg.clipboard-registers;
        };
}
