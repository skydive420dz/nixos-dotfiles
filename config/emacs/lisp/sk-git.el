;;; sk-git.el --- Git tools -*- lexical-binding: t; -*-

(use-package magit
  :commands magit-status
  :bind (("C-c g" . magit-status))
  :config
  (setq magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1)
  (evil-collection-init 'magit)
  (evil-define-key '(normal motion) magit-mode-map
    (kbd "TAB") #'magit-section-toggle
    (kbd "<tab>") #'magit-section-toggle
    (kbd "S-TAB") #'magit-section-cycle-global
    (kbd "<backtab>") #'magit-section-cycle-global))

(provide 'sk-git)

;;; sk-git.el ends here
