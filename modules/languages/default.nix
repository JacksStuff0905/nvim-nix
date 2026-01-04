{config, pkgs, lib, ...}:
let
        cfg = config.programs.nvim-nix.languages;
in
{
        options.programs.nvim-nix.languages = {
                enable = lib.mkEnableOption "Enable the language / LSP module";
                c = {
                        enable = lib.mkOption {
                                type = lib.types.bool;
                                description = "Enable C language module";
                                default = true;
                        };
                };
                nix = {
                        enable = lib.mkOption {
                                type = lib.types.bool;
                                description = "Enable nix language module";
                                default = true;
                        };
                };
        };


        config.vim = lib.mkIf cfg.enable {
                languages.clang = lib.mkIf cfg.c.enable {
                        enable = true;
                };

                languages.nix = lib.mkIf cfg.nix.enable {
                        enable = true;
                };
        };
}
