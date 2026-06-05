;;; sk-theme.el --- Sky theme skeleton -*- lexical-binding: t; -*-

(deftheme sky-night "Sky Night theme for the clean Emacs experiment.")

(let ((bg "#1a1d21")
      (bg-alt "#22262b")
      (fg "#f0efeb")
      (fg-alt "#c8d0d8")
      (muted "#9aa1ac")
      (border "#3d424a")
      (accent "#b4c0c8")
      (string "#a8d8b0")
      (function "#8ecae6")
      (keyword "#c4a7e7")
      (number "#f2cc8f")
      (type "#94d2bd")
      (builtin "#b8e0d2")
      (warning "#e5989b"))
  (custom-theme-set-faces
   'sky-night
   `(default ((t (:background ,bg :foreground ,fg))))
   `(cursor ((t (:background ,accent))))
   `(fringe ((t (:background ,bg :foreground ,muted))))
   `(region ((t (:background ,accent :foreground ,bg))))
   `(mode-line ((t (:background ,bg-alt :foreground ,fg))))
   `(mode-line-inactive ((t (:background ,bg :foreground ,muted))))
   `(minibuffer-prompt ((t (:foreground ,accent :weight bold))))
   `(font-lock-comment-face ((t (:foreground ,muted :slant italic))))
   `(font-lock-string-face ((t (:foreground ,string))))
   `(font-lock-function-name-face ((t (:foreground ,function))))
   `(font-lock-keyword-face ((t (:foreground ,keyword :weight bold))))
   `(font-lock-constant-face ((t (:foreground ,number))))
   `(font-lock-type-face ((t (:foreground ,type))))
   `(font-lock-builtin-face ((t (:foreground ,builtin))))
   `(font-lock-warning-face ((t (:foreground ,warning :weight bold))))
   `(vertical-border ((t (:foreground ,border))))))

(provide-theme 'sky-night)

(defun sk/load-theme ()
  "Load the Sky Night theme."
  (interactive)
  (enable-theme 'sky-night))

(provide 'sk-theme)

;;; sk-theme.el ends here
