-- this file create separate XDG path
-- thus Lazy.nvim doesnt takes control over the loading
local M = {}

function M.root(root)
  local f = debug.getinfo(1, "S").source:sub(2)
  return vim.fn.fnamemodify(f, ":p:h:h") .. "/" .. (root or "")
end

---@param plugin string
function M.load(plugin)
  local name = plugin:match(".*/(.*)")
  local package_root = M.root(".tests/site/pack/deps/start/")
  if not vim.loop.fs_stat(package_root .. name) then
    print("Installing " .. plugin)
    vim.fn.mkdir(package_root, "p")
    vim.fn.system({
      "git",
      "clone",
      "--depth=1",
      "https://github.com/" .. plugin .. ".git",
      package_root .. "/" .. name,
    })
  end
end

function M.setup()
  vim.cmd([[set runtimepath=$VIMRUNTIME]])
  vim.opt.runtimepath:append(M.root())
  vim.opt.packpath = { M.root(".tests/site") }

  M.load("nvim-lua/plenary.nvim")
  M.load("nvim-neotest/nvim-nio")
  M.load("nvim-treesitter/nvim-treesitter")
  M.load("nvim-neotest/neotest")
  M.load("neovim/nvim-lspconfig")
  require("nvim-treesitter.configs").setup({
    -- A list of parser names, or "all" (the five listed parsers should always be installed)
    --
    sync_install = true,
    ensure_installed = { "go" },
    auto_install = true,
  })
end

M.setup()