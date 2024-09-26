{
  programs.git = {
    enable = true;
    userName = "Neurarian";
    userEmail = "110474238+Neurarian@users.noreply.github.com";
    aliases = {
      ci = "commit";
      co = "checkout";
      s = "status";
    };
  };
  programs.gh = {
    enable = true;
    settings = {
    git_protocol = "https";
    prompt = "enabled";
    aliases = {
      co = "pr checkout";
      pv = "pr view";
    };
    };
  };
}
