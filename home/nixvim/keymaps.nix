[
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
    key = "<leader>e";
    action = "<cmd>Oil<cr>";
    options.desc = "File explorer";
  }
  {
    mode = "n";
    key = "<leader>r";
    action.__raw = ''
      function()
        local file = vim.fn.expand("%:p")
        local root = vim.fs.root(0, { "pyproject.toml", ".git" }) or vim.fn.getcwd()

        vim.cmd("botright 12split")
        vim.cmd(
          "terminal cd "
            .. vim.fn.shellescape(root)
            .. " && python "
            .. vim.fn.shellescape(file)
        )
        vim.cmd("startinsert")
      end
    '';
    options = {
      desc = "Run current Python file";
    };
  }
]
