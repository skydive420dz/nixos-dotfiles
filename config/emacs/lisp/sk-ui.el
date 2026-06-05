;;; sk-ui.el --- UI settings -*- lexical-binding: t; -*-

(set-face-attribute 'default nil :family "JetBrainsMono Nerd Font" :height 160)

;; Keep MSI opaque by default. Transparency was measured as a real redraw cost.
(add-to-list 'default-frame-alist '(alpha . 100))
(add-to-list 'default-frame-alist '(alpha-background . 100))

(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)

(dolist (hook '(org-mode-hook
                markdown-mode-hook
                text-mode-hook
                dired-mode-hook
                vterm-mode-hook
                eshell-mode-hook
                help-mode-hook))
  (add-hook hook (lambda () (display-line-numbers-mode -1))))

(sk/load-theme)

(provide 'sk-ui)

;;; sk-ui.el ends here
