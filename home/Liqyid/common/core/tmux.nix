{ pkgs, ... }:
{

  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "wezterm";
    historyLimit = 100000;
    keyMode = "vi";
    prefix = "C-a";
    clock24 = true;
    catppuccin = {
      enable = true;
      extraConfig = ''

        set -g @catppuccin_flavor "mocha"

        set -g @catppuccin_status_left_separator  " "
        set -g @catppuccin_status_fill "icon"
        set -g @catppuccin_status_connect_separator "yes"

        set -g @catppuccin_directory_text "#{pane_current_path}"

        set -g @catppuccin_status_modules_right "application host user directory session"

      '';
    };
    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
      {
        plugin = resurrect;
        extraConfig = ''

          set -g @resurrect-capture-pane-contents 'on'
          set -g @resurrect-strategy-nvim 'session'
          set -g @resurrect-strategy-vim 'session'

          resurrect_dir="$HOME/.tmux/resurrect"
          set -g @resurrect-dir $resurrect_dir
          set -g @resurrect-hook-post-save-all "sed -i 's| --cmd .*-vim-pack-dir||g; s|/etc/profiles/per-user/$USER/bin/||g' $(readlink -f $resurrect_dir/last)"

        '';

      }
      {
        plugin = continuum;
        extraConfig = ''

          set -g @continuum-restore 'on'
          set -g @continuum-boot 'on'
          set -g @continuum-save-interval '10'

        '';

      }
    ];
    extraConfig = ''
      unbind C-b
      bind-key C-a send-prefix

      unbind r 
      bind r source-file ~/.config/tmux/tmux.conf

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

      set -g status-position top


    '';
  };
}
