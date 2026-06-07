;;; sk-docs.el --- Documentation helpers -*- lexical-binding: t; -*-

(require 'thingatpt)
(require 'use-package)

(defun sk/devdocs-lookup (&optional ask-docs)
  "Look up the symbol at point in DevDocs.

With prefix ASK-DOCS, let DevDocs prompt for docsets first.  DevDocs docset
selection stays package-owned so the config does not carry guessed mappings for
languages whose upstream docset names change."
  (interactive "P")
  (require 'devdocs)
  (let ((query (or (thing-at-point 'symbol t) "")))
    (devdocs-lookup ask-docs query)))

(defun sk/devdocs-install ()
  "Install a DevDocs docset."
  (interactive)
  (require 'devdocs)
  (call-interactively #'devdocs-install))

(defun sk/devdocs-update-all ()
  "Update installed DevDocs docsets."
  (interactive)
  (require 'devdocs)
  (call-interactively #'devdocs-update-all))

(use-package devdocs
  :commands (devdocs-lookup devdocs-install devdocs-update-all devdocs-delete)
  :init
  (add-to-list
   'display-buffer-alist
   '("\\*devdocs\\*"
     display-buffer-in-side-window
     (side . right)
     (slot . 3)
     (window-width . 0.42)
     (window-parameters . ((no-delete-other-windows . t)))
     (dedicated . t)))
  :config
  (add-hook 'devdocs-mode-hook #'visual-line-mode))

(provide 'sk-docs)

;;; sk-docs.el ends here
