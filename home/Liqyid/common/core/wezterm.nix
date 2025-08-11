{
  pkgs,
  inputs,
  ...
}: {
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    package = pkgs.wezterm;
    extraConfig = ''
      local config = {
        enable_wayland = true,
        font = wezterm.font 'JetBrainsMono NF',
        font_size = 10,
        color_scheme = 'Catppuccin Mocha',
        enable_kitty_graphics = true,
        term = 'wezterm',
        enable_tab_bar = false,
        window_padding = {
          left = 10,
          right = 10,
          top = 15,
          bottom = 0,
        },
        default_prog = {
          '${pkgs.zsh}/bin/zsh',
          '--login',
          '-c',
                [[
          if command -v tmux >/dev/null 2>&1; then
            tmux attach || tmux new;
          else
            exec zsh;
          fi
               ]],
          },
      }
      return config'';
  };
}
