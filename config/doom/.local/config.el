;;; config.el -*- lexical-binding: t; -*-

(setq user-full-name "skydive420dz"
      user-mail-address "")

(load-file (expand-file-name "theme.el" doom-user-dir))

(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 16)
      doom-variable-pitch-font (font-spec :family "Inter" :size 16)
      doom-theme 'doom-nord
      display-line-numbers-type 'relative)

(add-to-list 'default-frame-alist '(alpha-background . 92))
(add-to-list 'default-frame-alist '(alpha . 92))
(set-frame-parameter nil 'alpha-background 92)
(set-frame-parameter nil 'alpha 92)
(setq frame-resize-pixelwise t)

(setq fancy-splash-image (expand-file-name "assets/emacs-logo.png" doom-user-dir))

(setq-default indent-tabs-mode nil
              tab-width 2)
(setq standard-indent 2)
(electric-indent-mode 1)

(setq-default c-basic-offset 2
              css-indent-offset 2
              js-indent-level 2
              sh-basic-offset 2)

(after! lua-mode
  (setq lua-indent-level 2))

(after! qml-mode
  (setq qml-indent-level 2))

(after! rust-mode
  (setq rust-indent-offset 2))

(setq ispell-dictionary "en_US"
      ispell-local-dictionary "en_US"
      ispell-program-name "aspell"
      ispell-personal-dictionary (expand-file-name "spell/en_US.pws" doom-user-dir)
      ispell-extra-args '("--sug-mode=ultra"))

(defun sk/disable-line-numbers ()
  (display-line-numbers-mode -1))

(after! evil-snipe
  (evil-snipe-mode -1)
  (evil-snipe-override-mode -1))

(after! evil
  (define-key evil-normal-state-map (kbd "s") #'evil-substitute)
  (define-key evil-normal-state-map (kbd "S") #'evil-change-whole-line))

(after! evil-org
  (map! :map evil-org-mode-map
        :n "[[" #'org-previous-visible-heading
        :n "]]" #'org-next-visible-heading))

(map! :n "C-h" #'evil-window-left
      :n "C-j" #'evil-window-down
      :n "C-k" #'evil-window-up
      :n "C-l" #'evil-window-right)

(after! vterm
  (map! :map vterm-mode-map
        :i "C-h" #'evil-window-left
        :i "C-j" #'evil-window-down
        :i "C-k" #'evil-window-up
        :i "C-l" #'evil-window-right))

(use-package! flycheck-inline
  :after flycheck
  :hook (flycheck-mode . flycheck-inline-mode)
  :config
  (setq flycheck-inline-display-function
        #'flycheck-inline-display-inline))

(after! doom-modeline
  (setq doom-modeline-height 28
        doom-modeline-bar-width 4
        doom-modeline-window-width-limit 80
        doom-modeline-buffer-file-name-style 'relative-to-project
        doom-modeline-major-mode-icon t
        doom-modeline-major-mode-color-icon t
        doom-modeline-buffer-state-icon t
        doom-modeline-vcs-max-length 24
        doom-modeline-modal-icon nil
        doom-modeline-enable-word-count nil)
  (custom-set-faces!
    `(mode-line :background ,(sk/theme-color 'surface)
                :foreground ,(sk/theme-color 'foreground)
                :box nil)
    `(mode-line-inactive :background ,(sk/theme-color 'background)
                         :foreground ,(sk/theme-color 'muted)
                         :box nil)
    `(doom-modeline-bar :background ,(sk/theme-color 'accent))
    `(doom-modeline-bar-inactive :background ,(sk/theme-color 'border))
    `(doom-modeline-buffer-file :foreground ,(sk/theme-color 'foreground)
                                :weight medium)
    `(doom-modeline-buffer-modified :foreground ,(sk/theme-color 'warning)
                                    :weight bold)
    `(doom-modeline-info :foreground ,(sk/theme-color 'success))
    `(doom-modeline-warning :foreground ,(sk/theme-color 'warning))
    `(doom-modeline-urgent :foreground ,(sk/theme-color 'danger))))

(custom-set-faces!
  `(font-lock-keyword-face :foreground ,(sk/theme-color 'keyword) :weight bold)
  `(font-lock-function-name-face :foreground ,(sk/theme-color 'function))
  `(font-lock-variable-name-face :foreground ,(sk/theme-color 'accent-alt))
  `(font-lock-string-face :foreground ,(sk/theme-color 'string))
  `(font-lock-doc-face :foreground ,(sk/theme-color 'string))
  `(font-lock-comment-face :foreground ,(sk/theme-color 'comment) :slant italic)
  `(font-lock-constant-face :foreground ,(sk/theme-color 'number))
  `(font-lock-builtin-face :foreground ,(sk/theme-color 'builtin) :weight medium)
  `(font-lock-type-face :foreground ,(sk/theme-color 'type))
  `(font-lock-preprocessor-face :foreground ,(sk/theme-color 'preprocessor))
  `(font-lock-warning-face :foreground ,(sk/theme-color 'danger) :weight bold)
  `(shadow :foreground ,(sk/theme-color 'muted))
  `(line-number :foreground ,(sk/theme-color 'muted))
  `(line-number-current-line :foreground ,(sk/theme-color 'accent) :weight bold)
  `(region :foreground ,(sk/theme-color 'selection-foreground)
           :background ,(sk/theme-color 'selection-background)))

(when (facep 'font-lock-number-face)
  (custom-set-faces!
    `(font-lock-number-face :foreground ,(sk/theme-color 'number))))

(after! evil-goggles
  (setq evil-goggles-duration 0.18
        evil-goggles-pulse nil)
  (custom-set-faces!
    `(evil-goggles-default-face :background ,(sk/theme-color 'surface-strong)
                                :foreground ,(sk/theme-color 'foreground)
                                :weight bold)
    `(evil-goggles-yank-face :background ,(sk/theme-color 'accent)
                             :foreground ,(sk/theme-color 'selection-foreground)
                             :weight bold)
    `(evil-goggles-paste-face :background ,(sk/theme-color 'success)
                              :foreground ,(sk/theme-color 'selection-foreground)
                              :weight bold)
    `(evil-goggles-delete-face :background ,(sk/theme-color 'danger)
                               :foreground ,(sk/theme-color 'selection-foreground)
                               :weight bold)
    `(evil-goggles-change-face :background ,(sk/theme-color 'warning)
                               :foreground ,(sk/theme-color 'selection-foreground)
                               :weight bold)
    `(evil-goggles-indent-face :background ,(sk/theme-color 'accent-alt)
                               :foreground ,(sk/theme-color 'selection-foreground)
                               :weight bold)
    `(evil-goggles-join-face :background ,(sk/theme-color 'builtin)
                             :foreground ,(sk/theme-color 'selection-foreground)
                             :weight bold)))

(after! avy
  (custom-set-faces!
    `(avy-background-face :foreground ,(sk/theme-color 'muted))
    `(avy-lead-face :background ,(sk/theme-color 'accent)
                    :foreground ,(sk/theme-color 'selection-foreground)
                    :weight bold)
    `(avy-lead-face-0 :background ,(sk/theme-color 'warning)
                      :foreground ,(sk/theme-color 'selection-foreground)
                      :weight bold)
    `(avy-lead-face-1 :background ,(sk/theme-color 'success)
                      :foreground ,(sk/theme-color 'selection-foreground)
                      :weight bold)
    `(avy-lead-face-2 :background ,(sk/theme-color 'danger)
                      :foreground ,(sk/theme-color 'selection-foreground)
                      :weight bold)))

(setq org-directory (expand-file-name "org" doom-user-dir)
      org-agenda-files (list org-directory)
      org-default-notes-file (expand-file-name "inbox.org" org-directory)
      org-startup-indented t
      org-hide-emphasis-markers t
      org-log-done 'time
      org-image-actual-width nil)

(setq org-capture-templates
      '(("t" "Todo" entry
         (file+headline "inbox.org" "Inbox")
         "* TODO %?\n  %U\n")
        ("q" "Quickshell note" entry
         (file+headline "quickshell.org" "Notes")
         "* %?\n  %U\n")
        ("d" "Dotfiles note" entry
         (file+headline "dotfiles.org" "Notes")
         "* %?\n  %U\n")))

(after! org
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((C . t)
     (emacs-lisp . t)
     (lua . t)
     (rust . t)
     (shell . t))))

(setq vterm-module-cmake-args "-DUSE_SYSTEM_LIBVTERM=Off"
      vterm-always-compile-module t
      vterm-shell "zsh"
      dired-listing-switches "-alh --group-directories-first")

(after! vterm
  (add-hook 'vterm-mode-hook #'evil-insert-state)
  (add-hook 'vterm-mode-hook #'sk/disable-line-numbers))

(dolist (hook '(term-mode-hook
                shell-mode-hook
                eshell-mode-hook))
  (add-hook hook #'sk/disable-line-numbers))

(after! apheleia
  (setq +format-on-save-disabled-modes
        '(org-mode
          doom-docs-org-mode
          markdown-mode
          text-mode
          vterm-mode))
  (setf (alist-get 'c-mode apheleia-mode-alist) 'clang-format
        (alist-get 'c-ts-mode apheleia-mode-alist) 'clang-format
        (alist-get 'c++-mode apheleia-mode-alist) 'clang-format
        (alist-get 'c++-ts-mode apheleia-mode-alist) 'clang-format
        (alist-get 'lua-mode apheleia-mode-alist) 'stylua
        (alist-get 'nix-mode apheleia-mode-alist) 'nixfmt
        (alist-get 'nix-ts-mode apheleia-mode-alist) 'nixfmt
        (alist-get 'qml-mode apheleia-mode-alist) 'qmlformat
        (alist-get 'rust-mode apheleia-mode-alist) 'rustfmt
        (alist-get 'rust-ts-mode apheleia-mode-alist) 'rustfmt
        (alist-get 'sh-mode apheleia-mode-alist) 'shfmt)
  (setf (alist-get 'qmlformat apheleia-formatters)
        '("qmlformat" "--indent-width" "2" "-w" "-1" filepath)))

(after! lsp-mode
  (require 'lsp-qml)
  (setq lsp-qml-server-command "qmlls-wrapped"
        lsp-semantic-tokens-enable t)
  (add-hook 'qml-mode-hook #'lsp-deferred)
  (add-to-list 'lsp-language-id-configuration '(org-mode . "org"))
  (add-to-list 'lsp-language-id-configuration '(doom-docs-org-mode . "org"))
  (add-to-list 'lsp-language-id-configuration '(markdown-mode . "markdown"))
  (add-to-list 'lsp-language-id-configuration '(text-mode . "plaintext"))
  (lsp-register-client
   (make-lsp-client
    :new-connection (lsp-stdio-connection '("harper-ls" "--stdio"))
    :activation-fn (lsp-activate-on "org" "markdown" "plaintext")
    :server-id 'harper-ls))
  (dolist (hook '(org-mode-hook doom-docs-org-mode-hook markdown-mode-hook text-mode-hook))
    (add-hook hook #'lsp-deferred)))

(after! magit
  (setq magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))
