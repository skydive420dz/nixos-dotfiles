;;; sk-git.el --- Git tools -*- lexical-binding: t; -*-

(use-package magit
  :commands magit-status
  :bind (("C-c g" . magit-status)))

(provide 'sk-git)

;;; sk-git.el ends here
