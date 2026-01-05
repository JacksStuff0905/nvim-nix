{config, lib, pkgs, ...}:
let
        name = "lualine";

        cfg = config.programs.nvim-nix.plugins.${name};
in
{
        options.programs.nvim-nix.plugins.${name} = {
                enable = lib.mkEnableOption "Enable ${name} plugin module";
        };

	config.vim = lib.mkIf cfg.enable {
                statusline.lualine = {
                        enable = true;
                        theme = "auto";
                };

	};
}
