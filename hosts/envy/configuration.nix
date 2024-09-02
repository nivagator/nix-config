{ config, lib, pkgs, inputs,  ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
    ];

  # boot loader
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.devices = [ "nodev" ];
  # boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.efiSupport = true;
  #  boot.loader.grub.useOSProber = true;

  networking.hostName = "envy"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # window interactions screen sharing etc
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  
  environment.sessionVariables = {
    # if your cursor becomes invisible
    WLR_NO_HARDWARE_CURSORS = "1";
    # hint electron apps to use wayland
    NIXOS_OZONE_WL = "1";
  };

  fonts.packages = with pkgs; [
    nerdfonts
    font-awesome
    source-code-pro
  ];

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  users.users.gavin = {
    isNormalUser = true;
    initialPassword = "pw123";
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      firefox
      brave
      tree
      duf
      ncdu
      fastfetch
      xfce.thunar
      dolphin
    ];
  };

  home-manager = {
    # also pass inputs to home-manager modules
    extraSpecialArgs = {inherit inputs;};
    users = {
      "gavin" = import ./home.nix;
    };
  };

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    killall
    dunst
    libnotify
    swww
    kitty
    alacritty
    rofi-wayland
    wev
    networkmanagerapplet
    (waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      })
    )
    cryptsetup
    gnupg1
    bluez
    blueman
    usbutils
    zip
    unzip
    just
    lm_sensors
    pinentry-all
  ];
  

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  
  # https://discourse.nixos.org/t/cant-get-gnupg-to-work-no-pinentry/15373/2
  services.pcscd.enable = true;
  programs.gnupg.agent = {
     enable = true;
     #pinentryPackage = "pkgs.pinentry-gtk2";
     enableSSHSupport = true;
  }; 
  
  system.stateVersion = "24.05"; # Did you read the comment?
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

}

