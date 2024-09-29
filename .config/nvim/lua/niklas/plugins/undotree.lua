  -- Vim undo tree vizualizer
  return {
    'mbbill/undotree',
    vim.keymap.set({ 'n' }, '<leader>u', '<CMD>UndotreeToggle<CR>', { silent = true }),
  }

