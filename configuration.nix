# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix = {
    settings = {
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
  ];
  # Flatpak applications can find fonts with this
  fonts.fontDir.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Add ntfs support to enable loading of windows created partitions.
  boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = "EragonNixOS"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Tehran";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  #services.xserver.enable = true;

  programs.dconf.enable = true;

  services.xserver = {
    enable = true;

    displayManager = {
      sddm.enable = true;
      defaultSession = "none+awesome";
    };

    windowManager = {
      awesome = {
        enable = true;
        luaModules = with pkgs.luaPackages; [
          luarocks # Package manager for lua modules
          luadbi-mysql # Database abstraction layer
        ];
      };
    };
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Don't require password using sudo
  security = {
    sudo.wheelNeedsPassword = false;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [ "git" "thefuck" ];
      theme = "jonathan";
    };
  };
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.eragon = {
    isNormalUser = true;
    description = "MohammadReza Najafi";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      #zsh
      #firefox
      #kate
      # git
      #cmus
      # ghc
      # haskell-language-server
      # cabal-install
      # vmware-workstation
      # go
      # vscode
      # tdesktop # Telegram desktop
      # google-chrome
      # tmux
      # youtube-dl
      # obs-studio
      # latte-dock
      # steam
      # protonvpn-gui
      # tuir # Console Reddit client
      # vlc
      # shutter # Screenshot
      # #bun # JS Runtime
      # deno
      # #vivaldi
      # ocs-url
      # tor
      # torsocks
      # sqlite
      # sqliteman
      # flameshot
    ];
  };

  # Enable flatpak
  services.flatpak.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "eragon";

  # Allow OpenGL 32-bit support (for wine,.....)
  hardware.opengl.driSupport32Bit = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
   tetrd # Tethering with USB
   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
   unzip
   wget
   neocomp # compton fork, compositor for X11
   git
  ];

  environment = {
    variables = {
      TERMINAL = "alacritty";
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };

  ############# GPU Setups ############# [AMD]
  hardware.opengl.extraPackages = [
    pkgs.amdvlk
  ];

  # To enable Vulkan support for 32-bit applications, also add:
  hardware.opengl.extraPackages32 = [
    pkgs.driversi686Linux.amdvlk
  ];

  # Force radv
  environment.variables.AMD_VULKAN_ICD = "RADV";
  # Or
  #environment.variables.VK_ICD_FILENAMES =
  #  "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";
  ############# GPU Setups #############

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
       
