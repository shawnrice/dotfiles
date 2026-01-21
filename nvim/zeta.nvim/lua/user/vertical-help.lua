-- @see https://github.com/dmmulroy/dotfiles/blob/main/.config/nvim/lua/user/vertical_help.lua
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("vertical_help", { clear = true }),
    pattern = "help",
    callback = function()
        vim.bo.bufhidden = "unload"
        vim.cmd.wincmd("L")
        vim.cmd.wincmd("=")
    end,
})
