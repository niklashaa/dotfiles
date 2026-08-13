-- nvim-treesitter `main` branch (the master API — require('nvim-treesitter.configs')
-- — is gone). Parsers are installed via .install(); highlighting/indent are enabled
-- per-buffer on FileType (Neovim provides them, the plugin no longer auto-enables).
local ts = require('nvim-treesitter')

ts.setup() -- defaults: install_dir = stdpath('data')/site

local ensure_installed = {
  'bash',
  'css',
  'gitcommit',
  'html',
  'json',
  'javascript',
  'julia',
  'lua',
  'markdown',
  'markdown_inline',
  'python',
  'sql',
  'tsx',
  'typescript',
  'vim',
  'vimdoc',
  'vue',
}

-- Install any missing parsers (async, idempotent — only fetches what's absent).
local installed = ts.get_installed()
local missing = vim.tbl_filter(function(lang)
  return not vim.tbl_contains(installed, lang)
end, ensure_installed)
if #missing > 0 then
  ts.install(missing)
end

-- Enable highlighting + (experimental) indentation when a parser exists for the buffer.
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('treesitter-enable', { clear = true }),
  callback = function(ev)
    -- Only attach to normal file buffers. Skips scratch/preview/special buffers
    -- (buftype ~= '') so the highlighter never runs on e.g. plugin previews.
    if vim.bo[ev.buf].buftype ~= '' then
      return
    end
    if pcall(vim.treesitter.start, ev.buf) then
      vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})
