{
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
}
