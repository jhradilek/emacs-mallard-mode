;;; mallard-mode.el --- Major mode for editing Mallard files

;; Copyright (C) 2013 Jaromir Hradilek

;; Author: Jaromir Hradilek <jhradilek@gmail.com>
;; URL: https://github.com/jhradilek/emacs-mallard-mode
;; Version: 0.1.1
;; Keywords: XML Mallard

;; This file is NOT part of GNU Emacs.

;; This work is licensed under a Creative Commons Attribution-ShareAlike
;; 3.0 Unported License. For a detailed explanation of this license, see
;; <http://creativecommons.org/licenses/by-sa/3.0/>.

;;; Commentary:

;; A major mode for editing Mallard files.

;;; Code:

(defconst mallard-mode-version "0.1.1"
  "The version of mallard-mode.")

(defgroup mallard nil
  "The customization group for mallard-mode."
  :prefix "mallard-mode-"
  :group 'languages)

(defcustom mallard-mode-validate-command "yelp-check validate"
  "The command to validate a Mallard document."
  :type 'string
  :group 'mallard)

(defcustom mallard-mode-validate-buffer "*mallard-validate*"
  "The name of the buffer for validation errors in a Mallard document."
  :type 'string
  :group 'mallard)

(defvar mallard-directory
  (file-name-directory load-file-name)
  "The main directory of mallard-mode.")

(defvar mallard-schemas
  (expand-file-name "schema/schemas.xml" mallard-directory)
  "The location of the schema locating file for Mallard.")

(defun mallard-buffer-saved-p (&optional buffer)
  "Return t if BUFFER does not contain any unsaved changes.
If it does, interactively prompt the user to save it.
When BUFFER is not specified or is nil, use the current buffer."
  (if (buffer-modified-p (or buffer (current-buffer)))
      (cond ((string= (read-string "The buffer must be saved. Save now? (y/n) ") "y")
             (save-buffer) t)
            (t (message "Aborted.") nil))
    t))

(defun mallard-run-command-on-buffer (command &optional buffer)
  "Ensure that BUFFER is saved and execute shell command COMMAND on it.
Return the output of COMMAND as a string.
When BUFFER is not specified or is nil, use the current buffer."
  (when (mallard-buffer-saved-p (or buffer (current-buffer)))
    (shell-command-to-string command)))

(defun mallard-version ()
  "Display the current version of mallard-mode in the minibuffer."
  (interactive)
  (message "mallard-mode %s" mallard-mode-version))

(defun mallard-validate ()
  "Validate the currently edited Mallard document."
  (interactive)
  (message "Validating the current buffer...")
  (let* ((command (concat mallard-mode-validate-command " " (buffer-file-name)))
         (output (mallard-run-command-on-buffer command)))
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
