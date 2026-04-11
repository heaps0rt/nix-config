{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "desktop";
  networking.networkmanager.enable = true;

  networking.nameservers = [ "127.0.0.1" ];
  services.resolved.enable = false;

  services.dnsmasq = {
    enable = true;
    settings = {
      no-resolv = true;
      server = [
        "1.1.1.1"
        "1.0.0.1"
        "8.8.8.8"
        "8.8.4.4"
      ];
      cache-size = 10000;
      domain-needed = true;
      bogus-priv = true;
      all-servers = true;
      min-cache-ttl = 300;
      max-cache-ttl = 86400;
    };
  };

  boot.kernel.sysctl = {
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr";
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  time.timeZone = "Europe/Oslo";
  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.heap = {
    isNormalUser = true;
    description = "Heap";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = [
      pkgs.kdePackages.kate
      pkgs.thunderbird
      pkgs.kdePackages.partitionmanager
    ];
    shell = pkgs.fish;
  };

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

programs.fish = {
  enable = true;
  interactiveShellInit = ''
    # Tomorrow Night Bright color scheme
    set -g fish_color_autosuggestion 969896
    set -g fish_color_cancel --reverse
    set -g fish_color_command c397d8
    set -g fish_color_comment e7c547
    set -g fish_color_cwd green
    set -g fish_color_cwd_root red
    set -g fish_color_end c397d8
    set -g fish_color_error d54e53
    set -g fish_color_escape 00a6b2
    set -g fish_color_history_current --bold
    set -g fish_color_host normal
    set -g fish_color_host_remote yellow
    set -g fish_color_normal normal
    set -g fish_color_operator 00a6b2
    set -g fish_color_param 7aa6da
    set -g fish_color_quote b9ca4a
    set -g fish_color_redirection 70c0b1
    set -g fish_color_search_match white --bold --background=brblack
    set -g fish_color_selection white --bold --background=brblack
    set -g fish_color_status red
    set -g fish_color_user brgreen
    set -g fish_color_valid_path --underline=single
    set -g fish_pager_color_completion normal
    set -g fish_pager_color_description B3A06D
    set -g fish_pager_color_prefix normal --bold --underline=single
    set -g fish_pager_color_progress brwhite --bold --background=cyan
    set -g fish_pager_color_selected_background --background=brblack
  '';
};
  programs.firefox.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = [ ];

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 53 24800 ];
  networking.firewall.allowedUDPPorts = [ 53 ];

  system.stateVersion = "25.11";
}
