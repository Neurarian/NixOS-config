{pkgs, ...}: {
  programs = {
    zsh = {
      enable = true;
      shellAliases = {
        update = "nix flake update";
        rebuild = "nh os switch --ask";
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
      plugins = [
        {
          # zsh vim motions for command line
          name = "vi-mode";
          src = pkgs.zsh-vi-mode;
          file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
        }
        {
          name = "fzf-tab";
          src = pkgs.zsh-fzf-tab;
          file = "share/fzf-tab/fzf-tab.plugin.zsh";
        }
      ];
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      initContent = ''
        fastfetch

        bindkey '^e' autosuggest-execute
        bindkey '^p' history-search-backward
        bindkey '^n' history-search-forward

        export KEYTIMEOUT=100

        setopt hist_ignore_space
        setopt hist_find_no_dups


        # ---- FZF -----
        eval "$(fzf --zsh)"

        export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

        _fzf_compgen_path() {
          fd --hidden --exclude .git . "$1"
        }

        _fzf_compgen_dir() {
          fd --type=d --hidden --exclude .git . "$1"
        }

        source "$(which fzf-git)"

        show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

        export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
        export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

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

        # ---- FZF-TAB -----
        zstyle ':completion:*' menu no
        zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
        zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always $realpath'
        zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

        # ---- Zoxide (better cd) ----
        eval "$(zoxide init zsh)"
      '';
      # loginExtra = ''[[ "$(tty)" == /dev/tty2 ]] && hyprwrapper '';
    };

    # zsh promt
    starship = {
      enable = true;
      enableZshIntegration = true;
      settings.format = "$all$nix_shell$nodejs$lua$golang$rust$php$git_branch$git_commit$git_state$git_status\n$username$hostname$directory";
    };

    # Better cat
    bat = {
      enable = true;
    };

    # Fuzzy find
    fzf = {
      enable = true;
      enableZshIntegration = true;
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

    # Better ls
    eza = {
      enable = true;
      enableZshIntegration = true;
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };

  catppuccin = {
    fzf.enable = true;
    starship.enable = true;
  };
}
