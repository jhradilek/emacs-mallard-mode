# Major Mode for Mallard

## Description

The **emacs-mallard-mode** repository provides **mallard-mode**, a major mode for editing [Mallard](http://projectmallard.org/) files in Emacs.

## Installation

To install **mallard-mode**, add the following lines to your **~/.emacs.d/init.el** file to enable the Milkypostman's Emacs Lisp Package Archive (MELPA) repository:

    (require 'package)
    (add-to-list 'package-archives
                 '("melpa" . "http://melpa.milkbox.net/packages/"))
    (package-initialize)

Then run the following Emacs commands to install the **mallard-mode** package:

    M-x package-refresh-contents
    M-x package-install mallard-mode

Refer to the [GNU Emacs manual](http://www.gnu.org/software/emacs/manual/html_node/emacs/Packages.html) for more information on how to download, install, update, and uninstall packages in this editor.

## Usage

To use **mallard-mode**, either open a file with the **.page** or **.page.stub** extension, or enable it in the current buffer by running the following Emacs command:

    M-x mallard-mode

Refer to the [GNU Emacs manual](http://www.gnu.org/software/emacs/manual/html_node/emacs/Major-Modes.html) for more information on how to enable and configure major modes in Emacs.

## See Also

* [jhradilek/emacs-mallard-snippets](https://github.com/jhradilek/emacs-mallard-snippets) — A complete set of snippets for the Mallard XML language.

## Copyright and License

Copyright © 2013 Jaromir Hradilek

The **schema/mallard-1.0.rnc** file is licensed by Shaun McCance under the [Creative Commons Attribution-ShareAlike 3.0 Unported License](http://creativecommons.org/licenses/by-sa/3.0/).

The remaining files are released under the [GNU General Public License](http://www.gnu.org/licenses/gpl.html) as published by the [Free Software Foundation](http://www.fsf.org/), either version 3 of the License, or (at your option) any later version.
