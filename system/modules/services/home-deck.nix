{ pkgs, ... }:

let
  homeDeck = pkgs.stdenvNoCC.mkDerivation {
    pname = "home-deck";
    version = "0.1.0";
    src = ../../../services/home-deck;

    installPhase = ''
      runHook preInstall
      mkdir -p "$out/share/home-deck"
      cp -R . "$out/share/home-deck/"
      runHook postInstall
    '';
  };

  path = with pkgs; [
    bash
    coreutils
    curl
    gawk
    gnused
    iputils
    netcat
    openssh
    procps
    python3
    systemd
  ];
in
{
  networking.firewall.allowedTCPPorts = [ 8088 ];

  systemd.tmpfiles.rules = [
    "d /var/lib/home-deck 0755 skydive420dz users - -"
  ];

  systemd.services.home-deck-status = {
    description = "Home Deck status collector";
    after = [
      "network-online.target"
      "ollama.service"
    ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    environment = {
      HOME = "/home/skydive420dz";
      HOME_DECK_STATE_DIR = "/var/lib/home-deck";
      HOME_DECK_OLLAMA_TAGS_URL = "http://127.0.0.1:11434/api/tags";
    };

    serviceConfig = {
      ExecStart = "${pkgs.python3}/bin/python3 ${homeDeck}/share/home-deck/status-updater.py";
      Restart = "always";
      RestartSec = "5s";
      User = "skydive420dz";
      WorkingDirectory = "${homeDeck}/share/home-deck";
    };

    path = path;
  };

  systemd.services.home-deck = {
    description = "Home Deck web dashboard";
    after = [
      "network-online.target"
      "home-deck-status.service"
      "ollama.service"
    ];
    wants = [
      "network-online.target"
      "home-deck-status.service"
    ];
    wantedBy = [ "multi-user.target" ];

    environment = {
      HOME_DECK_STATIC_DIR = "${homeDeck}/share/home-deck";
      HOME_DECK_STATE_DIR = "/var/lib/home-deck";
      HOME_DECK_OLLAMA_URL = "http://127.0.0.1:11434/api/generate";
      HOME_DECK_MODEL = "llama3.2:latest";
    };

    serviceConfig = {
      ExecStart = "${pkgs.python3}/bin/python3 ${homeDeck}/share/home-deck/deck-server.py";
      Restart = "always";
      RestartSec = "5s";
      User = "skydive420dz";
      WorkingDirectory = "${homeDeck}/share/home-deck";
    };
  };
}
