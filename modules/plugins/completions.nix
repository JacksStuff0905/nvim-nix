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

        # Define where completion items come from
        sources = {
          # 'lsp' gives you code suggestions
          # 'snippets' gives you pre-defined snippets (like friendly-snippets)
          default = [ "lsp" "snippets" "path" "buffer" ];
        };

        # Connect Blink to Luasnip
        snippets = {
          preset = "luasnip";
        };
        
        # Optional: Make sure the documentation window is enabled to see snippet previews
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

/*
  return {
  	{
  		"hrsh7th/cmp-nvim-lsp",
  	},
  	{
  		"L3MON4D3/LuaSnip",
  		dependencies = {
  			"saadparwaiz1/cmp_luasnip",
  			"rafamadriz/friendly-snippets",
  		},
  	},
  	--[[ {
  		"tzachar/cmp-ai",
  		dependencies = { "nvim-lua/plenary.nvim" },
  		lazy = false,
  		config = function()
  			local cmp_ai = require("cmp_ai.config")

  			cmp_ai:setup({
  				max_lines = 100,
  				provider = "Ollama",
  				provider_options = {
  					model = "codegemma:2b-code",
  					prompt = function(lines_before, lines_after)
  						return lines_before
  					end,
  					suffix = function(lines_after)
  						return lines_after
  					end,
  				},
  				notify = true,
  				notify_callback = function(msg)
  					vim.notify(msg)
  				end,
  				run_on_every_keystroke = true,
  			})
  		end,
  	}, ]]--
  	{
  		"hrsh7th/nvim-cmp",
  		config = function()
  			local cmp = require("cmp")

  			-- Load vscode-like snippets from friendly-snippets to Luasnip
  			require("luasnip.loaders.from_vscode").lazy_load()

  			cmp.setup({
  				snippet = {
  					expand = function(args)
  						require("luasnip").lsp_expand(args.body)
  					end,
  				},
  				window = {
  					completion = cmp.config.window.bordered({
  						border = "rounded",
  						col_offset = -1,
  						scrollbar = false,
  						scrolloff = 3,
  						winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
  					}),
  					documentation = cmp.config.window.bordered({
  						border = "rounded",
  						scrollbar = false,

  						winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
  					}),
  				},
  				mapping = cmp.mapping.preset.insert({
  					["<C-b>"] = cmp.mapping.scroll_docs(-4),
  					["<C-f>"] = cmp.mapping.scroll_docs(4),
  					["<C-Space>"] = cmp.mapping.complete(),
  					["<C-e>"] = cmp.mapping.abort(),
  					["<CR>"] = cmp.mapping.confirm({ select = true }),
  				}),
  				sources = cmp.config.sources({
  					{ name = "nvim_lsp" },
  					{ name = "luasnip" },
  					{ name = "cmp_ai" },
  				}, {
  					{ name = "buffer" },
  				}),
  			})
  		end,
  	},
  }
*/
