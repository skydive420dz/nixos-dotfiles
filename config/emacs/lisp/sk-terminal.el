;;; sk-terminal.el --- Terminal integration -*- lexical-binding: t; -*-

(use-package vterm
  :commands vterm
  :init
  (setq vterm-module-cmake-args "-DUSE_SYSTEM_LIBVTERM=Off"
        vterm-always-compile-module t)
  :config
  (setq vterm-shell "/run/current-system/sw/bin/zsh"
        vterm-max-scrollback 10000)
  (add-hook 'vterm-mode-hook #'evil-insert-state)
  (define-key vterm-mode-map (kbd "C-h") #'evil-window-left)
  (define-key vterm-mode-map (kbd "C-j") #'evil-window-down)
  (define-key vterm-mode-map (kbd "C-k") #'evil-window-up)
  (define-key vterm-mode-map (kbd "C-l") #'evil-window-right))

(provide 'sk-terminal)

;;; sk-terminal.el ends here
