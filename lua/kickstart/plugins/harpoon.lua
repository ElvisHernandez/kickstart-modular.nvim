return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local harpoon = require 'harpoon'

    -- REQUIRED
    harpoon:setup()

    -----------------------------------------------------------
    -----------------------------------------------------------
    -- Custom list functions/keymaps
    vim.keymap.set('n', '<leader>hs', function()
      local ok, name = pcall(vim.fn.input, 'Set current harpoon list name: ')

      if not ok then
        return
      end

      if name ~= '' then
        harpoon.data:set_current_list_name(name)
      else
        print 'No list name entered'
      end
    end, { desc = 'Set current harpoon list name' })

    vim.keymap.set('n', '<leader>hl', function()
      harpoon:show_lists()
    end, { desc = 'Show the current harpoon lists available' })

    vim.keymap.set('n', '<leader>hd', function()
      harpoon:delete_list()
    end, { desc = 'Delete the current list' })
    -----------------------------------------------------------
    -----------------------------------------------------------

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
    vim.keymap.set('n', '<leader>hm', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end)

    vim.keymap.set('n', '<leader>hi', function()
      local info = harpoon:info()
      print(info.paths.data_path)
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
