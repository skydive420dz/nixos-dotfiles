;;; sk-git.el --- Git tools -*- lexical-binding: t; -*-

(defvar sk/magit-localleader-map (make-sparse-keymap)
  "Magit commands preserved under the mode-local leader.")

(defun sk/magit-jump ()
  "Run the native Magit jump command for the current Magit buffer."
  (interactive)
  (if (derived-mode-p 'magit-diff-mode)
      (magit-jump-to-diffstat-or-diff)
    (magit-status-jump)))

(define-key sk/magit-localleader-map (kbd "h") #'magit-dispatch)
(define-key sk/magit-localleader-map (kbd "j") #'sk/magit-jump)
(define-key sk/magit-localleader-map (kbd "k") #'magit-delete-thing)
(define-key sk/magit-localleader-map (kbd "l") #'magit-log)
(define-key sk/magit-localleader-map (kbd "L") #'magit-log-refresh)

(use-package magit
  :commands magit-status
  :bind (("C-c g" . magit-status))
  :config
  (with-eval-after-load 'evil
    (evil-set-initial-state 'magit-status-mode 'normal)
    (evil-set-initial-state 'magit-diff-mode 'normal)
    (evil-set-initial-state 'magit-revision-mode 'normal)
    (evil-set-initial-state 'magit-process-mode 'normal)
    (evil-set-initial-state 'magit-stash-mode 'normal)
    (evil-define-key '(normal visual motion) magit-mode-map
      (kbd "h") #'magit-section-up
      (kbd "j") #'magit-section-forward
      (kbd "k") #'magit-section-backward
      (kbd "l") #'magit-section-toggle
      (kbd "q") #'magit-mode-bury-buffer
      (kbd "Q") #'magit-quit-session
      (kbd "]") #'magit-section-forward-sibling
      (kbd "[") #'magit-section-backward-sibling
      (kbd "gr") #'magit-refresh
      (kbd "gR") #'magit-refresh-all
      (kbd "SPC m") sk/magit-localleader-map)
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
                (evil-local-set-key 'normal (kbd "h") #'magit-section-up)
                (evil-local-set-key 'normal (kbd "j") #'magit-section-forward)
                (evil-local-set-key 'normal (kbd "k") #'magit-section-backward)
                (evil-local-set-key 'normal (kbd "l") #'magit-section-toggle)
                (evil-local-set-key 'normal (kbd "SPC m") sk/magit-localleader-map)
                (evil-local-set-key 'normal (kbd "TAB") #'magit-section-toggle)
                (evil-local-set-key 'normal (kbd "<tab>") #'magit-section-toggle))))

  (with-eval-after-load 'which-key
    (which-key-add-key-based-replacements
      "SPC m" "magit"
      "SPC m h" "dispatch"
      "SPC m j" "jump"
      "SPC m k" "delete thing"
      "SPC m l" "log"
      "SPC m L" "refresh log")))

(provide 'sk-git)

;;; sk-git.el ends here
