;;; sk-docs.el --- Documentation helpers -*- lexical-binding: t; -*-

(require 'thingatpt)
(require 'json)
(require 'subr-x)
(require 'use-package)

(defvar sk/devdocs-install-buffer-name "*DevDocs Install*"
  "Buffer used for external DevDocs install jobs.")

(defvar sk/devdocs-catalog-file
  (expand-file-name "devdocs-docs.json" user-emacs-directory)
  "Local DevDocs catalog used for safe searchable installs.")

(defun sk/devdocs--library-directory (library)
  "Return the directory containing LIBRARY."
  (when-let* ((path (locate-library library)))
    (file-name-directory path)))

(defun sk/devdocs--emacs-command ()
  "Return the current Emacs executable."
  (expand-file-name invocation-name invocation-directory))

(defun sk/devdocs--batch-command (form)
  "Build an external batch Emacs command evaluating FORM."
  (let ((compat-dir (sk/devdocs--library-directory "compat"))
        (devdocs-dir (sk/devdocs--library-directory "devdocs")))
    (unless (and compat-dir devdocs-dir)
      (user-error "DevDocs is not installed yet; run emacs-sync first"))
    (list (sk/devdocs--emacs-command)
          "-Q"
          "--batch"
          "-L" compat-dir
          "-L" devdocs-dir
          "--eval" form)))

(defun sk/devdocs--catalog-candidates ()
  "Return searchable DevDocs catalog candidates from `sk/devdocs-catalog-file'."
  (unless (file-readable-p sk/devdocs-catalog-file)
    (sk/devdocs-refresh-catalog)
    (user-error "Refreshing DevDocs catalog; try SPC c K again when it finishes"))
  (let ((docs (with-temp-buffer
                (insert-file-contents sk/devdocs-catalog-file)
                (json-parse-buffer :object-type 'alist :array-type 'list)))
        candidates)
    (dolist (doc docs (nreverse candidates))
      (let* ((slug (alist-get 'slug doc))
             (name (alist-get 'name doc))
             (version (alist-get 'version doc))
             (release (alist-get 'release doc))
             (label (string-join
                     (delq nil
                           (list slug
                                 name
                                 (unless (string-empty-p (or version ""))
                                   version)
                                 (unless (string-empty-p (or release ""))
                                   release)))
                     "  ")))
        (push (cons label slug) candidates)))))

(defun sk/devdocs--start-batch-job (name command success-message)
  "Start external DevDocs job NAME using COMMAND.
SUCCESS-MESSAGE is shown when the external process exits successfully."
  (let ((buffer (get-buffer-create sk/devdocs-install-buffer-name)))
    (with-current-buffer buffer
      (read-only-mode -1)
      (erase-buffer)
      (insert (format "Starting %s\n\n" name))
      (insert (mapconcat #'shell-quote-argument command " "))
      (insert "\n\n"))
    (message "Started %s; use SPC c L for the log" name)
    (make-process
     :name name
     :buffer buffer
     :command command
     :sentinel
     (lambda (process event)
       (when (memq (process-status process) '(exit signal))
         (let ((exit-code (process-exit-status process)))
           (with-current-buffer (process-buffer process)
             (let ((inhibit-read-only t))
               (goto-char (point-max))
               (insert (format "\n%s finished: %s" name (string-trim event)))
               (special-mode)))
           (if (zerop exit-code)
               (message "%s" success-message)
             (message "%s failed with exit code %s" name exit-code))))))))

(defun sk/devdocs-refresh-catalog ()
  "Refresh the local DevDocs catalog in an external batch Emacs process."
  (interactive)
  (let* ((runtime-dir (file-name-as-directory user-emacs-directory))
         (catalog-file sk/devdocs-catalog-file)
         (form (format
                "(progn
                   (setq user-emacs-directory %S)
                   (require 'devdocs)
                   (let ((docs (devdocs--available-docs)))
                     (let ((coding-system-for-write 'utf-8-unix))
                       (with-temp-file %S
                         (insert (json-serialize docs)))))
                   (message \"DevDocs catalog refreshed\"))"
                runtime-dir
                catalog-file)))
    (sk/devdocs--start-batch-job
     "devdocs-refresh-catalog"
     (sk/devdocs--batch-command form)
     "DevDocs catalog refreshed")))

(defun sk/devdocs-open-install-log ()
  "Open the DevDocs install log buffer."
  (interactive)
  (if-let* ((buffer (get-buffer sk/devdocs-install-buffer-name)))
      (pop-to-buffer buffer)
    (user-error "No DevDocs install log buffer")))

(defun sk/devdocs-lookup (&optional ask-docs)
  "Look up the symbol at point in DevDocs, or start a safe install.

With prefix ASK-DOCS, search the local DevDocs catalog and install a docset
through `sk/devdocs-install'."
  (interactive "P")
  (require 'devdocs)
  (if ask-docs
      (call-interactively #'sk/devdocs-install)
    (let ((query (or (thing-at-point 'symbol t) "")))
      (condition-case err
          (devdocs-lookup nil query)
        (user-error
         (if (string-match-p "No documents" (error-message-string err))
             (progn
               (call-interactively #'sk/devdocs-install)
               (message "Run SPC c K again after the install finishes"))
           (signal (car err) (cdr err))))))))

(defun sk/devdocs-install (docset)
  "Install DOCSET through an external batch Emacs process.

This command is safe to call from the live daemon because the synchronous
DevDocs network work happens in a separate Emacs process."
  (interactive
   (list
    (string-trim
     (let* ((candidates (ignore-errors (sk/devdocs--catalog-candidates)))
            (choice (if candidates
                        (completing-read "Install DevDocs: " candidates nil t)
                      (read-string "Install DevDocs slug: " nil nil
                                   (or (car-safe (bound-and-true-p devdocs-current-docs))
                                       "")))))
       (or (cdr (assoc choice candidates)) choice)))))
  (when (string-empty-p docset)
    (user-error "DevDocs slug is required, for example lua~5.5"))
  (let* ((runtime-dir (file-name-as-directory user-emacs-directory))
         (form (format
                "(progn
                   (setq user-emacs-directory %S)
                   (require 'devdocs)
                   (setq debug-on-error t)
                   (devdocs-install %S))"
                runtime-dir
                docset)))
    (sk/devdocs--start-batch-job
     (format "devdocs-install:%s" docset)
     (sk/devdocs--batch-command form)
     (format "DevDocs installed: %s" docset))))

(defun sk/devdocs-update-all ()
  "Update installed DevDocs docsets through an external batch Emacs process."
  (interactive)
  (let* ((runtime-dir (file-name-as-directory user-emacs-directory))
         (form (format
                "(progn
                   (setq user-emacs-directory %S)
                   (require 'devdocs)
                   (setq debug-on-error t)
                   (devdocs-update-all))"
                runtime-dir)))
    (sk/devdocs--start-batch-job
     "devdocs-update-all"
     (sk/devdocs--batch-command form)
     "DevDocs update complete")))

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
