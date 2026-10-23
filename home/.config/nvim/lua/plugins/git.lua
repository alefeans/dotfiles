return {
  {
    'NeogitOrg/neogit',
    dependencies = { 'nvim-lua/plenary.nvim', 'sindrets/diffview.nvim' },
    keys = { { '<leader>g', function() require('neogit').open() end, desc = 'Neogit' } },
  },
  {
    -- review what the AI changed: all uncommitted changes side by side, or one file's history
    'sindrets/diffview.nvim',
    keys = {
      { '<leader>D', '<cmd>DiffviewOpen<cr>', desc = 'Diff uncommitted changes' },
      { '<leader>h', '<cmd>DiffviewFileHistory %<cr>', desc = 'File history' },
    },
  },
  {
    'lewis6991/gitsigns.nvim',
    event = 'BufWinEnter',
    opts = { current_line_blame = true },  -- who last touched this line
    keys = {
      { ']h', function() require('gitsigns').nav_hunk('next') end, desc = 'Next change' },
      { '[h', function() require('gitsigns').nav_hunk('prev') end, desc = 'Previous change' },
      { '<leader>p', function() require('gitsigns').preview_hunk() end, desc = 'Preview change' },
    },
  },
}

