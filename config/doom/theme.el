;;; theme.el -*- lexical-binding: t; -*-

(defconst sk/theme-default
  '((foreground . "#f0efeb")
    (background . "#1a1d21")
    (surface . "#22262b")
    (surface-strong . "#282c34")
    (border . "#3d424a")
    (border-active . "#b4c0c8")
    (accent . "#b4c0c8")
    (accent-alt . "#b4bcc4")
    (muted . "#676d77")
    (success . "#b8c4b8")
    (warning . "#d4ccb4")
    (danger . "#cdacac")
    (selection-foreground . "#1a1d21")
    (selection-background . "#b4c0c8")
    (string . "#b8c4b8")
    (function . "#b4c0c8")
    (keyword . "#b4bcc4")
    (number . "#d4ccb4")
    (type . "#d4ccb4")
    (builtin . "#b4c4bc")
    (preprocessor . "#ccc4b4")
    (comment . "#676d77"))
  "Theme tokens mirrored from the global Sky theme selector.")

(defvar sk/theme (copy-tree sk/theme-default)
  "Active Sky theme tokens.")

(defun sk/theme-runtime-file ()
  "Return the generated Sky theme file for this user session."
  (let ((config-home (or (getenv "XDG_CONFIG_HOME")
                         (expand-file-name "~/.config"))))
    (expand-file-name "theme/current/emacs-theme.el" config-home)))

(defun sk/reload-theme-tokens ()
  "Reload generated Sky theme tokens, falling back to the built-in dark palette."
  (setq sk/theme (copy-tree sk/theme-default))
  (let ((runtime-theme (sk/theme-runtime-file)))
    (when (file-readable-p runtime-theme)
      (load-file runtime-theme)))
  sk/theme)

(defun sk/theme-color (name)
  (alist-get name sk/theme))

(sk/reload-theme-tokens)

(provide 'theme)
