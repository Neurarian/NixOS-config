{ config, user, ... }:
{
  sops.secrets = {
    "tokens/github/loki" = {
      mode = "0440";
      owner = config.users.users.${user}.name;
    };
  };
  nix = {
    settings = {
      # Enable Flakes
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [ "${toString user}" ];
      extra-substituters = [
        "https://hyprland.cachix.org"
        "https://wezterm.cachix.org"
      ];
      extra-trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "wezterm.cachix.org-1:kAbhjYUC9qvblTE+s7S+kl5XM1zVa4skO+E/1IDWdH0="
      ];
    };
    extraOptions = ''
      !include ${config.sops.secrets."tokens/github/loki".path}
    '';
    # access-tokens = github.com=${config.sops.secrets."tokens/github/loki".key}
  };
}
