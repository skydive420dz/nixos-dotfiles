{
  networking.firewall.allowedTCPPorts = [ 11434 ];

  services.ollama = {
    enable = true;
    host = "0.0.0.0";
    port = 11434;
    loadModels = [
      "llama3.2"
      "deepseek-r1:1.5b"
      "deepseek-r1:7b"
    ];
  };
}
