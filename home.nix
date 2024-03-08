{ pkgs, ... }: {

  home.packages = [ ];
  programs.bash.enable = true;
  programs.git.enable = true;
  #programs.nixvim.enable = true;
  programs.fzf.enable = true;
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true; # see note on other shells below
    nix-direnv.enable = true;
  };

  bash.enable = true;
  # The state version is required and should stay at the version you
  # originally installed.
  home.stateVersion = "23.11";
}
