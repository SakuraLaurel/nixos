{ pkgs, lib, config, ... }:

{
  programs.nixvim = {
    enable = true;
    nixpkgs.source = pkgs.path;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    extraPackages = with pkgs; [
      nixd    # 写 Nix 时的 LSP / 智能提示
      nixfmt  # 格式化 Nix 代码
      statix  # 检查 Nix 代码质量
      deadnix # 找 Nix 里的未使用代码
      nodejs_26  # Copilot
    ];

    colorschemes.rose-pine = {
      enable = true;
      settings.variant = "dawn";
    };

    globals = {
      mapleader = " ";
      maplocalleader = ",";
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>ff";
        action = "<cmd>Telescope find_files<cr>";
        options.desc = "Find files";
      }
      {
        mode = "n";
        key = "<leader>fg";
        action = "<cmd>Telescope live_grep<cr>";
        options.desc = "Live grep";
      }
      {
        mode = "n";
        key = "<leader>fb";
        action = "<cmd>Telescope buffers<cr>";
        options.desc = "Buffers";
      }
      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>Oil<cr>";
        options.desc = "File explorer";
      }
    ];

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
    };

    plugins = import ./nixvim/plugins.nix {
      inherit pkgs lib config;
    };

    lsp = import ./nixvim/lsp.nix;

    extraConfigLua = builtins.readFile ./nixvim/extraConfig.lua;
  };
}
