{
  config,
  lib,
  pkgs,
  ...
}:
let
  name = "completions";

  cfg = config.programs.nvim-nix.plugins.${name};
in
{
  options.programs.nvim-nix.plugins.${name} = {
    enable = lib.mkEnableOption "Enable ${name} plugin module";

    blink-cmp = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };

      friendly-snippets = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };

      mappings = {
        next = lib.mkOption {
          type = lib.types.str;
          default = "<C-j>";
        };
        previous = lib.mkOption {
          type = lib.types.str;
          default = "<C-k>";
        };
        scroll-docs-down = lib.mkOption {
          type = lib.types.str;
          default = "<C-J>";
        };
        scroll-docs-up = lib.mkOption {
          type = lib.types.str;
          default = "<C-K>";
        };
        close = lib.mkOption {
          type = lib.types.str;
          default = "<C-q>";
        };
        confirm = lib.mkOption {
          type = lib.types.str;
          default = "<CR>";
        };
        complete = lib.mkOption {
          type = lib.types.str;
          default = "<leader>cm";
        };
      };
    };

    luasnip = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config.vim = lib.mkIf cfg.enable {
    snippets.luasnip = lib.mkIf cfg.luasnip.enable{
      enable = true;
      setupOpts = {
        #enable_autosnippets = true;
      };
    };

    autocomplete.blink-cmp = lib.mkIf cfg.blink-cmp.enable {
      enable = true;
      friendly-snippets.enable = cfg.blink-cmp.friendly-snippets;

      setupOpts = {
        keymap = {
          preset = "none";

          "${cfg.blink-cmp.mappings.next}" = [
            "select_next"
            "snippet_forward"
            "fallback"
          ];

          "${cfg.blink-cmp.mappings.previous}" = [
            "select_prev"
            "snippet_backward"
            "fallback"
          ];

          "${cfg.blink-cmp.mappings.confirm}" = [
            "accept"
            "fallback"
          ];

          "${cfg.blink-cmp.mappings.close}" = [
            "hide"
            "fallback"
          ];

          "${cfg.blink-cmp.mappings.scroll-docs-down}" = [
            "scroll_documentation_down"
          ];
          "${cfg.blink-cmp.mappings.scroll-docs-up}" = [
            "scroll_documentation_up"
          ];

          "${cfg.blink-cmp.mappings.complete}" = [
            "show"
            "show_documentation"
            "hide_documentation"
            "fallback"
          ];
        };

        sources = {
          default = [ "lsp" "snippets" "path" "buffer" ];
        };

        snippets = {
          preset = "luasnip";
        };
        
        completion.documentation.auto_show = true;
      };

      mappings = {
        #scrollDocsDown = cfg.blink-cmp.mappings.scroll-docs-down;
        #scrollDocsUp = cfg.blink-cmp.mappings.scroll-docs-up;
        close = cfg.blink-cmp.mappings.close;
        confirm = cfg.blink-cmp.mappings.confirm;
        complete = cfg.blink-cmp.mappings.complete;
      };
    };
  };
}
