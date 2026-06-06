return {
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",
        opts = {
            install_dir = vim.fn.stdpath("data") .. "/site",
        },
        config = function(_, opts)
            local ts = require("nvim-treesitter")
            ts.setup(opts)
            ts.install({
                "bash",
                "json",
                "lua",
                "markdown",
                "markdown_inline",
                "python",
                "vim",
                "vimdoc",
                "yaml",
            })

            vim.api.nvim_create_autocmd("FileType", {
                pattern = {
                    "bash",
                    "json",
                    "lua",
                    "markdown",
                    "python",
                    "vim",
                    "yaml",
                },
                callback = function(args)
                    pcall(vim.treesitter.start, args.buf)
                    if vim.bo[args.buf].modifiable then
                        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    end
                end,
            })
        end,
    },
}
