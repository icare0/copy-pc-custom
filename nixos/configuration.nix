{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # BOOT
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # RÉSEAU
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  networking.hostName = "icare";
  networking.networkmanager.enable = true;

  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # LOCALISATION
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "fr_FR.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ALL = "fr_FR.UTF-8";
  };
  console.keyMap = "fr";
  services.xserver.xkb = {
    layout = "fr";
    variant = "";
  };

  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # BLUETOOTH
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # GESTION DU COUVERCLE (laptop)
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  services.logind.lidSwitch = "suspend";
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "suspend";
    LidSwitchIgnoreInhibited = "no";
  };

  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # AUDIO (PipeWire)
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # INPUT
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  services.libinput.enable = true;

  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # UTILISATEUR
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  users.users.icare = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
    initialPassword = "pass";
  };

  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # HYPRLAND (avec plugins via flake inputs)
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    # FIX: portalPackage doit aussi venir du flake pour éviter le mismatch de version
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
    xwayland.enable = true;
  };

  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # DISPLAY MANAGER — SDDM Catppuccin (inchangé)
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "catppuccin-mocha-mauve";
    package = pkgs.kdePackages.sddm;
  };

  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # XDG PORTALS (blur + screenshots + screenshare)
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  xdg.portal = {
    enable = true;
    extraPortals = [
      # FIX: xdg-desktop-portal-hyprland retiré ici — déjà géré via portalPackage ci-dessus
      pkgs.xdg-desktop-portal-gtk
    ];
    config.common.default = "*";
  };

  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # SERVICES FICHIERS
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # GPU INTEL
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      libvdpau-va-gl
    ];
  };

  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # VARIABLES D'ENVIRONNEMENT
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
    NIXOS_OZONE_WL = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
    # Nécessaire pour que certains toolkits utilisent Wayland nativement
    GDK_BACKEND = "wayland,x11";
    QT_QPA_PLATFORM = "wayland;xcb";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";
  };

  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # POLICES
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      inter                        # Police principale (macOS-like)
      nerd-fonts.jetbrains-mono    # Terminal + icônes
      noto-fonts
      noto-fonts-color-emoji
    ];
    fontconfig = {
      defaultFonts = {
        serif = [ "Inter" ];
        sansSerif = [ "Inter" ];
        monospace = [ "JetBrainsMono Nerd Font" ];
      };
      antialias = true;
      hinting.enable = true;
      subpixel.rgba = "rgb";
    };
  };

  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # HOME MANAGER (minimal, config Hyprland dans home.nix)
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 # home-manager.users.icare = { pkgs, ... }: {
  #  home.stateVersion = "25.11";
 #   home.username = "icare";
   # home.homeDirectory = "/home/icare";
  #  programs.home-manager.enable = true;
 # };

  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # STEAM + GAMING
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
  programs.gamemode.enable = true;  # Boost perf gaming

  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # PAQUETS SYSTÈME
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  environment.systemPackages = with pkgs; [
    # ── Outils de base ──────────────────────────────
    git vim wget curl unzip

    # ── Terminal ────────────────────────────────────
    kitty

    # ── Hyprland ecosystem ──────────────────────────
    swww                        # Wallpaper animé
    eww                         # Widgets macOS (remplace waybar)
    rofi                        # Launcher style Spotlight
    dunst                       # Notifications style macOS
    hyprlock                    # Écran de verrouillage
    hypridle                    # Gestion idle
    hyprpicker                  # Color picker
    nwg-dock-hyprland           # Dock style macOS

    # ── Waybar (gardé en backup si besoin) ──────────
    waybar

    # ── Screenshot & clipboard ──────────────────────
    grim
    slurp
    wl-clipboard
    cliphist

    # ── Fichiers & système ──────────────────────────
    xfce.thunar
    gvfs

    # ── Apparence ───────────────────────────────────
    nwg-look
    papirus-icon-theme
    whitesur-gtk-theme
    whitesur-icon-theme
    apple-cursor
    (catppuccin-sddm.override {
      flavor = "mocha";
      font = "Inter";
      fontSize = "14";
      background = "${./wallpaper.jpg}";
      loginBackground = true;
    })

    # ── Réseau & son ────────────────────────────────
    networkmanagerapplet
    pavucontrol
    blueman

    # ── Médias ──────────────────────────────────────
    vlc
    playerctl
    brightnessctl
    libnotify
    swaynotificationcenter

    # ── Apps ────────────────────────────────────────
    firefox
    brave
    discord
    spotify
    python3

    # ── Gaming ──────────────────────────────────────
    heroic
    mangohud
    protonup-qt

    # ── Misc ────────────────────────────────────────
    psmisc
    xdg-desktop-portal-gtk
    xdg-utils
  ];

  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # NIX
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # SYSTEM
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  system.stateVersion = "25.11";
}
