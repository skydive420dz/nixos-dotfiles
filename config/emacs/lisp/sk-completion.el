;;; sk-completion.el --- Completion layers -*- lexical-binding: t; -*-

;; Layering:
;; - Vertico/Orderless/Marginalia/Embark/Consult for minibuffer completion.
;; - Corfu for in-buffer completion UI.
;; - CAPF sources are added per buffer class, not globally everywhere.

(use-package vertico
  :demand t
  :config
  (define-key vertico-map (kbd "C-j") #'vertico-next)
  (define-key vertico-map (kbd "C-k") #'vertico-previous)
  (define-key vertico-map (kbd "C-l") #'vertico-exit)
  (vertico-mode 1))

(use-package orderless
  :demand t
  :config
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  :demand t
  :config
  (marginalia-mode 1))

(use-package consult
  :bind (("C-s" . consult-line)
         ("C-x b" . consult-buffer)
         ("M-y" . consult-yank-pop)))

(use-package embark
  :bind (("C-." . embark-act)
         ("C-;" . embark-dwim)))

(use-package embark-consult
  :after (embark consult))

(use-package corfu
  :demand t
  :config
  (setq corfu-auto t
        corfu-auto-delay 0.05
        corfu-auto-prefix 2
        corfu-cycle t
        corfu-preview-current nil)
  (define-key corfu-map (kbd "C-j") #'corfu-next)
  (define-key corfu-map (kbd "C-k") #'corfu-previous)
  (define-key corfu-map (kbd "C-l") #'corfu-insert)
  (define-key corfu-map (kbd "C-h") #'corfu-quit)
  (global-corfu-mode 1))

(defun sk/completion-active-p ()
  "Return non-nil when in-buffer completion is active."
  (bound-and-true-p completion-in-region-mode))

(defun sk/completion-next-or-window-down ()
  "Select the next completion candidate or move to the window below."
  (interactive)
  (if (sk/completion-active-p)
      (corfu-next)
    (evil-window-down)))

(defun sk/completion-previous-or-window-up ()
  "Select the previous completion candidate or move to the window above."
  (interactive)
  (if (sk/completion-active-p)
      (corfu-previous)
    (evil-window-up)))

(defun sk/completion-accept-or-window-right ()
  "Accept the current completion candidate or move to the right window."
  (interactive)
  (if (sk/completion-active-p)
      (corfu-insert)
    (evil-window-right)))

(defun sk/completion-quit-or-window-left ()
  "Quit completion or move to the left window."
  (interactive)
  (if (sk/completion-active-p)
      (corfu-quit)
    (evil-window-left)))

(use-package cape
  :after corfu
  :config
  (defun sk/capf-code-defaults ()
    "Add conservative fallback CAPFs for code/config buffers."
    (add-hook 'completion-at-point-functions #'cape-file 20 t)
    (add-hook 'completion-at-point-functions #'cape-dabbrev 40 t)
    (add-hook 'completion-at-point-functions #'cape-keyword 60 t))

  (defun sk/capf-prose-defaults ()
    "Add only safe prose CAPFs."
    (add-hook 'completion-at-point-functions #'cape-file 20 t))

  (dolist (hook '(prog-mode-hook conf-mode-hook))
    (add-hook hook #'sk/capf-code-defaults))

  (dolist (hook '(org-mode-hook markdown-mode-hook text-mode-hook))
    (add-hook hook #'sk/capf-prose-defaults)))

(provide 'sk-completion)

;;; sk-completion.el ends here
