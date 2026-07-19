{ repoPath }:

{
  btw = "echo I use nixos, btw";
  nfu = "nix flake update --flake ${repoPath}";
  nrb = "sudo nixos-rebuild boot --flake ${repoPath}#nixos";
  nrs = "sudo nixos-rebuild switch --flake ${repoPath}#nixos";
  vim = "nvim";
  ls = "ls --color=auto";
  ll = "ls -la --color=auto";
  cat = "bat";
  btop = "uwsm app -- ghostty --title=btop_float -e btop";
  nvtop = "uwsm app -- ghostty --title=nvtop_float -e nvtop";
  tm = "tmux-session main";
  tmd = "tmux-session dots";
  discord = "uwsm app -- vesktop --use-gl=desktop --enable-features=UseOzonePlatform --ozone-platform=wayland";
}
