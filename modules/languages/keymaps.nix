{config, lib, ...}:
let
  cfg = config.programs.nvim-nix.languages;
in
  {
  options.programs.nvim-nix.languages.keymaps = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;   
    };

    keys = {
      lsp = {
        docs = lib.mkOption {
          type = lib.types.str;
          default = "<leader>dc";
        };
        definitions = lib.mkOption {
          type = lib.types.str;
          default = "<leader>df";
        };
        usages = lib.mkOption {
          type = lib.types.str;
          default = "<leader>us";
        };
        code-actions = lib.mkOption {
          type = lib.types.str;
          default = "<leader>ca";
        };
      };
      formatters = {
        format = lib.mkOption {
          type = lib.types.str;
          default = "<leader>fr";
        };
      };
      linters = {
        error = lib.mkOption {
          type = lib.types.str;
          default = "<leader>er";
        };
      };
    };
  };


  config.vim.keymaps = lib.mkIf (cfg.enable && cfg.keymaps.enable) [
    # Configure LSPs
    {
      key = cfg.keymaps.keys.lsp.docs;
      mode = "n";
      lua = true;
      action = "vim.lsp.buf.hover";
    }
    {
      key = cfg.keymaps.keys.lsp.definitions;
      mode = "n";
      lua = true;
      action = "vim.lsp.buf.definition";
    }
    {
      key = cfg.keymaps.keys.lsp.usages;
      mode = "n";
      lua = true;
      action = "vim.lsp.buf.references";
    }
    {
      key = cfg.keymaps.keys.lsp.code-actions;
      mode = "n";
      lua = true;
      action = "vim.lsp.buf.code_action";
    }

    # Configure formatters
    {
      key = cfg.keymaps.keys.formatters.format;
      mode = "n";
      lua = true;
      action = "vim.lsp.buf.format";
    }

    # Configure linters
    {
      key = cfg.keymaps.keys.linters.error;
      mode = "n";
      lua = true;
      action = "vim.diagnostic.open_float";
    }
  ];
}
