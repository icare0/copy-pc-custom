{ inputs, pkgs, ... }:
{
  home.stateVersion = "25.11";
  home.username = "icare";
  home.homeDirectory = "/home/icare";
  programs.home-manager.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;

    plugins = [
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprwinwrap
      # Magic Lamp via csgo-vulkan-fix ou hyprbars
    ];

    settings = {
      # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      # MONITEUR
      # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      monitor = ",preferred,auto,1";

      # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      # LOOK & FEEL — Le coeur du style
      # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      general = {
        gaps_in = 6;
        gaps_out = 14;
        border_size = 2;
        "col.active_border" = "rgba(ffffffcc) rgba(a0a0ffcc) 45deg";
        "col.inactive_border" = "rgba(ffffff18)";
        resize_on_border = true;
        layout = "dwindle";
      };

      decoration = {
        rounding = 14;           # Coins arrondis style macOS
        active_opacity = 1.0;
        inactive_opacity = 0.92; # Fenêtres inactives légèrement transparentes

        blur = {
          enabled = true;
          size = 8;
          passes = 4;
          xray = false;
          noise = 0.012;
          contrast = 1.1;
          brightness = 1.0;
          vibrancy = 0.25;       # Le truc qui rend macOS si beau
          popups = true;
        };

        shadow = {
          enabled = true;
          range = 30;
          render_power = 3;
          color = "rgba(00000066)";
          color_inactive = "rgba(00000033)";
          offset = "0 8";
        };
      };

      # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      # ANIMATIONS — Le vrai MacOS feeling
      # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      animations = {
        enabled = true;
        first_launch_animation = true;

        bezier = [
          "macOS, 0.25, 0.1, 0.25, 1.0"         # Standard macOS curve
          "spring, 0.68, -0.55, 0.265, 1.55"     # Effet bounce léger
          "easeOut, 0.0, 0.0, 0.2, 1.0"
          "overshot, 0.05, 0.9, 0.1, 1.05"
        ];

        animation = [
          "windows, 1, 4, spring, popin 80%"
          "windowsOut, 1, 4, easeOut, popin 80%"
          "windowsMove, 1, 3, macOS"
          "fade, 1, 4, macOS"
          "fadeOut, 1, 3, easeOut"
          "workspaces, 1, 4, macOS, slide"       # Slide entre workspaces
          "specialWorkspace, 1, 4, overshot, slidevert"
          "layers, 1, 3, macOS, slide"
          "layersOut, 1, 3, easeOut, fade"
        ];
      };

      # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      # LAYOUT
      # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      dwindle = {
        pseudotile = true;
        preserve_split = true;
        smart_split = true;
        smart_resizing = true;
      };

      # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      # INPUT
      # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      input = {
        kb_layout = "fr";         # Change selon toi
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;  # Comme macOS
          tap-to-click = true;
          drag_lock = true;
        };
        sensitivity = 0;
        accel_profile = "flat";
      };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 3;
        workspace_swipe_distance = 300;
        workspace_swipe_invert = true;
        workspace_swipe_min_speed_to_force = 30;
        workspace_swipe_cancel_ratio = 0.5;
        workspace_swipe_create_new = true;
      };

      # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      # MISC
      # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
        animate_manual_resizes = true;
        animate_mouse_windowdragging = true;
        enable_swallow = true;
        swallow_regex = "^(kitty|foot)$";
        focus_on_activate = true;
        vrr = 1;                   # Variable Refresh Rate si dispo
      };

      # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      # HYPREXPO — Mission Control
      # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      plugin.hyprexpo = {
        columns = 3;
        gap_size = 6;
        bg_col = "rgb(111111)";
        workspace_method = "center current";
        enable_gesture = true;
        gesture_fingers = 4;
        gesture_distance = 300;
        gesture_positive = false;
      };

      # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      # KEYBINDS
      # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      "$mod" = "SUPER";

      bind = [
        # Mission Control
        "$mod, grave, hyprexpo:expo, toggle"

        # Apps
        "$mod, Return, exec, kitty"
        "$mod, Space, exec, rofi -show drun"    # Spotlight
        "$mod, Q, killactive"
        "$mod, F, fullscreen, 0"
        "$mod, M, fullscreen, 1"                # Maximize sans fullscreen
        "$mod, V, togglefloating"

        # Workspaces
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"

        # Déplacer fenêtres
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        # Screenshot style macOS
        "$mod SHIFT, 3, exec, grim ~/Images/screenshot-$(date +%s).png"
        "$mod SHIFT, 4, exec, grim -g \"$(slurp)\" ~/Images/screenshot-$(date +%s).png"

        # EWW dashboard toggle
        "$mod, D, exec, eww open --toggle dashboard"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      # AUTOSTART
      # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      exec-once = [
        "swww-daemon"
        "swww img ~/Images/wallpaper.jpg --transition-type wipe --transition-angle 30"
        "eww daemon && eww open bar"
        "dunst"
        "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
      ];

      # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      # WINDOW RULES — Style macOS
      # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      windowrulev2 = [
        # Flou sur les apps qui le méritent
        "opacity 0.95 0.85, class:^(kitty)$"
        "opacity 0.98 0.90, class:^(firefox)$"

        # Fenêtres flottantes bien placées
        "float, class:^(pavucontrol)$"
        "size 600 400, class:^(pavucontrol)$"
        "center, class:^(pavucontrol)$"

        # Animations spéciales
        "animation popin, class:^(rofi)$"
        "animation slide, class:^(dunst)$"
      ];
    };
  };
}
