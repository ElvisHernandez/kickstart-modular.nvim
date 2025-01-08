return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local harpoon = require 'harpoon'

    -- REQUIRED
    harpoon:setup()

    harpoon:extend {
      UI_CREATE = function(cx)
        vim.keymap.set('n', '<c-v>', function()
          harpoon.ui:select_menu_item { vsplit = true }
        end, { buffer = cx.bufnr })
      end,
    }

    vim.keymap.set('n', '<leader>a', function()
      harpoon:list():add()
    end)
    vim.keymap.set('n', '<leader>m', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end)

    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set('n', '<leader>p', function()
      harpoon:list():prev()
    end)
    vim.keymap.set('n', '<leader>n', function()
      harpoon:list():next()
    end)

    for i = 0, 9 do
      vim.keymap.set('n', '<leader>' .. i, function()
        harpoon:list():select(i)
      end, { desc = 'Harpoon select ' .. i })
    end
  end,
}
