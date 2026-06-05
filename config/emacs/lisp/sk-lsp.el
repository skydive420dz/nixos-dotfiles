;;; sk-lsp.el --- Language server client -*- lexical-binding: t; -*-

;; Start with Eglot because it is built into Emacs and keeps the clean config
;; smaller. Nix owns the external language-server executables.

(defconst sk/eglot-managed-modes
  '(c-mode c++-mode c-ts-mode c++-ts-mode
    rust-mode rust-ts-mode
    python-mode python-ts-mode
    lua-mode
    nix-mode
    qml-mode
    js-mode typescript-mode
    web-mode html-mode mhtml-mode css-mode css-ts-mode
    sh-mode bash-ts-mode
    glsl-mode
    haskell-mode
    yaml-mode yaml-ts-mode
    json-mode json-ts-mode
    markdown-mode org-mode text-mode)
  "Major modes that should start Eglot when their server is available.")

(defun sk/eglot-ensure ()
  "Start Eglot for supported buffers."
  (when (memq major-mode sk/eglot-managed-modes)
    (eglot-ensure)))

(use-package eglot
  :ensure nil
  :hook ((c-mode c++-mode c-ts-mode c++-ts-mode
          rust-mode rust-ts-mode
          python-mode python-ts-mode
          lua-mode
          nix-mode
          qml-mode
          js-mode typescript-mode
          web-mode html-mode mhtml-mode css-mode css-ts-mode
          sh-mode bash-ts-mode
          glsl-mode
          haskell-mode
          yaml-mode yaml-ts-mode
          json-mode json-ts-mode
          markdown-mode org-mode text-mode) . sk/eglot-ensure)
  :config
  (setq eglot-autoshutdown t
        eglot-workspace-configuration
        '(:nil (:nix (:flake (:autoArchive t)))))
  (dolist (server
           '(((python-mode python-ts-mode) . ("basedpyright-langserver" "--stdio"))
             (qml-mode . ("qmlls-wrapped"))
             (glsl-mode . ("glsl_analyzer" "--stdio"))
             (haskell-mode . ("haskell-language-server-wrapper" "--lsp"))
             ((yaml-mode yaml-ts-mode) . ("yaml-language-server" "--stdio"))
             ((json-mode json-ts-mode js-json-mode) . ("vscode-json-language-server" "--stdio"))
             (((js-mode :language-id "javascript")
               (typescript-mode :language-id "typescript"))
              . ("typescript-language-server" "--stdio"))
             (((web-mode :language-id "html")
               (html-mode :language-id "html")
               (mhtml-mode :language-id "html"))
              . ("vscode-html-language-server" "--stdio"))
             ((css-mode css-ts-mode) . ("vscode-css-language-server" "--stdio"))
             (((markdown-mode :language-id "markdown")
               (org-mode :language-id "org")
               (text-mode :language-id "plaintext"))
              . ("harper-ls" "--stdio"))))
    (add-to-list 'eglot-server-programs server)))

(provide 'sk-lsp)

;;; sk-lsp.el ends here
