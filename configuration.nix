# NixOS configuration.

{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Use systemd-boot bootloader.
  boot.loader.systemd-boot.enable = true;

  # Allow modifying EFI boot variables.
  boot.loader.efi.canTouchEfiVariables = true;

  # Set the EFI system partition mount point.
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  fonts = let
    iosevka = [ "Iosevka" ];
  in {
    fonts = with pkgs; [
      (nerdfonts.override { fonts = iosevka; })
    ];

    fontconfig.defaultFonts = {
      serif = iosevka; sansSerif = iosevka; monospace = iosevka;
    };
  };

  # Use PulseAudio sound server.
  hardware.pulseaudio.enable = true;

  i18n.extraLocaleSettings = let
    ru = "ru_RU.UTF-8";
  in {
    LC_ADDRESS        = ru;
    LC_IDENTIFICATION = ru;
    LC_MEASUREMENT    = ru;
    LC_MONETARY       = ru;
    LC_NAME           = ru;
    LC_NUMERIC        = ru;
    LC_PAPER          = ru;
    LC_TELEPHONE      = ru;
    LC_TIME           = ru;
  };

  # Set the machine host name.
  networking.hostName = "laptop";

  # Use NetworkManager daemon.
  networking.networkmanager.enable = true;

  programs.bash.promptInit = ''
    if [ "$UID" -eq "0" ]; then
      PS1="\[\033[1;31m\][\[\e]0;\u@\h: \w\a\]\u@\h:\w]\\$\[\033[0m\] "
    else
      PS1="\[\033[1;32m\][\[\e]0;\u@\h: \w\a\]\u@\h:\w]\\$\[\033[0m\] "
    fi
  '';

  # Use dconf.
  programs.dconf.enable = true;

  # Use Neovim.
  programs.neovim.enable = true;

  # Create an alias for Vi.
  programs.neovim.viAlias = true;

  # Create an alias for Vim.
  programs.neovim.vimAlias = true;

  programs.neovim.configure = {
    customRC = "set expandtab shiftwidth=2";

    packages.myVimPackage = with pkgs.vimPlugins; {
      start = [ vim-nix ];
    };
  };

  # Use GVFS service.
  services.gvfs.enable = true;

  # Use TLP power manager.
  services.tlp.enable = true;

  services.xserver = {
    enable = true;

    # Set up keyboard layout and its options.
    layout = "us,ru"; xkbOptions = "grp:alt_shift_toggle";

    # Set up touchpad.
    libinput.enable = true;

    displayManager.lightdm = {
      enable = true;

      greeters.gtk = {
        clock-format = "%a %d %b %H:%M";

        # Show a session menu, a clock and a power menu.
        indicators = [ "~session" "~spacer" "~clock" "~spacer" "~power" ];

        # Use Iosevka font.
        extraConfig = "font-name=Iosevka 12";

        theme = {
          # Use Arc Dark theme.
          name = "Arc-Dark"; package = pkgs.arc-theme;
        };

        iconTheme = {
          # Use Papirus Dark icon theme.
          name = "Papirus-Dark"; package = pkgs.papirus-icon-theme;
        };

        cursorTheme = {
          # Use Bibata Original Classic cursor theme.
          name = "Bibata-Original-Classic"; package = pkgs.bibata-cursors;
        };
      };
    };

    # Use bspwm window manager.
    windowManager.bspwm.enable = true;
  };

  # Set the time zone.
  time.timeZone = "Europe/Moscow";

  users.users.sery = {
    isNormalUser = true;

    # Set the user full name.
    description = "Sergey Kirichenko";

    # Specify the user groups.
    extraGroups = [ "networkmanager" "wheel" ];
  };

  system.stateVersion = "22.11";
}
