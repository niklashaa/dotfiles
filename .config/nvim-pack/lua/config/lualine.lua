require('lualine').setup({
  options = {
    icons_enabled = false,
    theme = 'gruvbox',
    component_separators = '|',
    section_separators = '',
  },
  sections = {
    lualine_b = {}, -- hide branch name
    lualine_c = {
      { 'filename', path = 1 },
    },
  },
})
