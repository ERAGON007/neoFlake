{ config, pkgs, ...}:

{
  imports = [
    ./awesome_wm/awesome.nix
  ];

  home = {
    stateVersion = "22.11";
    homeDirectory = "/home/eragon";

    packages = with pkgs; [
      firefox                   # Browser
      kate                      # Editor
      cmus                      # Music player
      ghc
      haskell-language-server
      cabal-install             # Haskell package manager
      vmware-workstation        # Virtualization
      go                        # Golang compiler
      vscode                    # Editor
      tdesktop                  # Telegram desktop
      google-chrome             # Browser
      tmux                      # Terminal splitter
      youtube-dl                # Youtube Downloader
      obs-studio                # Recording & Streaming
      latte-dock                # Dock
      steam                     # Gaming
      protonvpn-gui             # VPN
      tuir                      # Console Reddit client
      vlc                       # Video & Audio player
      shutter                   # Screenshot
      bun                       # JS Runtime
      deno                      # JS Runtime
      #vivaldi
      ocs-url                   # Themes installer util
      tor                       # Tor utility
      torsocks                  # Torify processes
      sqlite                    # Sqlite DB
      sqliteman                 # Sqlite manager
      flameshot                 # Screenshot
      tor-browser-bundle-bin    # Tor browser GUI bundle by torproject.org
    ];

    pointerCursor = {
        name = "Dracula-cursors";
        package = pkgs.dracula-theme;
        size = 16;
      };
  };
  xsession = {
      enable = true;
      numlock.enable = true;
    };
  gtk = {
    enable = true;
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    font = {
      name = "FiraCode Nerd Font Mono Medium";
    };
  };

  home.file.".config/wall".source = config.lib.file.mkOutOfStoreSymlink ../modules/themes/wall;


  programs.alacritty = {
    enable = true;
  };

  programs.home-manager = {
    enable = true;
  };

  programs.git = {
    enable = true;

    userName = "ERAGON007";
    userEmail = "turk6486@gmail.com";
  };

}
