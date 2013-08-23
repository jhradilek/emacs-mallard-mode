;;; mallard-mode.el --- Major mode for editing Mallard files

;; Copyright (C) 2013 Jaromir Hradilek

;; Author: Jaromir Hradilek <jhradilek@gmail.com>
;; URL: https://github.com/jhradilek/emacs-mallard-mode
;; Version: 0.2.1
;; Keywords: XML Mallard

;; This file is NOT part of GNU Emacs.

;; This work is licensed under a Creative Commons Attribution-ShareAlike
;; 3.0 Unported License. For a detailed explanation of this license, see
;; <http://creativecommons.org/licenses/by-sa/3.0/>.

;;; Commentary:

;; A major mode for editing Mallard files.

;;; Code:

(require 'nxml-mode)

(defconst mallard-mode-version "0.2.1"
  "The version of mallard-mode.")

(defgroup mallard nil
  "The customization group for mallard-mode."
  :group 'languages
  :prefix "mallard-mode-")

(defcustom mallard-mode-comments-buffer "*mallard-comments*"
  "The name of the buffer for editorial comments in a Mallard document."
  :group 'mallard
  :type 'string)

(defcustom mallard-mode-comments-command '("yelp-check" "comments")
  "The command to display editorial comments in a Mallard document."
  :group 'mallard
  :type '(list (string :tag "Command")
               (string :tag "Arguments")))

(defcustom mallard-mode-hrefs-buffer "*mallard-hrefs*"
  "The name of the buffer for broken external links in a Mallard document."
  :group 'mallard
  :type 'string)

(defcustom mallard-mode-hrefs-command '("yelp-check" "hrefs")
  "The command to display broken external links in a Mallard document."
  :group 'mallard
  :type '(list (string :tag "Command")
               (string :tag "Arguments")))

(defcustom mallard-mode-status-buffer "*mallard-status*"
  "The name of the buffer for the status of a Mallard document."
  :group 'mallard
  :type 'string)

(defcustom mallard-mode-status-command '("yelp-check" "status")
  "The command to display the status of a Mallard document."
  :group 'mallard
  :type '(list (string :tag "Command")
               (string :tag "Arguments")))

(defcustom mallard-mode-validate-buffer "*mallard-validate*"
  "The name of the buffer for validation errors in a Mallard document."
  :group 'mallard
  :type 'string)

(defcustom mallard-mode-validate-command '("yelp-check" "validate")
  "The command to validate a Mallard document."
  :group 'mallard
  :type '(list (string :tag "Command")
               (string :tag "Arguments")))

(defvar mallard-mode-map
  (let ((map (make-sparse-keymap)))
    (set-keymap-parent map nxml-mode-map)
    (define-key map "\C-c\C-c" 'mallard-comments)
    (define-key map "\C-c\C-h" 'mallard-hrefs)
    (define-key map "\C-c\C-s" 'mallard-status)
    (define-key map "\C-c\C-v" 'mallard-validate)
    map)
  "Keymap for mallard-mode.
All commands in `nxml-mode-map' are inherited by this map.")

(defvar mallard-directory
  (file-name-directory load-file-name)
  "The main directory of mallard-mode.")

(defvar mallard-schemas
  (expand-file-name "schema/schemas.xml" mallard-directory)
  "The location of the schema locating file for Mallard.")

(defun mallard-buffer-saved-p (&optional buffer)
  "Return t if BUFFER does not contain any unsaved changes.
When BUFFER is not specified or is nil, use the current buffer."
  (not (buffer-modified-p (or buffer (current-buffer)))))

(defun mallard-interactive-buffer-saved-p (&optional buffer)
  "Return t if BUFFER does not contain any unsaved changes.
If it does, interactively prompt the user to save it.
When BUFFER is not specified or is nil, use the current buffer."
  (or (mallard-buffer-saved-p buffer)
      (cond ((string= (read-string "The buffer must be saved. Save now? (y/n) ") "y")
             (save-buffer) t)
            (t (message "Aborted.") nil))))

(defun mallard-run-command-on-buffer (command &optional buffer)
  "Ensure that BUFFER is saved and execute shell command COMMAND on it.
Return the output of COMMAND as a string.
When BUFFER is not specified or is nil, use the current buffer."
  (when (mallard-interactive-buffer-saved-p buffer)
    (shell-command-to-string
     (mapconcat 'identity
                (append command (list (buffer-file-name buffer))) " "))))

(defun mallard-version ()
  "Display the current version of mallard-mode in the minibuffer."
  (interactive)
  (message "mallard-mode %s" mallard-mode-version))

(defun mallard-comments ()
  "Display editorial comments in the currently edited Mallard document."
  (interactive)
  (message "Searching for editorial comments in the current buffer...")
  (let ((output (mallard-run-command-on-buffer mallard-mode-comments-command)))
    (unless (null output)
      (if (zerop (length output))
          (message "No editorial comments found.")
        (display-message-or-buffer output mallard-mode-comments-buffer)))))

(defun mallard-hrefs ()
  "Display broken external links in the currently edited Mallard document."
  (interactive)
  (message "Checking external links in the current buffer...")
  (let ((output (mallard-run-command-on-buffer mallard-mode-hrefs-command)))
    (unless (null output)
      (if (zerop (length output))
          (message "No broken external links found.")
        (display-message-or-buffer output mallard-mode-hrefs-buffer)))))

(defun mallard-status ()
  "Display the status of the currently edited Mallard document."
  (interactive)
  (message "Checking the status of the current buffer...")
  (let ((output (mallard-run-command-on-buffer mallard-mode-status-command)))
    (unless (and (null output) (zerop (length output)))
      (display-message-or-buffer output mallard-mode-status-buffer))))

(defun mallard-validate ()
  "Validate the currently edited Mallard document."
  (interactive)
  (message "Validating the current buffer...")
  (let ((output (mallard-run-command-on-buffer mallard-mode-validate-command)))
    (unless (null output)
      (if (zerop (length output))
          (message "No validation errors found.")
        (display-message-or-buffer output mallard-mode-validate-buffer)))))

;;;###autoload
(define-derived-mode mallard-mode nxml-mode "Mallard"
  "A major mode for editing Mallard files."
  (setq-default indent-tabs-mode nil)
  (setq-default tab-width 2)
  (setq-default fill-column 80)
  (turn-on-auto-fill))

;;;###autoload
(progn (add-to-list 'auto-mode-alist '("\\.page\\'" . mallard-mode))
       (add-to-list 'auto-mode-alist '("\\.page\\.stub\\'" . mallard-mode)))

(eval-after-load 'rng-loc
  '(add-to-list 'rng-schema-locating-files mallard-schemas))

(provide 'mallard-mode)

;;; mallard-mode.el ends here
