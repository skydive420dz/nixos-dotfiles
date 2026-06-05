;;; sk-org.el --- Org basics -*- lexical-binding: t; -*-

(use-package org
  :ensure nil
  :mode ("\\.org\\'" . org-mode)
  :config
  (setq org-startup-indented t
        org-hide-emphasis-markers t
        org-log-done 'time
        org-image-actual-width nil
        org-ellipsis "")
  (require 'org-tempo)
  (dolist (template '(("sh" . "src sh")
                      ("el" . "src emacs-lisp")
                      ("nix" . "src nix")
                      ("lua" . "src lua")
                      ("qml" . "src qml")
                      ("rs" . "src rust")
                      ("c" . "src c")
                      ("json" . "src json")
                      ("yaml" . "src yaml")))
    (setq org-structure-template-alist
          (assoc-delete-all (car template) org-structure-template-alist))
    (add-to-list 'org-structure-template-alist template))
  (add-hook 'org-mode-hook
            (lambda ()
              (when (fboundp 'evil-local-set-key)
                (evil-local-set-key 'normal (kbd "[[") #'org-previous-visible-heading)
                (evil-local-set-key 'normal (kbd "]]") #'org-next-visible-heading)))))

(provide 'sk-org)

;;; sk-org.el ends here
