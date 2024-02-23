{ config, pkgs, ... }:

{
  # Enable the SSH daemon
#   services.openssh.enable = true;
  system.stateVersion = "24.05";

  # Set the system timezone
#   time.timeZone = "UTC";

  # Add your custom configurations here
#   environment.systemPackages = with pkgs; [
#     vim
#     htop
#   ];
}