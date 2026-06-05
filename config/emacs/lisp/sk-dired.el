;;; sk-dired.el --- File management -*- lexical-binding: t; -*-

(use-package dired
  :ensure nil
  :config
  (setq dired-kill-when-opening-new-dired-buffer t
        dired-listing-switches "-alh --group-directories-first"
        delete-by-moving-to-trash t)
  (add-hook 'dired-mode-hook #'dired-hide-details-mode)
  (add-hook 'dired-mode-hook #'hl-line-mode)
  (add-hook 'dired-mode-hook
            (lambda ()
              (when (fboundp 'evil-local-set-key)
                (evil-local-set-key 'normal (kbd "h") #'dired-up-directory)
                (evil-local-set-key 'normal (kbd "l") #'dired-find-file)
                (evil-local-set-key 'normal (kbd "RET") #'dired-find-file)
                (evil-local-set-key 'normal (kbd "SPC m h") #'dired-omit-mode)))))

(provide 'sk-dired)

;;; sk-dired.el ends here
