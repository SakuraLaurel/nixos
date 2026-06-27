{
  pkgs,
  lib,
  config,
  ...
}:

{
  nvim-autopairs.enable = true;
  which-key.enable = true;
  telescope.enable = true;
  lualine.enable = true;
  web-devicons.enable = true;
  gitsigns.enable = true;
  oil.enable = true;
  lspconfig.enable = true;

  treesitter = {
    enable = true;
    highlight.enable = true;
    indent.enable = true;
    folding.enable = true;
    grammarPackages = with config.programs.nixvim.plugins.treesitter.package.builtGrammars; [
      bash
      c
      cpp
      cmake
      python
      nix
      markdown
      markdown_inline
      json
      lua
      toml
      yaml
      query
    ];
  };

  fugitive = {
    enable = true;
  };

  # GBrowse 一般需要这个
  rhubarb = {
    enable = true;
  };

  blink-cmp = {
    enable = true;
    settings = {
      keymap = {
        preset = "super-tab";
      };
      completion = {
        menu = {
          auto_show = lib.nixvim.mkRaw ''
            function() 
              local ok, suggestion = pcall(require, "copilot.suggestion") 
              return (not ok) or (not suggestion.is_visible()) 
            end 
          '';
        };
        list = {
          selection = {
            preselect = true;
            auto_insert = false;
          };
        };
        documentation = {
          auto_show = true;
          auto_show_delay_ms = 200;
        };
        ghost_text = {
          enabled = false;
        };
      };
      signature = {
        enabled = true;
        window = {
          show_documentation = false;
        };
      };
      sources = {
        default = [
          "lsp"
          "path"
          "buffer"
        ];
        providers = {
          snippets = {
            enabled = false;
          };
        };
      };
      fuzzy = {
        implementation = "prefer_rust_with_warning";
      };
    };
  };

  conform-nvim = {
    enable = true;

    settings = {
      notify_on_error = true;
      notify_no_formatters = false;

      format_on_save = {
        timeout_ms = 1000;
        lsp_format = "fallback";
      };

      formatters_by_ft = {
        c = [ "clang_format" ];
        cpp = [ "clang_format" ];
        python = [
          "ruff_organize_imports"
          "ruff_format"
        ];
        nix = [ "nixfmt" ];
      };
    };
  };

  dap.enable = true;
  dap-python = {
    enable = true;
    testRunner = "pytest";
  };

  copilot-lsp = {
    enable = true;
    callSetup = true;
    settings = {
      nes = {
        move_count_threshold = 10;
      };
    };
  };

  # 对应 zbirenbaum/copilot.lua
  copilot-lua = {
    enable = true;
    settings = {
      panel = {
        enabled = false;
      };

      suggestion = {
        enabled = true;
        auto_trigger = true;
        hide_during_completion = true;
        debounce = 75;

        keymap = {
          accept = "<M-l>";
          accept_word = false;
          accept_line = false;
          next = "<M-]>";
          prev = "<M-[>";
          dismiss = "<C-]>";
          toggle_auto_trigger = false;
        };
      };

      nes = {
        enabled = true;
        auto_trigger = true;

        keymap = {
          accept_and_goto = "<leader>cn";
          accept = false;
          dismiss = "<leader>cd";
        };
      };

      filetypes = {
        python = true;
        cpp = true;
        c = true;
        rust = true;
        lua = true;
        "*" = false;
      };

      copilot_node_command = lib.getExe pkgs.nodejs_26;
    };
  };
}
