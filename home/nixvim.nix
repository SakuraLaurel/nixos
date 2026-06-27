{
  pkgs,
  lib,
  config,
  ...
}:

{
  programs.nixvim = {
    enable = true;
    nixpkgs.source = pkgs.path;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    extraPackages = with pkgs; [
      ripgrep
      fd
      nixd # 写 Nix 时的 LSP / 智能提示
      nixfmt # 格式化 Nix 代码
      statix # 检查 Nix 代码质量
      deadnix # 找 Nix 里的未使用代码
      nodejs_26 # Copilot
    ];

    colorschemes.rose-pine = {
      enable = true;
      settings.variant = "dawn";
    };

    globals = {
      mapleader = " ";
      maplocalleader = ",";
      copilot_nes_debounce = 500;
    };

    opts = {
      number = true;
      relativenumber = true;
      signcolumn = "yes";
      cursorline = true;

      expandtab = true;
      shiftwidth = 2;
      tabstop = 2;
      smartindent = true;

      ignorecase = true;
      smartcase = true;

      splitright = true;
      splitbelow = true;

      undofile = true;
      updatetime = 250;
      timeoutlen = 400;

      clipboard = "unnamedplus";
      termguicolors = true;
      background = "light";

      foldlevel = 99;
      foldlevelstart = 99;
    };

    diagnostic.settings = {
      virtual_text = true;
      severity_sort = true;

      float = {
        source = true;
      };
    };

    keymaps = import ./nixvim/keymaps.nix;

    plugins = import ./nixvim/plugins.nix {
      inherit pkgs lib config;
    };

    lsp = import ./nixvim/lsp.nix;

    autoCmd = [
      {
        event = "User";
        pattern = "BlinkCmpMenuOpen";
        callback = {
          __raw = ''
            function()
              require("copilot.suggestion").dismiss()
              vim.b.copilot_suggestion_hidden = true
            end
          '';
        };
      }

      {
        event = "User";
        pattern = "BlinkCmpMenuClose";
        callback = {
          __raw = ''
            function()
              vim.b.copilot_suggestion_hidden = false
            end
          '';
        };
      }
    ];
  };
}
