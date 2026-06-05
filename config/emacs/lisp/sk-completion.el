;;; sk-completion.el --- Completion layers -*- lexical-binding: t; -*-

;; Layering:
;; - Vertico/Orderless/Marginalia/Embark/Consult for minibuffer completion.
;; - Corfu for in-buffer completion UI.
;; - CAPF sources are added per buffer class, not globally everywhere.

(use-package vertico
  :demand t
  :config
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
        corfu-auto-delay 0.12
        corfu-auto-prefix 2
        corfu-cycle t
        corfu-preview-current nil)
  (global-corfu-mode 1))

(use-package cape
  :after corfu
  :config
  (defun sk/capf-code-defaults ()
    "Add conservative fallback CAPFs for code/config buffers."
    (add-hook 'completion-at-point-functions #'cape-file 20 t)
    (add-hook 'completion-at-point-functions #'cape-dabbrev 40 t))

  (defun sk/capf-prose-defaults ()
    "Add only safe prose CAPFs."
    (add-hook 'completion-at-point-functions #'cape-file 20 t))

  (dolist (hook '(prog-mode-hook conf-mode-hook))
    (add-hook hook #'sk/capf-code-defaults))

  (dolist (hook '(org-mode-hook markdown-mode-hook text-mode-hook))
    (add-hook hook #'sk/capf-prose-defaults)))

(provide 'sk-completion)

;;; sk-completion.el ends here
