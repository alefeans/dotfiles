return {
  {
    -- render headings, tables, code blocks and checkboxes in the buffer itself
    'MeanderingProgrammer/render-markdown.nvim',
    ft = 'markdown',
    opts = {},
  },
  {
    -- live browser preview; also draws Mermaid diagrams (WezTerm can't show them inline)
    'iamcco/markdown-preview.nvim',
    ft = 'markdown',
    cmd = { 'MarkdownPreview', 'MarkdownPreviewToggle' },
    build = 'cd app && npx --yes yarn install',  -- runs on node; the prebuilt binary is x86-only
    keys = { { '<leader>m', '<cmd>MarkdownPreviewToggle<cr>', ft = 'markdown', desc = 'Markdown preview (browser)' } },
  },
}
