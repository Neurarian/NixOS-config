{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "wezterm";
    historyLimit = 100000;
    keyMode = "vi";
    prefix = "C-a";
    clock24 = true;
    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavor "mocha"

          set -g @catppuccin_window_status_style "rounded"
          set -g @catppuccin_window_current_text " #{b:pane_current_path}"
          set -g @catppuccin_window_text " #{b:pane_current_path}"
          set -g @catppuccin_window_number_position "right"
          set -g @catppuccin_window_flags "icon"

          run-shell ${pkgs.tmuxPlugins.catppuccin}/share/tmux-plugins/catppuccin/catppuccin.tmux

          set -g status-right-length 100
          set -g status-right "#{E:@catppuccin_status_application}"
          set -ag status-right "#{E:@catppuccin_status_host}"
          set -ag status-right "#{E:@catppuccin_status_user}"
          set -ag status-right "#{E:@catppuccin_status_session}"
          set -g status-left ""

        '';
      }
      {
        plugin = resurrect;
        extraConfig = ''

          set -g @resurrect-strategy-nvim 'session'
          set -g @resurrect-strategy-vim 'session'
          set -g @resurrect-capture-pane-contents 'on'

          resurrect_dir="$HOME/.tmux/resurrect"
          set -g @resurrect-dir $resurrect_dir

          set -g @resurrect-processes '~e -> nvim'

          set -g @resurrect-hook-post-save-all 'target=$(readlink -f $resurrect_dir/last); sed "s|/home/Liqyid/.nix-profile/bin/e.*|e|g; s|/home/Liqyid/.nix-profile/bin/nvim.*|nvim|g" $target > tmp_file && mv tmp_file $target'

          run-shell ${pkgs.tmuxPlugins.resurrect}/share/tmux-plugins/resurrect/resurrect.tmux

        '';
      }
      {
        plugin = continuum;
        extraConfig = ''

          set -g @continuum-restore 'on'
          set -g @continuum-boot 'on'
          set -g @continuum-save-interval '10'

          run-shell ${pkgs.tmuxPlugins.continuum}/share/tmux-plugins/continuum/continuum.tmux

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
