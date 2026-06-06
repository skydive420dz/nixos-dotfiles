;;; sk-lsp.el --- Language server client -*- lexical-binding: t; -*-

;; Start with Eglot because it is built into Emacs and keeps the clean config
;; smaller. Nix owns the external language-server executables.

(require 'seq)

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

(defconst sk/eglot-server-programs
  '((((qml-mode :language-id "qml")) . ("qmlls-wrapped"))
    (((json-mode :language-id "json")
      (json-ts-mode :language-id "json")
      (js-json-mode :language-id "json"))
     . ("vscode-json-language-server" "--stdio"))
    (((yaml-mode :language-id "yaml")
      (yaml-ts-mode :language-id "yaml"))
     . ("yaml-language-server" "--stdio"))
    (((glsl-mode :language-id "glsl")) . ("glsl_analyzer" "--stdio"))
    (((haskell-mode :language-id "haskell")) . ("haskell-language-server-wrapper" "--lsp"))
    (((python-mode :language-id "python")
      (python-ts-mode :language-id "python"))
     . ("basedpyright-langserver" "--stdio"))
    (((web-mode :language-id "html")
      (html-mode :language-id "html")
      (mhtml-mode :language-id "html"))
     . ("vscode-html-language-server" "--stdio"))
    ((css-mode css-ts-mode) . ("vscode-css-language-server" "--stdio"))
    (((js-mode :language-id "javascript")
      (typescript-mode :language-id "typescript"))
     . ("typescript-language-server" "--stdio"))
    (((markdown-mode :language-id "markdown")
      (org-mode :language-id "org")
      (text-mode :language-id "plaintext"))
     . ("harper-ls" "--stdio")))
  "Sky-specific Eglot server mappings, ordered from specific to broad.")

(defun sk/eglot-ensure ()
  "Start Eglot for supported buffers."
  (when (and (memq major-mode sk/eglot-managed-modes)
             (not (eglot-managed-p)))
    (condition-case err
        (progn
          (apply #'eglot (eglot--guess-contact))
          (when (fboundp 'sk/capf-code-defaults)
            (sk/capf-code-defaults)))
      (error
       (message "Eglot skipped for %s: %s"
                major-mode
                (error-message-string err))))))

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
  (dolist (server sk/eglot-server-programs)
    (setq eglot-server-programs
          (seq-remove (lambda (entry)
                        (equal (car entry) (car server)))
                      eglot-server-programs)))
  (setq eglot-server-programs
        (append sk/eglot-server-programs eglot-server-programs)))

(provide 'sk-lsp)

;;; sk-lsp.el ends here
