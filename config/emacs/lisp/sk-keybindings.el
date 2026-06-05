;;; sk-keybindings.el --- Survival navigation layer -*- lexical-binding: t; -*-

;; This file is intentionally boring: it gives the clean config enough
;; Doom-like navigation to be testable without hiding behavior in a framework.

(require 'windmove)
(require 'winner)

(winner-mode 1)

(defun sk/new-empty-buffer ()
  "Create and switch to a new unnamed buffer."
  (interactive)
  (switch-to-buffer (generate-new-buffer "untitled")))

(defun sk/kill-current-buffer ()
  "Kill the current buffer without asking for a buffer name."
  (interactive)
  (kill-buffer (current-buffer)))

(defun sk/save-buffer-and-quit ()
  "Save the current file buffer, then quit this Emacs client/session."
  (interactive)
  (when (buffer-file-name)
    (save-buffer))
  (save-buffers-kill-terminal))

(defconst sk/reload-module-files
  '("sk-package"
    "sk-core"
    "sk-theme"
    "sk-ui"
    "sk-evil"
    "sk-completion"
    "sk-lsp"
    "sk-org"
    "sk-notes"
    "sk-dired"
    "sk-terminal"
    "sk-project"
    "sk-git"
    "sk-languages"
    "sk-keybindings")
  "Sky Emacs modules to reload with `sk/reload-config'.")

(defun sk/reload-config ()
  "Reload the clean Sky Emacs config modules."
  (interactive)
  (dolist (file sk/reload-module-files)
    (load (expand-file-name file sk/lisp-directory) nil 'nomessage))
  (message "Sky Emacs config reloaded"))

(defun sk/split-window-right-and-focus ()
  "Split the current window to the right and focus the new window."
  (interactive)
  (split-window-right)
  (windmove-right))

(defun sk/split-window-below-and-focus ()
  "Split the current window below and focus the new window."
  (interactive)
  (split-window-below)
  (windmove-down))

(defun sk/next-window ()
  "Move to the next window."
  (interactive)
  (other-window 1))

(defun sk/previous-window ()
  "Move to the previous window."
  (interactive)
  (other-window -1))

(defun sk/resize-window-left ()
  "Resize the current window left by shrinking width."
  (interactive)
  (shrink-window-horizontally 5))

(defun sk/resize-window-right ()
  "Resize the current window right by enlarging width."
  (interactive)
  (enlarge-window-horizontally 5))

(defun sk/resize-window-down ()
  "Resize the current window down by shrinking height."
  (interactive)
  (shrink-window 3))

(defun sk/resize-window-up ()
  "Resize the current window up by enlarging height."
  (interactive)
  (enlarge-window 3))

(defvar sk/leader-map (make-sparse-keymap)
  "Root keymap for Sky leader commands.")

(defvar sk/file-map (make-sparse-keymap)
  "File commands under `sk/leader-map'.")

(defvar sk/buffer-map (make-sparse-keymap)
  "Buffer commands under `sk/leader-map'.")

(defvar sk/window-map (make-sparse-keymap)
  "Window commands under `sk/leader-map'.")

(defvar sk/project-map (make-sparse-keymap)
  "Project commands under `sk/leader-map'.")

(defvar sk/search-map (make-sparse-keymap)
  "Search commands under `sk/leader-map'.")

(defvar sk/git-map (make-sparse-keymap)
  "Git commands under `sk/leader-map'.")

(defvar sk/notes-map (make-sparse-keymap)
  "Notes commands under `sk/leader-map'.")

(defvar sk/open-map (make-sparse-keymap)
  "Open/tool commands under `sk/leader-map'.")

(defvar sk/toggle-map (make-sparse-keymap)
  "Toggle commands under `sk/leader-map'.")

(defvar sk/tab-map (make-sparse-keymap)
  "Tab commands under `sk/leader-map'.")

(defvar sk/help-map (make-sparse-keymap)
  "Help commands under `sk/leader-map'.")

(defvar sk/help-reload-map (make-sparse-keymap)
  "Reload commands under `sk/help-map'.")

(defvar sk/quit-map (make-sparse-keymap)
  "Quit/session commands under `sk/leader-map'.")

(define-key sk/leader-map (kbd "SPC") #'execute-extended-command)
(define-key sk/leader-map (kbd ":") #'execute-extended-command)
(define-key sk/leader-map (kbd ".") #'find-file)
(define-key sk/leader-map (kbd "f") sk/file-map)
(define-key sk/leader-map (kbd "b") sk/buffer-map)
(define-key sk/leader-map (kbd "w") sk/window-map)
(define-key sk/leader-map (kbd "p") sk/project-map)
(define-key sk/leader-map (kbd "s") sk/search-map)
(define-key sk/leader-map (kbd "g") sk/git-map)
(define-key sk/leader-map (kbd "n") sk/notes-map)
(define-key sk/leader-map (kbd "o") sk/open-map)
(define-key sk/leader-map (kbd "t") sk/tab-map)
(define-key sk/leader-map (kbd "T") sk/toggle-map)
(define-key sk/leader-map (kbd "h") sk/help-map)
(define-key sk/leader-map (kbd "q") sk/quit-map)

(define-key sk/file-map (kbd "f") #'find-file)
(define-key sk/file-map (kbd "r") #'consult-recent-file)
(define-key sk/file-map (kbd "s") #'save-buffer)
(define-key sk/file-map (kbd "S") #'write-file)

(define-key sk/buffer-map (kbd "b") #'consult-buffer)
(define-key sk/buffer-map (kbd "i") #'ibuffer)
(define-key sk/buffer-map (kbd "k") #'sk/kill-current-buffer)
(define-key sk/buffer-map (kbd "N") #'sk/new-empty-buffer)

(define-key sk/window-map (kbd "v") #'sk/split-window-right-and-focus)
(define-key sk/window-map (kbd "s") #'sk/split-window-below-and-focus)
(define-key sk/window-map (kbd "w") #'sk/next-window)
(define-key sk/window-map (kbd "W") #'sk/previous-window)
(define-key sk/window-map (kbd "x") #'delete-window)
(define-key sk/window-map (kbd "o") #'delete-other-windows)
(define-key sk/window-map (kbd "=") #'balance-windows)
(define-key sk/window-map (kbd "u") #'winner-undo)
(define-key sk/window-map (kbd "U") #'winner-redo)
(define-key sk/window-map (kbd "h") #'windmove-left)
(define-key sk/window-map (kbd "j") #'windmove-down)
(define-key sk/window-map (kbd "k") #'windmove-up)
(define-key sk/window-map (kbd "l") #'windmove-right)
(define-key sk/window-map (kbd "H") #'sk/resize-window-left)
(define-key sk/window-map (kbd "J") #'sk/resize-window-down)
(define-key sk/window-map (kbd "K") #'sk/resize-window-up)
(define-key sk/window-map (kbd "L") #'sk/resize-window-right)

(define-key sk/project-map (kbd "f") #'project-find-file)
(define-key sk/project-map (kbd "p") #'project-switch-project)
(define-key sk/project-map (kbd "s") #'consult-ripgrep)
(define-key sk/project-map (kbd "b") #'consult-project-buffer)
(define-key sk/project-map (kbd "g") #'magit-status)
(define-key sk/project-map (kbd "t") #'sk/project-vterm)
(define-key sk/project-map (kbd "n") #'sk/project-notes)

(define-key sk/search-map (kbd "s") #'consult-line)
(define-key sk/search-map (kbd "p") #'consult-ripgrep)
(define-key sk/search-map (kbd "i") #'consult-imenu)
(define-key sk/search-map (kbd "I") #'consult-imenu-multi)

(define-key sk/git-map (kbd "g") #'magit-status)

(define-key sk/notes-map (kbd "i") #'sk/org-open-inbox)
(define-key sk/notes-map (kbd "d") #'sk/org-open-daily-note)
(define-key sk/notes-map (kbd "t") #'sk/org-open-topic-note)
(define-key sk/notes-map (kbd "p") #'sk/org-open-project-note)
(define-key sk/notes-map (kbd "c") #'org-capture)
(define-key sk/notes-map (kbd "a") #'org-agenda)

(define-key sk/open-map (kbd "d") #'dired)
(define-key sk/open-map (kbd "e") #'eshell)
(define-key sk/open-map (kbd "E") #'eshell-new)
(define-key sk/open-map (kbd "t") #'vterm)

(define-key sk/toggle-map (kbd "l") #'display-line-numbers-mode)
(define-key sk/toggle-map (kbd "w") #'visual-line-mode)

(define-key sk/tab-map (kbd "n") #'tab-new)
(define-key sk/tab-map (kbd "x") #'tab-close)
(define-key sk/tab-map (kbd "o") #'tab-close-other)
(define-key sk/tab-map (kbd "]") #'tab-next)
(define-key sk/tab-map (kbd "[") #'tab-previous)

(define-key sk/help-map (kbd "k") #'describe-key)
(define-key sk/help-map (kbd "f") #'describe-function)
(define-key sk/help-map (kbd "v") #'describe-variable)
(define-key sk/help-map (kbd "m") #'describe-mode)
(define-key sk/help-map (kbd "b") #'describe-bindings)
(define-key sk/help-map (kbd "r") sk/help-reload-map)

(define-key sk/help-reload-map (kbd "r") #'sk/reload-config)
(define-key sk/help-reload-map (kbd "t") #'sk/load-theme)

(define-key sk/quit-map (kbd "q") #'save-buffers-kill-terminal)
(define-key sk/quit-map (kbd "a") #'save-buffers-kill-emacs)
(define-key sk/quit-map (kbd "w") #'sk/save-buffer-and-quit)
(define-key sk/quit-map (kbd "f") #'kill-emacs)

(use-package which-key
  :demand t
  :config
  (setq which-key-idle-delay 0.35
        which-key-idle-secondary-delay 0.05
        which-key-sort-order #'which-key-key-order-alpha)
  (which-key-mode 1)
  (which-key-add-key-based-replacements
    "SPC f" "files"
    "SPC b" "buffers"
    "SPC b i" "buffer list"
    "SPC b k" "kill buffer"
    "SPC w" "windows"
    "SPC w w" "next window"
    "SPC w W" "previous window"
    "SPC w x" "close window"
    "SPC w o" "only window"
    "SPC w u" "undo window layout"
    "SPC w U" "redo window layout"
    "SPC p" "projects"
    "SPC s" "search"
    "SPC g" "git"
    "SPC n" "notes"
    "SPC o" "open"
    "SPC o e" "eshell"
    "SPC o E" "named eshell"
    "SPC o t" "vterm"
    "SPC t" "tabs"
    "SPC t n" "new tab"
    "SPC t x" "close tab"
    "SPC t o" "only tab"
    "SPC T" "toggles"
    "SPC h" "help"
    "SPC h r" "reload"
    "SPC h r r" "reload config"
    "SPC h r t" "reload theme"
    "SPC q" "quit"))

(with-eval-after-load 'evil
  (dolist (map (list evil-normal-state-map
                     evil-visual-state-map
                     evil-motion-state-map
                     evil-insert-state-map
                     evil-replace-state-map
                     evil-emacs-state-map))
    (define-key map (kbd "C-h") #'evil-window-left)
    (define-key map (kbd "C-j") #'evil-window-down)
    (define-key map (kbd "C-k") #'evil-window-up)
    (define-key map (kbd "C-l") #'evil-window-right))

  (dolist (map (list evil-normal-state-map
                     evil-visual-state-map
                     evil-motion-state-map))
    (define-key map (kbd "SPC") sk/leader-map))

  (dolist (map (list evil-normal-state-map
                     evil-motion-state-map))
    (define-key map (kbd "TAB") #'next-buffer)
    (define-key map (kbd "<tab>") #'next-buffer)
    (define-key map (kbd "<backtab>") #'previous-buffer)
    (define-key map (kbd "S-TAB") #'previous-buffer)))

(provide 'sk-keybindings)

;;; sk-keybindings.el ends here
