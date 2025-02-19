-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
  },
  keys = function(_, keys)
    local dap = require 'dap'
    local dapui = require 'dapui'
    return {
      -- Basic debugging keymaps, feel free to change to your liking!
      { '<leader>dc', dap.continue, desc = 'Debug: Start/Continue' },
      { '<leader>dsi', dap.step_into, desc = 'Debug: Step Into' },
      -- { '<leader>dso', dap.step_over, desc = 'Debug: Step Over' },
      -- { '<F3>', dap.step_out, desc = 'Debug: Step Out' },
      { '<leader>b', dap.toggle_breakpoint, desc = 'Debug: Toggle Breakpoint' },
      {
        '<leader>B',
        function()
          dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
        end,
        desc = 'Debug: Set Breakpoint',
      },
      -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
      { '<F7>', dapui.toggle, desc = 'Debug: See last session result.' },
      unpack(keys),
    }
  end,
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        -- 'delve', -- Go
        'debugpy', -- Python
      },
    }

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    vim.keymap.set('n', '<leader>dt', dapui.toggle, { desc = 'Toggles the debugger ui' })

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Python adapter setup
    dap.adapters.python = {
      type = 'executable',
      command = vim.fn.stdpath 'data' .. '/mason/packages/debugpy/venv/bin/python',
      args = { '-m', 'debugpy.adapter' },
    }

    dap.configurations.python = {
      {
        name = 'Python: FastAPI',
        type = 'python',
        request = 'launch',
        module = 'uvicorn',
        args = {
          'subscriptions.commands:create_app',
          '--reload',
          '--factory',
          '--proxy-headers',
          '--port',
          '8080',
        },
        env = {
          debug = 'true',
        },
        envFile = vim.fn.getcwd() .. '/.env',
        justMyCode = false,
        console = 'integratedTerminal',
      },
      {
        name = 'Python: Kafka Consumer',
        type = 'python',
        request = 'launch',
        module = 'subscriptions.kafka.consumers',
        pythonPath = function()
          -- If using Poetry
          if vim.fn.filereadable 'pyproject.toml' == 1 then
            return vim.fn.trim(vim.fn.system 'poetry env info --path') .. '/bin/python'
          end
          -- If using Pyenv
          if vim.fn.getenv 'PYENV_VERSION' ~= vim.NIL then
            return vim.fn.trim(vim.fn.system 'pyenv which python')
          end
          -- If using a Virtualenv
          if vim.fn.getenv 'VIRTUAL_ENV' ~= vim.NIL then
            return vim.fn.getenv 'VIRTUAL_ENV' .. '/bin/python'
          end
          -- Default fallback
          return 'python'
        end,

        envFile = vim.fn.getcwd() .. '/.env',
        env = function()
          local env_file = vim.fn.getcwd() .. '/.env'
          local env_vars = {}
          for line in io.lines(env_file) do
            local key, value = line:match '([^=]+)=(.*)'
            if key and value then
              env_vars[key] = value
            end
          end
          return env_vars
        end,
        justMyCode = false,
        console = 'integratedTerminal',
      },
    }
  end,
}
