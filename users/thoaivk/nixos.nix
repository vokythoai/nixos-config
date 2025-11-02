{ pkgs, inputs, ... }:

{
  # https://github.com/nix-community/home-manager/pull/2408
  environment.pathsToLink = [ "/share/fish" ];

  # Add ~/.local/bin to PATH
  environment.localBinInPath = true;

  # Enable both fish and zsh shells
  programs.fish.enable = true;
  programs.zsh.enable = true;

  users.users.thoaivk = {
    isNormalUser = true;
    home = "/home/thoaivk";
    extraGroups = [ "docker" "lxd" "wheel" ];
    shell = pkgs.zsh;  # Using zsh for this profile
    # You can set an initial password with: mkpasswd -m sha-512
    # For now, you'll need to set the password after first login
    initialPassword = "changeme";
    openssh.authorizedKeys.keys = [
      # Add your SSH public key here
    ];
  };
}
