;;; sk-terminal.el --- Terminal integration -*- lexical-binding: t; -*-

(use-package vterm
  :commands vterm
  :init
  (setq vterm-module-cmake-args "-DUSE_SYSTEM_LIBVTERM=Off"
        vterm-always-compile-module t)
  :config
  (setq vterm-shell "/run/current-system/sw/bin/zsh"
        vterm-max-scrollback 10000)
  (sk/load-theme)
  (add-hook 'vterm-mode-hook #'evil-insert-state)
  (define-key vterm-mode-map (kbd "C-h") #'evil-window-left)
  (define-key vterm-mode-map (kbd "C-j") #'evil-window-down)
  (define-key vterm-mode-map (kbd "C-k") #'evil-window-up)
  (define-key vterm-mode-map (kbd "C-l") #'evil-window-right))

(defun eshell-new (name)
  "Create a new eshell buffer named NAME."
  (interactive "sName: ")
  (let ((name (concat "$" name)))
    (eshell)
    (rename-buffer name)))

(use-package eshell-syntax-highlighting
  :after esh-mode
  :config
  (eshell-syntax-highlighting-global-mode 1))

(use-package eshell
  :ensure nil
  :config
  (let ((eshell-directory (expand-file-name "eshell/" user-emacs-directory)))
    (make-directory eshell-directory t)
    (setq eshell-rc-script (expand-file-name "profile" eshell-directory)
          eshell-aliases-file (expand-file-name "aliases" eshell-directory)))
  (setq eshell-history-size 5000
        eshell-buffer-maximum-lines 5000
        eshell-hist-ignoredups t
        eshell-scroll-to-bottom-on-input t
        eshell-destroy-buffer-when-process-dies t
        eshell-visual-commands '("bash" "fish" "ssh" "top" "zsh")))

(with-eval-after-load 'corfu
  (add-hook 'eshell-mode-hook (lambda () (corfu-mode -1))))

(provide 'sk-terminal)

;;; sk-terminal.el ends here
