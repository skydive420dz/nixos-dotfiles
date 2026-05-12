{
  services.ollama = {
    enable = true;
    loadModels = [
      "llama3.2"
      "deepseek-r1:1.5b"
      "deepseek-r1:7b"
    ];
  };
}
