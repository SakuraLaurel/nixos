{ pkgs, lib, config, ... }:

{
  programs.nixvim = {
    enable = true;
    nixpkgs.source = pkgs.path;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    extraPackages = with pkgs; [
      # 通用 CLI
      ripgrep
      fd

      # C/C++
      clang-tools    # clangd + clang-format
      clang
      gnumake
      ninja
      bear           # 给 Makefile 项目生成 compile_commands.json

      # Python
      pyright
      ruff
      python3
      python3Packages.debugpy

      # Nix
      nixd
      nixfmt
      statix
      deadnix

      # Copilot
      nodejs_22
    ];

    globals = {
      mapleader = " ";
      maplocalleader = ",";
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

      termguicolors = true;
      clipboard = "unnamedplus";
    };

    colorschemes.catppuccin.enable = true;

    plugins = {
      lualine.enable = true;
      web-devicons.enable = true;
      which-key.enable = true;
      gitsigns.enable = true;
      telescope.enable = true;
      nvim-autopairs.enable = true;

      # 新式：lspconfig 提供默认 server config，真正启用 server 用 programs.nixvim.lsp.servers
      lspconfig.enable = true;

      treesitter = {
        enable = true;
        highlight.enable = true;
        indent.enable = true;
        folding.enable = true;

        # 推荐由 Nix 安装 grammar，避免运行时编译 parser。
        grammarPackages =
          with config.programs.nixvim.plugins.treesitter.package.builtGrammars; [
            bash
            c
            cpp
            cmake
            json
            lua
            make
            markdown
            markdown_inline
            nix
            python
            query
            toml
            vim
            vimdoc
            yaml
          ];
      };

      blink-cmp = {
        enable = true;
        setupLspCapabilities = true;

        settings = {
          keymap = {
            # default: C-y 接受；super-tab: Tab 接受，接近 VSCode 习惯
            preset = "super-tab";
          };

          appearance = {
            nerd_font_variant = "mono";
          };

          completion = {
            documentation = {
              auto_show = true;
              auto_show_delay_ms = 200;
            };
          };

          sources = {
            default = [
              "lsp"
              "path"
              "snippets"
              "buffer"
            ];
          };

          # 在 Nix 下尽量不要运行时下载东西。若你的 blink 包已带 rust matcher，可改成 prefer_rust_with_warning。
          fuzzy = {
            implementation = "lua";
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

            keymap = {
              # 避免和 blink.cmp 的 Tab 冲突
              accept = "<M-l>";
              accept_word = "<M-w>";
              accept_line = "<M-j>";
              next = "<M-]>";
              prev = "<M-[>";
              dismiss = "<C-]>";
            };
          };

          filetypes = {
            markdown = true;
            gitcommit = true;
            yaml = true;
            help = false;
            "." = false;
          };

          copilot_node_command = lib.getExe pkgs.nodejs_22;
        };
      };
    };

    lsp = {
      inlayHints.enable = true;

      keymaps = [
        { key = "gd"; lspBufAction = "definition"; }
        { key = "gD"; lspBufAction = "declaration"; }
        { key = "gr"; lspBufAction = "references"; }
        { key = "gi"; lspBufAction = "implementation"; }
        { key = "gt"; lspBufAction = "type_definition"; }
        { key = "K"; lspBufAction = "hover"; }
        { key = "<leader>rn"; lspBufAction = "rename"; }
        {
          key = "<leader>ca";
          mode = [ "n" "v" ];
          lspBufAction = "code_action";
        }
      ];

      servers = {
        clangd = {
          enable = true;
          packageFallback = true;

          config = {
            cmd = [
              "clangd"
              "--background-index"
              "--clang-tidy"
              "--completion-style=detailed"
              "--header-insertion=iwyu"
            ];

            root_markers = [
              "compile_commands.json"
              "compile_flags.txt"
              ".clangd"
              ".git"
            ];
          };
        };

        pyright = {
          enable = true;
          packageFallback = true;

          config = {
            settings = {
              python = {
                analysis = {
                  typeCheckingMode = "basic";
                  autoSearchPaths = true;
                  useLibraryCodeForTypes = true;
                  diagnosticMode = "workspace";
                };
              };
            };
          };
        };

        ruff = {
          enable = true;
          packageFallback = true;
        };

        nixd = {
          enable = true;
          packageFallback = true;

          config = {
            settings = {
              nixd = {
                formatting = {
                  command = [ "nixfmt" ];
                };
              };
            };
          };
        };
      };
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

    plugins.oil.enable = true;

    extraConfigLua = ''
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99
      vim.diagnostic.config({
        virtual_text = true,
        severity_sort = true,
        float = {
          border = "rounded",
          source = "if_many",
        },
      })

      -- 让 Copilot ghost text 在 blink.cmp 菜单打开时隐藏，避免视觉冲突。
      vim.api.nvim_create_autocmd("User", {
        pattern = "BlinkCmpMenuOpen",
        callback = function()
          vim.b.copilot_suggestion_hidden = true
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "BlinkCmpMenuClose",
        callback = function()
          vim.b.copilot_suggestion_hidden = false
        end,
      })
    '';
  };
}
