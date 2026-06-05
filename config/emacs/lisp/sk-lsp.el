;;; sk-lsp.el --- Language server client -*- lexical-binding: t; -*-

;; Start with Eglot because it is built into Emacs and keeps the clean config
;; smaller. Nix owns the external language-server executables.

(use-package eglot
  :ensure nil
  :hook ((c-mode c++-mode rust-mode python-mode lua-mode nix-mode qml-mode js-mode typescript-mode web-mode sh-mode) . eglot-ensure)
  :config
  (setq eglot-autoshutdown t)
  (add-to-list 'eglot-server-programs '(qml-mode . ("qmlls-wrapped")))
  (add-to-list 'eglot-server-programs '(glsl-mode . ("glsl_analyzer" "--stdio"))))

(provide 'sk-lsp)

;;; sk-lsp.el ends here
