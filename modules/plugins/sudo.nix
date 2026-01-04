{config, lib, pkgs, ...}:
let
        name = "sudo";

        cfg = config.programs.nvim-nix.plugins.${name};
in
{
        options.programs.nvim-nix.plugins.${name} = {
                enable = lib.mkEnableOption "Enable ${name} plugin module";

                command-aliases = {
                        enable = lib.mkOption { type = lib.types.bool; default = true; };

                        sudo-write = {
                                enable = lib.mkOption { type = lib.types.bool; default = true; };

                                alias = lib.mkOption {
                                        type = lib.types.str;
                                        default = "w!!";
                                };
                        };
                };
        };

	config.vim.lazy.plugins.vim-suda = lib.mkIf cfg.enable {
                package = pkgs.vimPlugins.vim-suda;

                # Command aliases
                after = lib.mkIf cfg.command-aliases.enable (lib.strings.concatStrings [
                        (lib.optionalString cfg.command-aliases.sudo-write.enable ''
                                vim.cmd("ca ${cfg.command-aliases.sudo-write.alias} SudaWrite")
                        '')
                ]);
	};
}
