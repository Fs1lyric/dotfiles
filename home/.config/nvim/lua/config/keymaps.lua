
  vim.cmd("write")
  vim.cmd("!manim -pql " .. vim.fn.expand("%"))
end, { desc = "Manim: render preview (low quality)" })

vim.keymap.set("n", "<leader>mh", function()
  vim.cmd("write")
  vim.cmd("!manim -pqh " .. vim.fn.expand("%"))
end, { desc = "Manim: render preview (high quality)" })
