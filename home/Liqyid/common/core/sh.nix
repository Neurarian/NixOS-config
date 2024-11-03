{ pkgs, ... }:
{

  programs = {
    zsh = {
      enable = true;
      shellAliases = {
        update = "nix flake update";
        rebuild = "nh os switch --ask && nh home switch --ask";
        upgrade = "cd ~/.dotfiles/NixOS-config && update && rebuild";
        ls = "eza --icons=always";
        cd = "z";
        c = "clear";

      };
      # Use OMZ for some plugin management
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "sudo"
          "pip"
          "docker"
        ];
      };
      # zsh vim motions for command line
      plugins = [
        {
          name = "vi-mode";
          src = pkgs.zsh-vi-mode;
          file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
        }
      ];
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      initExtra = ''
        fastfetch 
        bindkey '^y' autosuggest-accept
        bindkey '^e' autosuggest-execute

        # ---- FZF -----

        # Set up fzf key bindings and fuzzy completion
        eval "$(fzf --zsh)"

        export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

        # Use fd (https://github.com/sharkdp/fd) for listing path candidates.
        # - The first argument to the function ($1) is the base path to start traversal
        # - See the source code (completion.{bash,zsh}) for the details.
        _fzf_compgen_path() {
          fd --hidden --exclude .git . "$1"
        }

        # Use fd to generate the list for directory completion
        _fzf_compgen_dir() {
          fd --type=d --hidden --exclude .git . "$1"
        }

        source fzf-git

        show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

        export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
        export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

        # Advanced customization of fzf options via _fzf_comprun function
        # - The first argument to the function is the name of the command.
        # - You should make sure to pass the rest of the arguments to fzf.
        _fzf_comprun() {
          local command=$1
          shift

          case "$command" in
            cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
            export|unset) fzf --preview "eval 'echo \''${}'"         "$@" ;;
            ssh)          fzf --preview 'dig {}'                   "$@" ;;
            *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
          esac
        }

        # ---- Zoxide (better cd) ----
        eval "$(zoxide init zsh)"

        # thefuck alias
        eval $(thefuck --alias)
        eval $(thefuck --alias fk)
      '';
      # loginExtra = ''[[ "$(tty)" == /dev/tty2 ]] && hyprwrapper '';
    };

    # zsh promt 
    starship = {
      enable = true;
      enableZshIntegration = true;
      catppuccin.enable = true;
    };

    # Better cat
    bat = {
      enable = true;
    };

    # Fuzzy find
    fzf = {
      enable = true;
      enableZshIntegration = true;
      catppuccin.enable = true;
    };

    # Improved find
    fd = {
      enable = true;
    };

    # Improved cd
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    # Correct typos
    thefuck = {
      enable = true;
      enableZshIntegration = true;
    };

    # Better ls
    eza = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
