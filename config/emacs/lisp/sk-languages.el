;;; sk-languages.el --- Language modes -*- lexical-binding: t; -*-

(use-package nix-mode
  :mode "\\.nix\\'")

(use-package lua-mode
  :mode "\\.lua\\'")

(use-package qml-mode
  :mode "\\.qml\\'")

(use-package rust-mode
  :mode "\\.rs\\'")

(use-package haskell-mode
  :mode "\\.hs\\'")

(use-package typescript-mode
  :mode ("\\.ts\\'" "\\.tsx\\'"))

(use-package web-mode
  :mode "\\.html\\'")

(use-package json-mode
  :mode "\\.json\\'")

(use-package markdown-mode
  :mode "\\.md\\'")

(use-package yaml-mode
  :mode "\\.ya?ml\\'")

(use-package glsl-mode
  :mode "\\.glsl\\'")

(use-package yasnippet
  :config
  (define-key yas-minor-mode-map (kbd "TAB") #'yas-maybe-expand)
  (define-key yas-minor-mode-map (kbd "<tab>") #'yas-maybe-expand)
  (define-key yas-keymap (kbd "TAB") #'yas-next-field-or-maybe-expand)
  (define-key yas-keymap (kbd "<tab>") #'yas-next-field-or-maybe-expand)
  (define-key yas-keymap (kbd "<backtab>") #'yas-prev-field)
  (define-key yas-keymap (kbd "S-TAB") #'yas-prev-field)
  (yas-global-mode 1))

(provide 'sk-languages)

;;; sk-languages.el ends here
