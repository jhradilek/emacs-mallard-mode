;;; mallard-mode.el --- Major mode for editing Mallard files

;; Copyright (C) 2013 Jaromir Hradilek

;; Author: Jaromir Hradilek <jhradilek@gmail.com>
;; URL: https://github.com/jhradilek/emacs-mallard-mode
;; Version: 0.1.0
;; Keywords: XML Mallard

;; This file is NOT part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; A major mode for editing Mallard files.

;;; Code:

(defvar mallard-dir (file-name-directory load-file-name))
(defvar mallard-schemas (expand-file-name "schema/schemas.xml" mallard-dir))

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

;;;###autoload
(eval-after-load 'rng-loc
  '(add-to-list 'rng-schema-locating-files mallard-schemas))

(provide 'mallard-mode)

;;; mallard-mode.el ends here
