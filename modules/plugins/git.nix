{ config, lib, ... }:
let
  name = "git";

  cfg = config.programs.nvim-nix.plugins.${name};
in
{
  options.programs.nvim-nix.plugins.${name} = {
    enable = lib.mkEnableOption "Enable ${name} plugin module";

    gitsigns = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };

    vim-fugitive = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };

    keymaps = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };

      toggle = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };

        key = lib.mkOption {
          type = lib.types.str;
          default = "<leader>gi";
        };
      };

      gitsigns = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
        stage-hunk = lib.mkOption {
          type = lib.types.str;
          default = "<leader>sh";
        };
        stage-buffer = lib.mkOption {
          type = lib.types.str;
          default = "<leader>sb";
        };
        reset-hunk = lib.mkOption {
          type = lib.types.str;
          default = "<leader>rh";
        };
        reset-buffer = lib.mkOption {
          type = lib.types.str;
          default = "<leader>rb";
        };
        toggle-diff = lib.mkOption {
          type = lib.types.str;
          default = "<leader>td";
        };
      };
    };
  };

  config.vim = lib.mkIf cfg.enable {
    git = {
      gitsigns = {
        enable = cfg.gitsigns.enable;
      };

      vim-fugitive = {
        enable = cfg.vim-fugitive.enable;
      };
    };

    # Keybinds
    keymaps = lib.mkIf cfg.keymaps.enable (
      lib.mkMerge [
        (lib.mkIf cfg.keymaps.toggle.enable [{
          key = cfg.keymaps.toggle.key;
          mode = "n";
          silent = true;
          action = ":Git<CR>";
        }])
        (lib.mkIf cfg.keymaps.gitsigns.enable [
          {
            key = cfg.keymaps.gitsigns.stage-hunk;
            mode = "n";
            silent = true;
            lua = true;
            action = "require(\"gitsigns\").stage_hunk";
          }
          {
            key = cfg.keymaps.gitsigns.stage-buffer;
            mode = "n";
            silent = true;
            lua = true;
            action = "require(\"gitsigns\").stage_buffer";
          }
          {
            key = cfg.keymaps.gitsigns.reset-hunk;
            mode = "n";
            silent = true;
            lua = true;
            action = "require(\"gitsigns\").reset_hunk";
          }
          {
            key = cfg.keymaps.gitsigns.reset-buffer;
            mode = "n";
            silent = true;
            lua = true;
            action = "require(\"gitsigns\").reset_buffer";
          }
          {
            key = cfg.keymaps.gitsigns.toggle-diff;
            mode = "n";
            silent = true;
            lua = true;
            action = "require(\"gitsigns\").toggle_word_diff";
          }
        ])
      ]
    );
  };
}
