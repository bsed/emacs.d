;;;; Markdown
;;; See http://jblevins.org/projects/markdown-mode/
;;;
;;; This module provide a minor mode "impatient markdown mode", which similar
;;; to impatient-mode but for markdown buffers as opposed to HTML buffers. It
;;; is actually implemented with the impatient-mode itself.
;;;
;;; When you type command `impatient-markdown-mode' in a markdown buffer, Emacs
;;; starts an embedded HTTP server listening to port 8080 (by default), and it
;;; will direct your favorite web browser to URL
;;; "http://localhost:8080/imp/live/<buffer-name.md>"
;;;
;;; Any change you make in the buffer from that point is automatically rendered
;;; in real-time in the web browser. To stop the HTTP server, run
;;; `impatient-markdown-mode' again. Note that Emacs will complain if you quit
;;; before stopping the server.
;;;
;;; Before you can use it, you need to set the variable `markdown-command' to
;;; the command to execute to render a markdown file into HTML.  To use the
;;; GitHub command, clone https://github.com/github/markup and set
;;; `markdown-command' to the path of bin/github-markup in your after-init.el.
;;; Other options include Pandoc or RedCarpet.
;;;
;;; Note: you can change the variable `httpd-port' if 8080 does not work in
;;; your environment. Also the current implementation uses a temporary file
;;; whose path is defined in `exordium-markdown-file' which can also be
;;; changed.

(require 'markdown-mode)

;;设置markdown相关参数，需要在search目录下有 markdown-mode.el
(autoload 'markdown-mode "markdown-mode"
    "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;;markdown table
(require'table)
(autoload 'table-insert "table" "WYGIWYS table editor")

;;; FIXME: quick workaround for a bug in markdown-mode 2.1 (font lock is broken)
(when (and (boundp 'markdown-mode-version)
           (equal markdown-mode-version "2.1"))
  (add-hook 'markdown-mode-hook 'font-lock-mode))



(provide 'setup-markdown-mode)
