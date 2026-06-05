;;; sk-languages.el --- Language modes -*- lexical-binding: t; -*-

(use-package nix-mode
  :mode "\\.nix\\'")

(use-package lua-mode
  :mode "\\.lua\\'")

(use-package qml-mode
  :mode "\\.qml\\'")

(use-package rust-mode
  :mode "\\.rs\\'")

(use-package markdown-mode
  :mode "\\.md\\'")

(use-package yaml-mode
  :mode "\\.ya?ml\\'")

(use-package glsl-mode
  :mode "\\.glsl\\'")

(use-package yasnippet
  :config
  (yas-global-mode 1))

(provide 'sk-languages)

;;; sk-languages.el ends here
