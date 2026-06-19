return {
  -- require 'kickstart/plugins/tokyonight',
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    priority = 1000,
    init = function()
      require('rose-pine').setup {
        variant = 'main',
        dark_variant = 'main',

        styles = {
          italic = false,
          bold = true,
        },
      }

      vim.cmd.colorscheme 'rose-pine'
    end,
  },
  -- {
  --   'navarasu/onedark.nvim',
  --   priority = 1000, -- make sure to load this before all the other start plugins
  --   config = function()
  --     require('onedark').setup {
  --       style = 'darker',
  --     }
  --     -- Enable theme
  --     require('onedark').load()
  --   end,
  -- },
}
