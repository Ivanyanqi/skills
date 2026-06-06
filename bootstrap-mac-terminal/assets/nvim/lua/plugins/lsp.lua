return {
    {
        "mason-org/mason.nvim",
        opts = {},
    },
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = {
            "mason-org/mason.nvim",
            "neovim/nvim-lspconfig",
        },
        opts = {
            ensure_installed = {
                "bashls",
                "jsonls",
                "lua_ls",
                "pyright",
                "yamlls",
            },
            automatic_enable = false,
        },
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "mason-org/mason-lspconfig.nvim",
            "saghen/blink.cmp",
        },
        config = function()
            local capabilities = require("blink.cmp").get_lsp_capabilities()
            local group = vim.api.nvim_create_augroup("codex-lsp-attach", { clear = true })

            vim.api.nvim_create_autocmd("LspAttach", {
                group = group,
                callback = function(args)
                    local map = function(lhs, rhs, desc)
                        vim.keymap.set("n", lhs, rhs, { buffer = args.buf, desc = desc })
                    end

                    map("gd", vim.lsp.buf.definition, "Go to definition")
                    map("gr", vim.lsp.buf.references, "Go to references")
                    map("K", vim.lsp.buf.hover, "Hover")
                    map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
                    map("<leader>ca", vim.lsp.buf.code_action, "Code action")
                end,
            })

            local servers = {
                bashls = {
                    capabilities = capabilities,
                },
                jsonls = {
                    capabilities = capabilities,
                },
                pyright = {
                    capabilities = capabilities,
                },
                yamlls = {
                    capabilities = capabilities,
                },
                lua_ls = {
                    capabilities = capabilities,
                    settings = {
                        Lua = {
                            diagnostics = {
                                globals = { "vim" },
                            },
                            workspace = {
                                checkThirdParty = false,
                            },
                            completion = {
                                callSnippet = "Replace",
                            },
                        },
                    },
                },
            }

            for server, server_opts in pairs(servers) do
                vim.lsp.config(server, server_opts)
                vim.lsp.enable(server)
            end
        end,
    },
}
