{ pkgs, ... }:
{

  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "wezterm";
    historyLimit = 100000;
    prefix = "C-a";
    plugins = with pkgs.tmuxPlugins; [
      catppuccin
      vim-tmux-navigator
      continuum
      resurrect
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

      set -g @continuum-restore 'on'
      set -g @continuum-boot 'on'
      set -g @continuum-save-interval '10'

      set -g @resurrect-capture-pane-contents 'on'
      set -g @resurrect-strategy-nvim 'session'
      set -g @resurrect-strategy-vim 'session'

      resurrect_dir="$HOME/.tmux/resurrect"
      set -g @resurrect-dir $resurrect_dir
      set -g @resurrect-hook-post-save-all "sed -i 's| --cmd .*-vim-pack-dir||g; s|/etc/profiles/per-user/$USER/bin/||g' $(readlink -f $resurrect_dir/last)"

    '';
  };
}
