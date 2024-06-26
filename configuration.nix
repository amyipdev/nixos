# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib,  pkgs, ... }:

let
  sources = import ./nix/sources.nix;
  lanzaboote = import sources.lanzaboote;
in
{ 
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    (import (builtins.fetchTarball https://github.com/nix-community/emacs-overlay/archive/master.tar.gz))
  ];
  
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      lanzaboote.nixosModules.lanzaboote
      <home-manager/nixos>
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.systemd-boot.memtest86.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };
  boot.plymouth.enable = true;
  boot.initrd.systemd.enable = true;
  boot.kernelParams = [ "quiet" "splash" ];

  networking.hostName = "clairo"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
  };
  #services.xserver.displayManager.sddm = {
  #  enable = true;
  #  wayland.enable = true;
  #};
  services.xserver.desktopManager.gnome.enable = true;
  services.dbus.enable = true;
  services.gvfs.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
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

  security.pam.services.hyprlock = {};

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.amy = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "Amy Parker";
    extraGroups = [ "networkmanager" "wheel" "wireshark" ];
  };
  environment.pathsToLink = [ "/share/zsh" ];
  home-manager.users.amy = { pkgs, ...}: {
    nixpkgs.config.allowUnfree = true;
    home.packages = with pkgs; [
      neofetch
      hyfetch
      hyprland
      kitty
      cinnamon.nemo
      wofi
      hyprpaper
      waybar
      swaynotificationcenter
      libnotify
      highlight
      btop
      discord
      keybase
      keybase-gui
      libreoffice
      gnupg
      signal-desktop
      slack
      grim
      slurp
      wl-clipboard
      rustup
      gcc
      autoconf
      gnumake
      automake
      cmake
      libtool
      tree
      inkscape-with-extensions
      wireshark
      nodejs_22
      degit
      fd
      ripgrep
      emacs
      doomretro
      php83
      terraform
      tailscale
      editorconfig-core-c
      sbcl
      #dart
      #flutter319
      #gfortran14
      fpm
      gopls
      gomodifytags
      gotests
      gore
      gotools
      nixfmt-rfc-style
      php83Packages.composer
      dune_3
      ocamlPackages.utop
      ocamlPackages.ocp-indent
      ocamlPackages.merlin
      shellcheck
      html-tidy
      stylelint
      jsbeautifier
      python312Packages.isort
      pipenv
      pipx
      python312Packages.pynose
      python312Packages.setuptools
      python312
      #ruby
      jdk22
      glslang
      contrast
      gdb
      git-crypt
      libressl
    ];
    programs.hyfetch = {
      enable = true;
      settings = {
        preset = "lesbian";
        mode = "rgb";
        light_dark = "dark";
        lightness = 0.59;
        color_align = {
          mode = "custom";
          custom_colors = {
            "2" = 0;
            "1" = 3;
          };
          fore_back = [];
        };
        backend = "neofetch";
        pride_month_disable = false;
      };
    };
    wayland.windowManager.hyprland = {
      enable = true;
      plugins = [ ];
      settings = {
        general = {
          gaps_in = 15;
          gaps_out = 50;
          border_size = 2;
          "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
          "col.inactive_border" = "rgba(595959aa)";
          layout = "dwindle";
          resize_on_border = false;
        };
        decoration = {
          rounding = 10;
          active_opacity = 1.0;
          inactive_opacity = 1.0;
          drop_shadow = true;
          shadow_range = 4;
          shadow_render_power = 3;
          "col.shadow" = "rgba(1a1a1aee)";
          blur = {
            enabled = true;
            size = 3;
            passes = 1;
            vibrancy = 0.1696;
          };
        };
        animations = {
          enabled = true;
          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
        };
        master = {
          new_is_master = true;
        };
        misc = {
          force_default_wallpaper = -1;
          disable_hyprland_logo = false;
        };
        input = {
          kb_layout = "us";
          follow_mouse = 1;
          sensitivity = 0;
          touchpad = {
            natural_scroll = false;
          };
        };
        gestures = {
          workspace_swipe = false;
        };
        exec = [
          "/home/amy/scripts/restart-waybar.sh"
        ];
        exec-once = [
          "swaync"
        ];
        bind = [
          ", Print, exec, /home/amy/scripts/screenshot.sh"
          "$mod, Q, exec, $terminal"
          "$mod, C, killactive,"
          "$mod, M, exit,"
          "$mod, E, exec, $fileManager"
          "$mod, V, togglefloating,"
          "$mod, R, exec, $menu"
          "$mod, P, pseudo,"
          "$mod, J, togglesplit,"
          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"
          "$mod SHIFT, 1, movetoworkspace, 1"
          "$mod SHIFT, 2, movetoworkspace, 2"
          "$mod SHIFT, 3, movetoworkspace, 3"
          "$mod SHIFT, 4, movetoworkspace, 4"
          "$mod SHIFT, 5, movetoworkspace, 5"
          "$mod SHIFT, 6, movetoworkspace, 6"
          "$mod SHIFT, 7, movetoworkspace, 7"
          "$mod SHIFT, 8, movetoworkspace, 8"
          "$mod SHIFT, 9, movetoworkspace, 9"
          "$mod SHIFT, 0, movetoworkspace, 10"
          "$mod, 1, workspace, 1"
          "$mod, 2, workspace, 2"
          "$mod, 3, workspace, 3"
          "$mod, 4, workspace, 4"
          "$mod, 5, workspace, 5"
          "$mod, 6, workspace, 6"
          "$mod, 7, workspace, 7"
          "$mod, 8, workspace, 8"
          "$mod, 9, workspace, 9"
          "$mod, 0, workspace, 10"
          "$mod, SPACE, exec, /home/amy/scripts/language-cycle.sh"
        ];
        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];
        windowrulev2 = [
          "suppressevent maximize, class:.*"
        ];

        "$terminal" = "kitty";
        "$fileManager" = "nemo";
        "$menu" = "wofi --show drun";
        "$mod" = "SUPER";
        monitor = [
          "DP-1,1920x1080,5490x880,1"
          "DP-3,1680x1050,0x910,1"
          "HDMI-A-1,3840x2160,1650x0,1"
        ];
      };
      systemd = {
        enable = true;
        enableXdgAutostart = true;
        variables = [ ];
      };
      xwayland.enable = true;
    };
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          after_sleep_cmd = "hyprctl dispatch dpms on";
          ignroe_dbus_inhibit = false;
          lock_cmd = "hyprlock";
        };
        listener = [
          {
            timeout = 900;
            on-timeout = "hyprlock";
          }
          {
            timeout = 1200;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };
    services.hyprpaper = {
      enable = true;
      settings = {
        ipc = "on";
        splash = false;
        preload = [ "/home/amy/Pictures/wallpapers/city.jpg" ];
        wallpaper = ["DP-1,/home/amy/Pictures/wallpapers/city.jpg" 
                     "DP-3,/home/amy/Pictures/wallpapers/city.jpg" 
                     "HDMI-A-1,/home/amy/Pictures/wallpapers/city.jpg"];
      };
    };
    programs.hyprlock = {
      enable = true;
      settings = { };
    };
    programs.kitty = {
      font = {
        package = null;
        name = "CaskaydiaCove Nerd Font";
        size = 10;
      };
      extraConfig = ''
        window_padding_width 12
      '';
      shellIntegration.enableZshIntegration = true;
      theme = "Everforest Dark Hard";
      enable = true;
    };
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      enableVteIntegration = true;
      antidote = {
        enable = true;
        plugins = [ "romkatv/powerlevel10k" ];
      };
      autocd = true;
      autosuggestion.enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "sudo" ];
      };
      prezto = {
        enable = true;
        color = true;
        editor.dotExpansion = true;
        syntaxHighlighting.highlighters = [ "main" "brackets" "pattern" "line" "cursor" "root" ];
        terminal.autoTitle = true;
      };
      shellAliases = {
        ll = "ls -lh";
        la = "ls -a";
        lla = "ls -lah";
        lal = "ls -lah";
        ".." = "cd ..";
        nix-build-local = "nix-build -E 'let pkgs = import <nixpkgs> { }; in pkgs.callPackage ./default.nix {}'";
      };
      initExtra = ''
        [[ ! -f /home/amy/.config/p10k.zsh ]] | source /home/amy/.config/p10k.zsh
      '';
      envExtra = ''
        export PATH="$PATH:/home/amy/.config/emacs/bin"
      '';
    };
    home.stateVersion = "23.11";
    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800;
      enableSshSupport = true;
      pinentryPackage = pkgs.pinentry-gtk2;
    };
    programs.git = {
      enable = true;
      userName = "Amy Parker";
      userEmail = "amy@amyip.net";
    };
    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          margin-left = 45;
          margin-right = 45;
          margin-top = 15;
          margin-bottom = 5;
          spacing = 24;
          layer = "top";
          position = "top";
          height = 30;
          output = [
            "HDMI-A-1"
          ];
          cpu = {
            interval = 1;
            format = "{}% ";
            max-length = 10;
          };
          memory = {
            interval = 1;
            format = "{}% ";
            max-length = 10;
          };
          load = {
            interval = 1;
            format = "{} avg";
            max-length = 10;
          };
          clock = {
            interval = 1;
            format = "{:%H:%M}";
            format-alt = "testing";
            actions = {
              on-click-right = "mode";
              on-click-forward = "tz_up";
              on-click-backward = "tz_down";
              on-scroll-up = "shift_up";
              on-scroll-down = "shift_down";
            };
          };
          modules-left = [ "hyprland/workspaces" ];
          modules-center = [ "hyprland/window" ];
          modules-right = [ "hyprland/language" "wireplumber" "cpu" "load" "memory" "clock" ];
        };
      };
      style = ''
        * {
          font-family: Caskaydia Cove Nerd Font Mono, sans-serif;
          font-size: 17px;
        }
        window#waybar {
          background-color: rgba(43, 43, 43, 0.65);
          border-radius: 15px;
          color: #ffffff;
          transition-property: background-color;
          transition-duration: 0.5s;
        }
        .modules-right { 
          padding-right: 15px;
        }
        .modules-left {
          padding-left: 15px;
        }
      '';
      #systemd.enable = true;
    };
    gtk = {
      enable = true;
      theme = {
        package = pkgs.omni-gtk-theme;
        name = "Omni";
      };
    };
    services.keybase.enable = true;
    services.kbfs.enable = true;
  };

  programs.firefox.enable = true;
  programs.zsh.enable = true;
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    sbctl
    niv
    nerdfonts
    hyprland
    killall
    dig
    inetutils
    python3
    stress-ng
  ];

  qt.platformTheme = "gtk2";

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

  services.pcscd.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
