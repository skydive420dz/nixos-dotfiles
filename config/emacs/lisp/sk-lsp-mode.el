;;; sk-lsp-mode.el --- lsp-mode proof slices -*- lexical-binding: t; -*-

;; This module is intentionally narrow.  It proves lsp-mode + company on Lua
;; without changing the global Eglot/Corfu path used by other languages.

(require 'cl-lib)
(require 'seq)
(require 'sk-lsp)

(defconst sk/lsp-mode-lua-modes '(lua-mode lua-ts-mode)
  "Lua major modes owned by lsp-mode during the proof slice.")

(defconst sk/lsp-lua-owned-capfs '(lsp-completion-at-point)
  "Completion-at-point functions allowed in Lua lsp-mode proof buffers.")

(setq sk/lsp-mode-owned-modes sk/lsp-mode-lua-modes)

(defun sk/lsp-lua-language-server-root ()
  "Return the Nix package root for lua-language-server, when available."
  (when-let ((binary (executable-find "lua-language-server")))
    (file-name-directory
     (directory-file-name
      (file-name-directory (file-truename binary))))))

(defun sk/lsp-lua-language-server-main ()
  "Return the Nix lua-language-server main.lua path, when available."
  (when-let ((root (sk/lsp-lua-language-server-root)))
    (let ((main (expand-file-name "share/lua-language-server/main.lua" root)))
      (when (file-exists-p main)
        main))))

(defun sk/lsp-lua-workspace-library ()
  "Return LuaLS workspace libraries as a string-keyed JSON object."
  (let ((library (make-hash-table :test 'equal)))
    (dolist (path (sk/lua-workspace-library))
      (puthash path t library))
    library))

(defun sk/lsp-lua-buffer-p ()
  "Return non-nil when the current buffer is part of the Lua proof slice."
  (memq major-mode sk/lsp-mode-lua-modes))

(defun sk/lsp-lua-use-strict-completion ()
  "Let lsp-mode own completion sources in Lua proof buffers."
  (when (sk/lsp-lua-buffer-p)
    (setq-local completion-at-point-functions sk/lsp-lua-owned-capfs)
    (setq-local company-backends '(company-capf))))

(defun sk/lsp-lua-enable-breadcrumb ()
  "Enable lsp-mode breadcrumbs in Lua proof buffers."
  (when (sk/lsp-lua-buffer-p)
    (require 'all-the-icons nil t)
    (require 'lsp-treemacs nil t)
    (require 'lsp-headerline nil t))
  (when (and (sk/lsp-lua-buffer-p)
             (fboundp 'lsp-headerline-breadcrumb-mode))
    (lsp-headerline-breadcrumb-mode 1)))

(defun sk/lsp-sanitize-image-spec (image)
  "Return IMAGE without PGTK-hostile transparent mask metadata."
  (if (and (listp image)
           (eq (car image) 'image))
      (let ((plist (copy-sequence (cdr image))))
        (cl-remf plist :mask)
        (when (eq (plist-get plist :background) 'unspecified)
          (cl-remf plist :background))
        (cons 'image plist))
    image))

(defun sk/lsp-sanitize-icon-display (icon)
  "Sanitize lsp-treemacs ICON display properties while keeping PNG images."
  (if (stringp icon)
      (let ((display (get-text-property 0 'display icon)))
        (if display
            (propertize icon 'display (sk/lsp-sanitize-image-spec display))
          icon))
    icon))

(defun sk/lsp-fix-breadcrumb-icon-rendering (original image)
  "Call ORIGINAL and sanitize returned PNG display specs for PGTK."
  (sk/lsp-sanitize-icon-display (funcall original image)))

(with-eval-after-load 'lsp-icons
  (advice-remove 'lsp-icons--fix-image-background
                 #'sk/lsp-fix-breadcrumb-icon-rendering)
  (advice-add 'lsp-icons--fix-image-background
              :around #'sk/lsp-fix-breadcrumb-icon-rendering))

(defun sk/lsp-lua-enable-company ()
  "Use the Lua proof completion and diagnostics UI."
  (when (sk/lsp-lua-buffer-p)
    (when (fboundp 'corfu-mode)
      (corfu-mode -1))
    (sk/lsp-lua-use-strict-completion)
    (add-hook 'lsp-configure-hook #'sk/lsp-lua-use-strict-completion nil t)
    (add-hook 'lsp-configure-hook #'sk/lsp-lua-enable-breadcrumb nil t)
    (company-mode 1)
    (flycheck-mode 1)))

(defun sk/lsp-lua-start ()
  "Start lsp-mode for Lua proof buffers."
  (when (and buffer-file-name
             (sk/lsp-lua-buffer-p))
    (sk/lsp-lua-enable-company)
    (if noninteractive
        (lsp)
      (lsp-deferred))))

(use-package company
  :defer t
  :config
  (setq company-backends '(company-capf)
        company-frontends '(company-pseudo-tooltip-frontend)
        company-idle-delay 0.05
        company-minimum-prefix-length 1
        company-selection-wrap-around t
        company-tooltip-align-annotations t))

(use-package all-the-icons
  :defer t)

(use-package flycheck
  :defer t)

(use-package lsp-treemacs
  :after lsp-mode)

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-auto-configure t
        lsp-auto-guess-root t
        lsp-guess-root-without-session t
        lsp-completion-enable t
        lsp-completion-provider :capf
        lsp-completion-show-detail t
        lsp-completion-show-kind t
        lsp-diagnostics-provider :flycheck
        lsp-enable-snippet t
        lsp-enable-suggest-server-download nil
        lsp-headerline-breadcrumb-enable t
        lsp-headerline-breadcrumb-enable-diagnostics t
        lsp-headerline-breadcrumb-enable-symbol-numbers nil
        lsp-headerline-breadcrumb-icons-enable t
        lsp-headerline-breadcrumb-segments '(project file symbols)
        lsp-idle-delay 0.2
        lsp-lua-completion-call-snippet "Both"
        lsp-lua-completion-enable t
        lsp-lua-completion-keyword-snippet "Both"
        lsp-lua-diagnostics-globals ["vim" "hl"]
        lsp-lua-runtime-version "LuaJIT"
        lsp-lua-telemetry-enable nil
        lsp-lua-workspace-library (sk/lsp-lua-workspace-library))
  (when-let ((binary (executable-find "lua-language-server")))
    (setq lsp-clients-lua-language-server-bin binary
          lsp-clients-lua-language-server-command (list binary)))
  (when-let ((main (sk/lsp-lua-language-server-main)))
    (setq lsp-clients-lua-language-server-main-location main)))

(remove-hook 'lua-mode-hook #'sk/lsp-lua-start)
(remove-hook 'lua-ts-mode-hook #'sk/lsp-lua-start)
(add-hook 'lua-mode-hook #'sk/lsp-lua-start t)
(add-hook 'lua-ts-mode-hook #'sk/lsp-lua-start t)

(dolist (buffer (buffer-list))
  (with-current-buffer buffer
    (when (sk/lsp-lua-buffer-p)
      (sk/lsp-lua-enable-company)
      (sk/lsp-lua-enable-breadcrumb))))

(provide 'sk-lsp-mode)

;;; sk-lsp-mode.el ends here
