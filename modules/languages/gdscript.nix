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

    luaConfigRC.godot_pipe = ''
      -- Function to find Godot project root directory
      local function find_godot_project_root()
          local cwd = vim.fn.getcwd()
          local search_paths = { "", '/..' }
          
          for _, relative_path in ipairs(search_paths) do
              local project_file = cwd .. relative_path .. '/project.godot'
              if vim.uv.fs_stat(project_file) then
                  return cwd .. relative_path
              end
          end
          
          return nil
      end

      -- Function to check if server is already running
      local function is_server_running(project_path)
          local server_pipe = project_path .. '/server.pipe'
          return vim.uv.fs_stat(server_pipe) ~= nil
      end

      -- Function to start Godot server if needed
      local function start_godot_server_if_needed()
          local godot_project_path = find_godot_project_root()
          
          if godot_project_path and not is_server_running(godot_project_path) then
              vim.fn.serverstart(godot_project_path .. '/server.pipe')
              return true
          end
          
          return false
      end

      -- Main execution
      start_godot_server_if_needed()
    '';
  };
}
