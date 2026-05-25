#!/usr/bin/env python3
import json
import os
import urllib.error
import urllib.request
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer

STATIC_DIR = os.environ.get("HOME_DECK_STATIC_DIR", os.path.dirname(os.path.abspath(__file__)))
STATE_DIR = os.environ.get("HOME_DECK_STATE_DIR", STATIC_DIR)
OLLAMA_URL = os.environ.get("HOME_DECK_OLLAMA_URL", "http://127.0.0.1:11434/api/generate")
MODEL = os.environ.get("HOME_DECK_MODEL", "llama3.2:latest")


class DeckHandler(SimpleHTTPRequestHandler):
    def do_GET(self):
        if self.path.split("?", 1)[0] == "/status.json":
            self.serve_status()
            return
        return super().do_GET()

    def do_POST(self):
        if self.path != "/ask":
            self.send_error(404)
            return

        try:
            length = int(self.headers.get("Content-Length", "0"))
            body = self.rfile.read(length).decode("utf-8")
            payload = json.loads(body or "{}")
            prompt = (payload.get("prompt") or "").strip()
        except Exception:
            self.send_json({"response": "Bad request."}, status=400)
            return

        if not prompt:
            self.send_json({"response": "Type something first."}, status=400)
            return

        prompt = prompt[:1200]
        answer = self.ask(prompt)
        self.send_json({"response": answer})

    def ask(self, prompt):
        payload = {
            "model": MODEL,
            "prompt": prompt,
            "stream": False,
            "options": {
                "num_predict": 220,
                "temperature": 0.4,
            },
        }
        data = json.dumps(payload).encode("utf-8")
        request = urllib.request.Request(
            OLLAMA_URL,
            data=data,
            headers={"Content-Type": "application/json"},
            method="POST",
        )

        try:
            with urllib.request.urlopen(request, timeout=60) as response:
                result = json.loads(response.read().decode("utf-8"))
                return (result.get("response") or "").strip() or "No response."
        except urllib.error.URLError as exc:
            return "Ollama request failed: %s" % exc
        except Exception as exc:
            return "Ollama request failed: %s" % exc

    def serve_status(self):
        path = os.path.join(STATE_DIR, "status.json")
        try:
            with open(path, "rb") as f:
                data = f.read()
        except FileNotFoundError:
            data = b'{"updated":"never"}'

        self.send_response(200)
        self.send_header("Content-Type", "application/json")
        self.send_header("Cache-Control", "no-store")
        self.send_header("Content-Length", str(len(data)))
        self.end_headers()
        self.wfile.write(data)

    def send_json(self, payload, status=200):
        data = json.dumps(payload).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(data)))
        self.end_headers()
        self.wfile.write(data)


if __name__ == "__main__":
    os.chdir(STATIC_DIR)
    server = ThreadingHTTPServer(("0.0.0.0", 8088), DeckHandler)
    print("Serving Home Deck on http://0.0.0.0:8088/")
    server.serve_forever()
