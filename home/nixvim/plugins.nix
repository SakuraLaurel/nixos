{ pkgs, lib, config, ... }:

{
  nvim-autopairs.enable = true;
  which-key.enable = true;
  telescope.enable = true;
  lualine.enable = true;
  web-devicons.enable = true;
  gitsigns.enable = true;
  oil.enable = true;
  lspconfig.enable = true;  # 新式：lspconfig 提供默认 server config，真正启用 server 用 programs.nixvim.lsp.servers
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

  blink-cmp = {
    enable = true;
    setupLspCapabilities = true;

    settings = {
      keymap.preset = "super-tab";  # 从 C-y 接受变为 Tab 接受，接近 VSCode 习惯
      appearance.nerd_font_variant = "mono";
      completion.documentation = {
        auto_show = true;
        auto_show_delay_ms = 200;
      };

      sources.default = [
        "lsp"
        "path"
        "snippets"
        "buffer"
      ];

      fuzzy.implementation = "prefer_rust_with_warning";
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

  copilot-lua = {
    enable = true;

    settings = {
      panel.enabled = false;
      suggestion = {
        enabled = true;
        auto_trigger = true;
        hide_during_completion = true;

        keymap = {  # 避免和 blink.cmp 的 Tab 冲突
          accept = "<M-l>";
          accept_word = "<M-w>";
          accept_line = "<M-j>";
          next = "<M-]>";
          prev = "<M-[>";
          dismiss = "<C-]>";
        };
      };

      filetypes = {
        python = true;
        cpp = true;
        help = false;
        "." = false;
      };

      copilot_node_command = lib.getExe pkgs.nodejs_26;
    };
  };
}
