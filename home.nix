{ config, pkgs, user, inputs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/.dotfiles";
in

{
  home.username = user;
  home.homeDirectory = "/Users/${user}";
  home.stateVersion = "24.11";
  home.packages = with pkgs; [
    # cli i use constantly
    ripgrep   # fast search
    fd        # fast find
    fzf       # fuzzy finder
    jq        # json on the command line
    lazygit
    neovim
    # language servers and linters for nvim (wired up in nvim/lua/plugins/lsp.lua)
    gopls
    basedpyright ruff mypy
    tree-sitter  # nvim-treesitter compiles its parsers with this
    # git push gate (no `init`, so no /no-mistakes skill for agents); run `no-mistakes daemon restart` after upgrades
    inputs.no-mistakes.packages.${pkgs.stdenv.hostPlatform.system}.default
    # the font everything renders in
    nerd-fonts.hack
  ];
  fonts.fontconfig.enable = true;
  home.sessionVariables.EDITOR = "nvim";
  # The no-mistakes daemon imports the login-shell env at startup, so this covers it too.
  home.sessionVariables.NO_MISTAKES_TELEMETRY = "0";
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;      # ghost text from history
    syntaxHighlighting.enable = true;  # commands turn green when valid
    initContent = pkgs.lib.mkMerge [
      ''
        bindkey '^f' autosuggest-accept
        bindkey '^u' backward-kill-line  # match macOS Cmd+Backspace (WezTerm sends ^U)
        # Home/End: both the normal and application-cursor-mode sequences
        bindkey '^[[H' beginning-of-line '^[OH' beginning-of-line
        bindkey '^[[F' end-of-line '^[OF' end-of-line
        # Ctrl+Arrow (WezTerm also sends these for Option+Arrow)
        bindkey '^[[1;5D' backward-word '^[[1;5C' forward-word
      ''
      # Private, untracked overrides; loaded last so they win.
      (pkgs.lib.mkAfter ''
        [[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
      '')
    ];
    shellAliases = {
      ".." = "cd ..";
      add = "git add .";
      push = "git push";
      pull = "git pull";
      m = "git switch main";
      cc = "claude"; 
      co = "codex --full-auto";
      l  = "ls -F";
    };
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = "$directory$git_branch$git_status$cmd_duration$line_break$character";
      character = {
        success_symbol = "[❯](purple)";
        error_symbol = "[❯](red)";
      };
      cmd_duration.format = "[$duration]($style) ";
    };
  };

  # Edit-in-place: the real file stays in my repo, ~/.config just points at it.
  home.file.".config/wezterm".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/wezterm";
  home.file.".config/nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/nvim";
  home.file.".config/herdr".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/herdr";

  # Keep Pi's credential and runtime state local by linking only authored files and directories.
  home.file.".pi/agent/themes".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.pi/agent/themes";
  home.file.".pi/agent/extensions".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.pi/agent/extensions";
  home.file.".pi/agent/models.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.pi/agent/models.json";
  home.file.".pi/agent/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.pi/agent/settings.json";

  home.file.".claude/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.claude/settings.json";
  home.file.".claude/CLAUDE.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
  home.file.".codex/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
  home.file.".config/opencode/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
}
