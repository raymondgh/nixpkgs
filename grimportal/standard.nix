{ config, pkgs, ... }:

{
  # Sets this file to be the resulting runtime configuration.nix
  environment.etc."nixos/configuration.nix".source = ../grimportal/standard.nix;

  # Declares the NixOS version
  system.stateVersion = "24.05";

  # Does some useful GCP GCE stuff
  imports = [
        <nixpkgs/nixos/modules/virtualisation/google-compute-image.nix>
      ];

  # Creates a super user for Ray to ssh in
  security.sudo.wheelNeedsPassword = false;
  users.extraUsers.ray = {
    isNormalUser = true;
    createHome = false;
    description = "ray's login";
    group = "users"; 
    extraGroups = [ "wheel" ];
    useDefaultShell = true;
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDB9HIXIRYfx0Q4xLoNK3MQMnrvQnTbld5i6xzh6aru74LHOP1tAKkEz/omzELQRf3EHPhrj0sDIzfDYqBmkfY9SGO5YRWG+qgngy/7doA0XGS78vWWMPBzQKJPN+xzV8Xe1ABrbwmdPpdvI2Xb2dhe/AxJpdb04twC9y4WpuKQROst2el7LmiZ0qbE0SicKbYxtRFIxj1myuU7KzW7VUxueyYlPjnswbR+jRikUsnJPa43lU3d9faxdPIJIyp7HIdjCCfwtPq2NxQMpBdTYbTw4E0acHslUp5o7pzM8IJWlPPxFEyUEjdJWlYjZtJa7T7vTQ4USNyWQKkN90AMj/XKLLMVZOicJuQCZPh1lVKwizg9mQTLHRSaUbDKPBv6KAGjToOKqRVe/rr07Ufj7A8eh/zsCvt7xEWgRsSJuRne9VXZfWgZOh1oDRo+1SSksyv/h3OtWISNVPwt5jQz2ZZedpwjxNmO8079KbSaJmG6yC9k9z9kVOh+J01SQYhnvlRsWSB7aKGwzuR4s+w0xd0p9PreGFJkNxPaiLTuDkWTb9U36pCkuTmb4dZILZPU8OhaljevKQi9b+ZMUMFnd3LYHb4Hgk7JSKGbbmJi5YfA19uG3ngT0JVkmE6ESbtJjdmJQTuZAOmAQps3uHgnraf+pTOaEAvsYrOuA+FPJqVBoQ== grimportal2024@gmail.com" ];
  };




  # Enshrouded testing below #
  nixpkgs.config.allowUnfree = true;
  programs.steam.enable = true;

  environment.systemPackages = with pkgs; [
    steam
    steamPackages.steamcmd
    wineWowPackages.stagingFull
  ];
  # Enshrouded testing above #


  # Set the system timezone
#   time.timeZone = "UTC";

  # Add your custom configurations here
#   environment.systemPackages = with pkgs; [
#     vim
#     htop
#   ];
}
