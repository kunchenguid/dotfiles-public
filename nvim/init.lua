----===========================----
----=== Auto Install Packer ===----
----===========================----

local packer_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(packer_path)) > 0 then
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. packer_path)
  return
end

----===========================----
----=== Auto Packer Compile ===----
----===========================----

local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd(
  'BufWritePost',
  { command = 'source <afile> | PackerCompile', group = packer_group, pattern = 'init.lua' }
)

----=====================----
----=== Windows Setup ===----
----=====================----

if (vim.loop.os_uname().sysname == 'Windows NT') then
  -- Enable powershell as your default shell
  vim.opt.shell = 'pwsh.exe -NoLogo'
  vim.opt.shellcmdflag =
  '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
  vim.cmd [[
      let &shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
      let &shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
      set shellquote= shellxquote=
    ]]
end

----=====================----
----=== Util Functions ===---
----=====================----

local function noremap(mode, lhs, rhs)
  local options = { noremap = true, silent = true }
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local function buffer_dir()
  return vim.fn.expand('%:p:h')
end

----=======================----
----=== General Options ===----
----=======================----

-- app behaviors
vim.o.backup = false
vim.o.swapfile = false
vim.o.termguicolors = true
vim.o.title = true
vim.o.fileencodings = 'utf-8'
vim.o.clipboard = 'unnamedplus'
vim.o.mouse = ''
vim.g.mapleader = ' '

-- editing
vim.o.ignorecase = true
vim.o.smartindent = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.expandtab = true
vim.o.undofile = true

-- ui
vim.o.cmdheight = 2
vim.o.signcolumn = 'yes'
vim.o.splitbelow = true
vim.o.splitright = true

-- show relative number
vim.o.number = true
vim.o.relativenumber = true

-- disable some unnecessary highlighting
vim.o.cursorline = false
vim.g.loaded_matchparen = 0

----===============----
----=== Plugins ===----
----===============----

require('packer').startup(function(use)
  -- common libraries
  use 'wbthomason/packer.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'williamboman/mason.nvim'

  -- ui
  use {
    'rose-pine/neovim',
    as = 'rose-pine',
    tag = 'v1.*',
  }
  use {
    'akinsho/bufferline.nvim',
    tag = 'v2.*'
  }
  use 'nvim-lualine/lualine.nvim'
  use {
    'iamcco/markdown-preview.nvim',
    run = function() vim.fn['mkdp#util#install']() end,
  }
  use 'nvim-telescope/telescope.nvim'
  use 'nvim-telescope/telescope-file-browser.nvim'
  use 'numToStr/FTerm.nvim'
  use 'folke/which-key.nvim'
  use 'rcarriga/nvim-notify'
  use 'lewis6991/gitsigns.nvim'

  -- language related
  use 'williamboman/mason-lspconfig.nvim'
  use 'neovim/nvim-lspconfig'
  use {
    'glepnir/lspsaga.nvim',
    branch = 'main',
  }
  use 'L3MON4D3/LuaSnip'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'saadparwaiz1/cmp_luasnip'
  use 'hrsh7th/nvim-cmp'
  use 'jose-elias-alvarez/null-ls.nvim'
  use 'Maan2003/lsp_lines.nvim'
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
  }
  use 'nvim-treesitter/nvim-treesitter-context'

  -- editing
  use 'github/copilot.vim'
  use 'windwp/nvim-autopairs'
  use 'windwp/nvim-ts-autotag'
  use 'editorconfig/editorconfig-vim'
end)

require('mason').setup {
  ui = {
    keymaps = {
      toggle_package_expand = '<CR>',
      install_package = 'i',
      update_package = 'u',
      check_package_version = 'c',
      update_all_packages = 'U',
      check_outdated_packages = 'C',
      uninstall_package = 'X',
      cancel_installation = '<C-c>',
      apply_language_filter = '<C-f>',
    },
  },
}
require('mason-lspconfig').setup {
  automatic_installation = true
}

require('rose-pine').setup({
  dark_variant = 'moon'
})
vim.cmd('colorscheme rose-pine')

local p = require('rose-pine.palette')
require('bufferline').setup {
  highlights = {
    buffer_visible = {
      fg = p.subtle,
      bg = p.base
    },
    buffer_selected = {
      fg = p.text,
      bg = p.surface,
      italic = false,
      bold = true
    }
  },
  options = {
    always_show_bufferline = true,
    modified_icon = '●',
    left_trunc_marker = '',
    right_trunc_marker = '',
    show_buffer_icons = false,
    show_buffer_close_icons = false,
    show_close_icon = false
  }
}

require('lualine').setup {
  options = {
    theme = 'rose-pine',
    icons_enabled = false,
    component_separators = '',
    section_separators = '',
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff' },
    lualine_c = { 'diagnostics' },
    lualine_x = { 'encoding', 'fileformat' },
    lualine_y = { 'filetype' },
    lualine_z = { 'location' }
  }
}

require('which-key').setup()

vim.notify = require('notify')
require('notify').setup {
  stages = 'fade',
  timeout = 3000,
  render = 'default'
}

require('gitsigns').setup {
  current_line_blame = true,
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol',
    delay = 1000
  },
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, { expr = true })

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, { expr = true })

    -- Actions
    map({ 'n', 'v' }, '<Leader>hs', ':Gitsigns stage_hunk<CR>')
    map({ 'n', 'v' }, '<Leader>hr', ':Gitsigns reset_hunk<CR>')
    map('n', '<Leader>hS', gs.stage_buffer)
    map('n', '<Leader>hu', gs.undo_stage_hunk)
    map('n', '<Leader>hR', gs.reset_buffer)
    map('n', '<Leader>hp', gs.preview_hunk)
    map('n', '<Leader>hd', gs.diffthis)
    map('n', '<Leader>hD', function() gs.diffthis('~') end)
    map('n', '<Leader>td', gs.toggle_deleted)

    -- Text object
    map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
}

-- markdown preview
vim.g.mkdp_auto_start = 1

-- telescope
local telescope = require('telescope')
local actions = require('telescope.actions')
local builtin = require('telescope.builtin')
local fb_actions = telescope.extensions.file_browser.actions

telescope.setup {
  defaults = {
    mappings = {
      n = {
        ['q'] = actions.close
      },
    },
  },
  extensions = {
    file_browser = {
      hijack_netrw = true,
      initial_mode = 'normal',
      hidden = true,
      grouped = true,
      respect_gitignore = true,
      layout_config = { height = 40 },
      mappings = {
        ['n'] = {
          ['a'] = fb_actions.create
        }
      }
    }
  },
}

telescope.load_extension('file_browser')

require('FTerm').setup({
  border = 'double'
})

-- lsp
local nvim_lsp = require('lspconfig')

vim.api.nvim_create_augroup('formatting', {})
vim.api.nvim_create_autocmd('BufWritePre', {
  group = 'formatting',
  callback = function()
    vim.lsp.buf.formatting_sync(nil, 3000)
    vim.notify('File formatted on save.')
  end,
})

local on_attach = function(client)
  if client.name == 'tsserver' or client.name == 'eslint' or client.name == 'tailwindcss' then
    client.resolved_capabilities.document_formatting = false
  end
end

local capabilities = require('cmp_nvim_lsp').update_capabilities(
  vim.lsp.protocol.make_client_capabilities()
)

nvim_lsp.cssls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    css = {
      lint = {
        unknownAtRules = 'ignore'
      }
    }
  }
}

nvim_lsp.html.setup {
  on_attach = on_attach,
  capabilities = capabilities
}

nvim_lsp.jsonls.setup {
  on_attach = on_attach,
  capabilities = capabilities
}

nvim_lsp.eslint.setup {
  on_attach = on_attach,
  capabilities = capabilities
}

nvim_lsp.tsserver.setup {
  on_attach = on_attach,
  capabilities = capabilities
}

nvim_lsp.tailwindcss.setup {
  on_attach = on_attach,
  capabilities = capabilities
}

nvim_lsp.sumneko_lua.setup {
  on_attach = on_attach,
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
      }
    }
  }
}

require('lspsaga').init_lsp_saga {}

local cmp = require('cmp')
if (cmp ~= nil) then
  cmp.setup {
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = true
      }),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
      { name = 'buffer' },
    })
  }
end

local null_ls = require('null-ls')
null_ls.setup({
  sources = {
    null_ls.builtins.formatting.prettierd.with {
      condition = function(utils)
        return utils.root_has_file '.prettierrc'
            or utils.root_has_file '.prettierrc.js'
            or utils.root_has_file '.prettierrc.json'
      end,
      prefer_local = 'node_modules/.bin'
    },
    null_ls.builtins.formatting.eslint_d.with {
      condition = function(utils)
        return utils.root_has_file '.eslintrc'
            or utils.root_has_file '.eslintrc.js'
            or utils.root_has_file '.eslintrc.json'
      end,
      prefer_local = 'node_modules/.bin'
    }
  }
})

require('lsp_lines').setup()
vim.diagnostic.config({
  virtual_text = false,
  virtual_lines = {
    only_current_line = true
  },
  underline = true,
  update_in_insert = false
})

local ts = require('nvim-treesitter.configs')
ts.setup {
  highlight = {
    enable = true,
    disable = {},
  },
  indent = {
    enable = true,
    disable = {},
  },
  auto_install = true,
  ensure_installed = {
    'bash',
    'javascript',
    'jsdoc',
    'typescript',
    'tsx',
    'html',
    'css',
    'graphql',
    'json',
    'markdown',
    'php',
    'python',
    'yaml',
    'lua',
    'vim'
  },
  autotag = {
    enable = true,
  },
}
require 'nvim-treesitter.install'.compilers = { 'cl', 'gcc' }
require('treesitter-context').setup()

require('nvim-autopairs').setup()
require('nvim-ts-autotag').setup()

----====================----
----=== Key Bindings ===----
----====================----

-- make 'p' no longer update register
vim.cmd [[
  xnoremap <expr> p 'pgv"'.v:register.'y'
]]

-- telescope
vim.keymap.set('n', '<Leader>f',
  function()
    builtin.find_files({
      no_ignore = false,
      hidden = true
    })
  end)
vim.keymap.set('n', '<Leader>r', function()
  builtin.live_grep()
end)
vim.keymap.set('n', '<Leader>e', function()
  telescope.extensions.file_browser.file_browser({
    path = '%:p:h',
    cwd = buffer_dir()
  })
end)

-- buffer switching
noremap('n', '<Tab>', ':bnext<CR>')
noremap('n', '<S-Tab>', ':bprev<CR>')
noremap('n', '<Leader>x', ':bd<CR>')

-- increment/decrement
noremap('n', '+', '<C-a>')
noremap('n', '-', '<C-x>')

-- select all
noremap('n', '<C-a>', 'gg<S-v>G')

-- terminal
noremap('n', '<Leader>t', '<CMD>lua require("FTerm").toggle()<CR>')
noremap('t', '<ESC>', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')

-- lsp
noremap('n', 'K', '<CMD>Lspsaga hover_doc<CR>');
noremap('n', 'gd', '<CMD>Lspsaga lsp_finder<CR>');
noremap('n', 'gp', '<CMD>Lspsaga preview_definition<CR>');
noremap('n', 'gr', '<CMD>Lspsaga rename<CR>');
noremap('n', 'ga', '<CMD>Lspsaga code_action<CR>');
noremap('v', 'ga', '<CMD>Lspsaga range_code_action<CR>');
