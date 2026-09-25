-- See `:help nvim-treesitter`
-- nvim-treesitter `main` branch: the `master` branch is frozen and does NOT
-- support Neovim 0.12 (it crashes the highlighter with "attempt to call method
-- 'range' (a nil value)"). `main` is the rewrite with a new API — no
-- require('nvim-treesitter.configs'); parsers via .install(), highlighting via
-- vim.treesitter.start() on FileType. Requires the `tree-sitter` CLI to build
-- parsers (brew install tree-sitter-cli).
return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    local ts = require('nvim-treesitter')
    ts.setup()

    local ensure_installed = {
      'bash',
      'blade',
      'css',
      'gitcommit',
      'html',
      'hurl',
      'json',
      'javascript',
      'julia',
      'lua',
      'markdown',
      'markdown_inline',
      'php',
      'python',
      'sql',
      'tsx',
      'typescript',
      'vim',
      'vimdoc',
      'vue',
    }

    -- Install missing parsers (async, idempotent — only fetches what's absent).
    local installed = ts.get_installed()
    local missing = vim.tbl_filter(function(lang)
      return not vim.tbl_contains(installed, lang)
    end, ensure_installed)
    if #missing > 0 then
      ts.install(missing)
    end

    -- Enable highlighting + (experimental) indentation on real file buffers.
    -- The buftype guard skips scratch/preview buffers (e.g. telescope previews).
    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('treesitter-enable', { clear = true }),
      callback = function(ev)
        if vim.bo[ev.buf].buftype ~= '' then
          return
        end
        if pcall(vim.treesitter.start, ev.buf) then
          vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
