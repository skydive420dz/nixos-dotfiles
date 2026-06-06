;;; sk-notes.el --- Personal note workflow -*- lexical-binding: t; -*-

(require 'subr-x)

(defvar sk/org-notes-root (expand-file-name "~/Documents/notes/")
  "Root directory for personal Org notes.")

(defun sk/org-agenda-note-files ()
  "Return every Org note file under `sk/org-notes-root'."
  (when (file-directory-p sk/org-notes-root)
    (directory-files-recursively sk/org-notes-root "\\.org\\'")))

(defun sk/org-refresh-agenda-files ()
  "Refresh `org-agenda-files' from the note tree."
  (interactive)
  (setq org-agenda-files (sk/org-agenda-note-files)))

(defun sk/org--slugify (text)
  "Return a simple filename slug for TEXT."
  (let* ((downcased (downcase text))
         (clean (replace-regexp-in-string "[^[:alnum:]]+" "-" downcased)))
    (string-trim clean "-" "-")))

(defun sk/org--ensure-file (file title &optional body)
  "Create FILE with TITLE and optional BODY when it does not exist."
  (make-directory (file-name-directory file) t)
  (unless (file-exists-p file)
    (with-temp-file file
      (insert "#+title: " title "\n"
              "#+date: " (format-time-string "%Y-%m-%d") "\n"
              "#+startup: overview\n\n")
      (when body
        (insert body)))
    (when (boundp 'org-agenda-files)
      (sk/org-refresh-agenda-files)))
  file)

(defun sk/org-inbox-file ()
  "Return the personal inbox file, creating it if needed."
  (sk/org--ensure-file
   (expand-file-name "inbox.org" sk/org-notes-root)
   "Inbox"
   "* Inbox\n"))

(defun sk/org-daily-file ()
  "Return today's daily note file, creating it if needed."
  (let* ((year (format-time-string "%Y"))
         (date (format-time-string "%Y-%m-%d"))
         (file (expand-file-name (concat "daily/" year "/" date ".org") sk/org-notes-root)))
    (sk/org--ensure-file
     file
     date
     "* Today\n** Focus\n** Tasks\n** Notes\n** Questions\n** Follow-up\n")))

(defun sk/org-topic-file ()
  "Prompt for a topic note and return its file path, creating it if needed."
  (let* ((year (format-time-string "%Y"))
         (title (read-string "Topic: "))
         (slug (sk/org--slugify title))
         (date (format-time-string "%Y-%m-%d"))
         (file (expand-file-name (concat "topics/" year "/" date "-" slug ".org") sk/org-notes-root)))
    (sk/org--ensure-file file title "* Notes\n")))

(defun sk/org-project-file ()
  "Prompt for a project note and return its file path, creating it if needed."
  (let* ((name (read-string "Project: "))
         (slug (sk/org--slugify name))
         (file (expand-file-name (concat "projects/" slug ".org") sk/org-notes-root)))
    (sk/org--ensure-file
     file
     name
     "* Overview\n* Tasks\n* Notes\n* Decisions\n* Follow-up\n")))

(defun sk/org-open-daily-note ()
  "Open today's daily note."
  (interactive)
  (find-file (sk/org-daily-file)))

(defun sk/org-open-inbox ()
  "Open the personal inbox."
  (interactive)
  (find-file (sk/org-inbox-file)))

(defun sk/org-open-topic-note ()
  "Create or open a topic note."
  (interactive)
  (find-file (sk/org-topic-file)))

(defun sk/org-open-project-note ()
  "Create or open a project note."
  (interactive)
  (find-file (sk/org-project-file)))

(setq org-directory sk/org-notes-root
      org-agenda-files (sk/org-agenda-note-files)
      org-default-notes-file (sk/org-inbox-file))

(setq org-capture-templates
      '(("i" "Inbox note" entry
         (file+headline sk/org-inbox-file "Inbox")
         "* %?\n  %U\n"
         :empty-lines 1)
        ("t" "Todo" entry
         (file+headline sk/org-inbox-file "Inbox")
         "* TODO %?\n  %U\n")
        ("d" "Daily note" entry
         (file+headline sk/org-daily-file "Notes")
         "* %?\n  %U\n"
         :empty-lines 1)
        ("T" "Topic note" entry
         (file+headline sk/org-topic-file "Notes")
         "* %?\n  %U\n"
         :empty-lines 1)
        ("p" "Project note" entry
         (file+headline sk/org-project-file "Notes")
         "* %?\n  %U\n"
         :empty-lines 1)))

(global-set-key (kbd "C-c n i") #'sk/org-open-inbox)
(global-set-key (kbd "C-c n d") #'sk/org-open-daily-note)
(global-set-key (kbd "C-c n t") #'sk/org-open-topic-note)
(global-set-key (kbd "C-c n p") #'sk/org-open-project-note)
(global-set-key (kbd "C-c n c") #'org-capture)
(global-set-key (kbd "C-c n a") #'org-agenda)

(provide 'sk-notes)

;;; sk-notes.el ends here
