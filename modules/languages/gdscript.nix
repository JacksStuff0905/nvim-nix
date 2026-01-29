{
  config,
  lib,
  pkgs,
  ...
}:

let
  name = "gdscript";
  lsp-name = "gdscript";

  cfg = config.programs.nvim-nix.languages;
in
{
  options.programs.nvim-nix.languages."${name}" = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "Enable ${name} language module";
      default = true;
    };
  };

  config.vim = lib.mkIf (cfg.enable && cfg."${name}".enable) {
    treesitter = lib.mkIf cfg.treesitter {
      enable = true;
      highlight.enable = true;

      grammars = [ pkgs.vimPlugins.nvim-treesitter-parsers."${name}" ];
    };

    lsp.lspconfig = {
      enable = true;
      sources."${lsp-name}" = ''
        vim.lsp.config['${lsp-name}'] = ({
          name = "${lsp-name}",
          cmd = vim.lsp.rpc.connect("127.0.0.1", 6005),

          -- When client attaches
          on_init = function(client, init_result)
            local pipe = "/tmp/godot.pipe"
            
            local success, err = pcall(vim.fn.serverstart, pipe)
            if not success then
              print("Note: Failed to start Godot pipe (might already exist): " .. err)
            else
              print("Godot LSP connected. Pipe at: " .. pipe)
            end
          end,
        })

        vim.lsp.enable('${lsp-name}')
      '';
    };
  };
}
