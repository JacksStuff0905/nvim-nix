{config, lib, pkgs, ...}:

let
        cfg = config.programs.nvim-nix.opts;

        file_to_not_import = [
        "default.nix"
        ];

        get-import-dir = dir: ignore: import ../../util/get-import-dir.nix {inherit lib; inherit dir; inherit ignore;};

in
{
        imports = get-import-dir ./. file_to_not_import;

        options.programs.nvim-nix.opts = {
                enable = lib.mkEnableOption "Enable the opts module";

                aliases = lib.mkOption {
                        type = lib.types.listOf lib.types.str;
                        default = [ "nvim" ];
                        description = "The shell aliases to use for this config";
                };

                leader = lib.mkOption {
                        type = lib.types.str;
                        default = " ";
                };
        };


        config.vim = lib.mkIf cfg.enable {
                globals.mapleader = cfg.leader;
        };
}
