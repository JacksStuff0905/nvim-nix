{config, lib, pkgs, ...}:

let
        cfg = config.programs.nvim-nix.opts.spelling;


in
{
        imports = [
                ./dirtytalk.nix
        ];

        options.programs.nvim-nix.opts.spelling = {
                enable = lib.mkOption {
                        type = lib.types.bool;
                        default = true;
                };
                
                languages = lib.mkOption {
                        type = lib.types.listOf lib.types.str;
                        default = ["en" "pl" "es"];
                };

        };

        config.vim = lib.mkIf config.programs.nvim-nix.opts.enable {
                spellcheck.enable = cfg.enable;
                spellcheck.languages = cfg.languages;
        };
}
