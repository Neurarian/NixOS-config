{ pkgs, ... }:
{

  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "tmux-256color";
    historyLimit = 100000;
    prefix = "C-a";
    plugins = with pkgs; [
      tmuxPlugins.catppuccin
      tmuxPlugins.continuum
      tmuxPlugins.resurrect
      tmuxPlugins.vim-tmux-navigator
    ];
    extraConfig = ''
      unbind C-b
      bind-key C-a send-prefix
      unbind %
      bind | split-window -h

      unbind '"'
      bind - split-window -v

      unbind r 
      bind r source-file ~/.tmux.conf

      bind -r j resize-pane -D 5
      bind -r k resize-pane -U 5
      bind -r l resize-pane -R 5
      bind -r h resize-pane -L 5

      bind -r m resize-pane -Z

      set -g mouse on

      set-option -sg escape-time 10

      set-window-option -g mode-keys vi

      bind-key -T copy-mode-vi 'v' send -X begin-selection
      bind-key -T copy-mode-vi 'y' send -X copy-selection

      unbind -T copy-mode-vi MouseDragEnd1Pane

      set -g @resurrect-capture-pane-contents 'on'
      set -g @continuum-restore 'on'
    '';
  };
}
