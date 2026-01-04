{config, lib, ...}:
let
        cfg = config.programs.nvim-nix.global-keymaps;
in
{
        # Configure global keymaps here.
        # If a keymap is used for a plugin, it should be placed in the plugin's config instead.

        options.programs.nvim-nix.global-keymaps = {
                enable = lib.mkEnableOption "Enable global keymaps module";

                window-navigation = {
                        enable = lib.mkOption { type = lib.types.bool; default = true; };

                        left = lib.mkOption { type = lib.types.str; default = "H"; };
                        right = lib.mkOption { type = lib.types.str; default = "L"; };
                        down = lib.mkOption { type = lib.types.str; default = "J"; };
                        up = lib.mkOption { type = lib.types.str; default = "K"; };

                        previous = lib.mkOption { type = lib.types.str; default = "<leader>bc"; };
                        next = lib.mkOption { type = lib.types.str; default = "<leader>fw"; };
                };
        };


        config.vim.keymaps = lib.mkIf cfg.enable (lib.mkMerge [
                # Configure window navigation
                (lib.mkIf cfg.window-navigation.enable [
                        { key = "H"; mode = "n"; action = "<C-w>h"; }
                        { key = "J"; mode = "n"; action = "<C-w>j"; }
                        { key = "K"; mode = "n"; action = "<C-w>k"; }
                        { key = "L"; mode = "n"; action = "<C-w>l"; }

                        { key = "<leader>bc"; mode = "n"; action = "<C-o>"; }
                        { key = "<leader>fw"; mode = "n"; action = "<C-i>"; }
                ])
 
        ]);
}
