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
                (evil-local-set-key 'normal (kbd "]]") #'org-next-visible-heading)
                (evil-local-set-key 'normal (kbd "[h") #'org-previous-visible-heading)
                (evil-local-set-key 'normal (kbd "]h") #'org-next-visible-heading)
                (evil-local-set-key 'normal (kbd "[s") #'org-backward-heading-same-level)
                (evil-local-set-key 'normal (kbd "]s") #'org-forward-heading-same-level)
                (evil-local-set-key 'normal (kbd "gh") #'outline-up-heading)
                (evil-local-set-key 'normal (kbd "gj") #'org-next-visible-heading)
                (evil-local-set-key 'normal (kbd "gk") #'org-previous-visible-heading)
                (evil-local-set-key 'normal (kbd "gl") #'org-goto)
                (evil-local-set-key 'normal (kbd "TAB") #'org-cycle)
                (evil-local-set-key 'normal (kbd "<tab>") #'org-cycle)
                (evil-local-set-key 'normal (kbd "<backtab>") #'org-shifttab)
                (evil-local-set-key 'normal (kbd "S-TAB") #'org-shifttab)
                (evil-local-set-key 'normal (kbd "za") #'org-cycle)
                (evil-local-set-key 'normal (kbd "zA") #'org-shifttab)
                (evil-local-set-key 'normal (kbd ">") #'org-demote-subtree)
                (evil-local-set-key 'normal (kbd "<") #'org-promote-subtree)
                (evil-local-set-key 'normal (kbd "M-j") #'org-metadown)
                (evil-local-set-key 'normal (kbd "M-k") #'org-metaup)))))

(provide 'sk-org)

;;; sk-org.el ends here
