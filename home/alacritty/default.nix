{ config, pkgs, ... }:

{
  programs.alacritty = {
    enable = true;

    package = pkgs.alacritty;

    settings = {
      window.dimensions = {
        lines = 3;
        columns = 200;
      };
    };
  };

  #home.file.".config/alacritty/alacritty.yml".source = ./alacritty.yml;
}

