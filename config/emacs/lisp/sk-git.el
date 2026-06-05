;;; sk-git.el --- Git tools -*- lexical-binding: t; -*-

(use-package magit
  :commands magit-status
  :bind (("C-c g" . magit-status))
  :config
  (with-eval-after-load 'evil
    (evil-define-key '(normal visual motion) magit-mode-map
      (kbd "q") #'magit-mode-bury-buffer
      (kbd "Q") #'magit-quit-session
      (kbd "]") #'magit-section-forward-sibling
      (kbd "[") #'magit-section-backward-sibling
      (kbd "gr") #'magit-refresh
      (kbd "gR") #'magit-refresh-all)
    (evil-define-key '(normal visual motion) magit-status-mode-map
      (kbd "gz") #'magit-refresh)
    (evil-define-key '(normal visual motion) magit-diff-mode-map
      (kbd "gd") #'magit-jump-to-diffstat-or-diff)
    (dolist (map (list magit-status-mode-map
                       magit-stash-mode-map
                       magit-revision-mode-map
                       magit-process-mode-map
                       magit-diff-mode-map))
      (evil-define-key '(normal visual motion) map
        (kbd "TAB") #'magit-section-toggle
        (kbd "<tab>") #'magit-section-toggle)))
  (add-hook 'magit-mode-hook
            (lambda ()
              (when (fboundp 'evil-local-set-key)
                (evil-local-set-key 'normal (kbd "TAB") #'magit-section-toggle)
                (evil-local-set-key 'normal (kbd "<tab>") #'magit-section-toggle)))))

(provide 'sk-git)

;;; sk-git.el ends here
