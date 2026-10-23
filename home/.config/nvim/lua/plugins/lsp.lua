-- Language servers and linters are installed by Nix (home.nix), not Mason.
local languages = { 'go', 'python' }  -- parser names match filetypes for these

return {
  {
    -- Ready-made server configs; Neovim's built-in vim.lsp does the rest.
    'neovim/nvim-lspconfig',
    lazy = false,
    config = function()
      -- mypy (via nvim-lint) owns Python type errors; basedpyright only does navigation/completion.
      vim.lsp.config('basedpyright', {
        settings = { basedpyright = { analysis = { typeCheckingMode = 'off' } } },
      })
      -- Inlay hints (inferred types, parameter names); gopls ships with them off.
      vim.lsp.config('gopls', {
        settings = { gopls = { hints = {
          assignVariableTypes = true, compositeLiteralFields = true, constantValues = true,
          functionTypeParameters = true, parameterNames = true, rangeVariableTypes = true,
        } } },
      })
      vim.lsp.enable({ 'gopls', 'basedpyright', 'ruff' })
      vim.lsp.inlay_hint.enable(true)
      vim.diagnostic.config({ virtual_text = true })
    end,
  },
  {
    'mfussenegger/nvim-lint',
    event = 'BufWritePost',
    config = function()
      require('lint').linters_by_ft = { python = { 'mypy' } }
      vim.api.nvim_create_autocmd('BufWritePost', {
        callback = function() require('lint').try_lint() end,
      })
      require('lint').try_lint()
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').install(languages)
      vim.api.nvim_create_autocmd('FileType', {
        pattern = languages,
        callback = function() pcall(vim.treesitter.start) end,
      })
    end,
  },
}
