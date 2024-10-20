{
  environment.variables = {
    EDITOR = "nvim";
    SUDO_EDITOR = "nvim";
  };
  environment.sessionVariables = {
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
    # AQ_DRM_DEVICES = "/dev/dri/card1";
  };
}
