;; -*- coding: utf-8 -*-
(defvar best-gc-cons-threshold gc-cons-threshold "Best default gc threshold value. Should't be too big.")
(setq gc-cons-threshold (* 50 1024 1024))

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.

;;(defvar best-gc-cons-threshold 4000000 "Best default gc threshold value. Should't be too big.")
;; don't GC during startup to save time
;;(setq gc-cons-threshold most-positive-fixnum)
(let ((minver "23.3"))
  (when (version<= emacs-version "23.1")
    (error "Your Emacs is too old -- this config requires v%s or higher" minver)))
(when (version<= emacs-version "24")
  (message "Your Emacs is old, and some functionality in this config will be disabled. Please upgrade if possible."))

;; CobbLiu's emacs config file
(setq user-full-name "kelvin")
(setq user-mail-address "peaksec@gmail.com")

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(tooltip-mode -1)


;; 显示行号和列号
(global-linum-mode t)
(setq lium-mode t)
(setq column-number-mode t)
(setq line-number-mode t)
(set-face-background 'fringe "#f4a460")
(setq linum-format "%d ")

;; 一些缩进设置
(setq c-basic-offset 2)
(setq default-tab-width 4)
(setq-default indent-tabs-mode nil)


;; 设置字体是Bitstream Vera Sans Moni
;; font-size是11，因为笔记本12寸，所以字体不敢弄太大
;; yum install bitstream-vera-sans-mono-fonts.noarch
(set-default-font "Bitstream Vera Sans Mono-14")
(setq search-default-regexp-mode nil) ;; emacs25.1

; use `alias emacs='emacs -fn "DejaVu Sans Mono:size=14"` to avoid
;; frame size switching on startup.

;; Way 1
;; ;(let ((zh-font "-unknown-AR PL UMing CN-*-*-*-*-16-*-*-*-*-*-*-*")
;; (let ((zh-font "WenQuanYi Bitmap Song:pixelsize=13")
;;       (fontset "fontset-my"))
;;   (create-fontset-from-fontset-spec
;;     (concat
;;       "-unknown-DejaVu Sans Mono-*-*-*-*-12-*-*-*-*-*-" fontset
;;       ",kana:"          zh-font
;;       ",han:"           zh-font
;;       ",symbol:"        zh-font
;;       ",cjk-misc:"      zh-font
;;       ",bopomofo:"      zh-font))
;;   (set-default-font fontset)
;;   (add-to-list 'default-frame-alist `(font . ,fontset)))
  ;; or set font for new frame like this:
  ;(add-to-list 'after-make-frame-functions
  ;             (lambda (new-frame)
  ;               (select-frame new-frame)
  ;               (if window-system
  ;                 (set-frame-font "fontset-my"))))


;; Way 2
(let (default-font zh-font)
  (cond
    ((eq window-system 'x)
    (setq default-font "Ubuntu Mono 14"
          zh-font (font-spec :family "Sans" :size 20)))
   ((eq window-system 'w32)
    (setq default-font "Consolas 11"
          zh-font (font-spec :family "Microsoft Yahei" :size 14))))
  (when default-font
    (set-default-font default-font)
    (setq fontset (frame-parameter nil 'font))
    (dolist (charset '(kana han symbol cjk-misc bopomofo))
      (set-fontset-font fontset charset zh-font))
    (add-to-list 'default-frame-alist `(font . ,fontset))))


;; 支持emacs和外部程序的粘贴
(setq x-select-enable-clipboard t)

;; 在mode-line显示时间，格式如下
(display-time-mode 1)
(setq display-time-24hr-format t)
(setq display-time-day-and-date t)

;; 以 y/n代表 yes/no
(fset 'yes-or-no-p 'y-or-n-p)


(require 'package)
(setq package-archives '(("ELPA" . "http://tromey.com/elpa/")
                          ("gnu" . "http://elpa.gnu.org/packages/")
                          ("marmalade" . "http://marmalade-repo.org/packages/")
                          ("melpa" . "https://melpa.org/")
                         ("org" . "http://orgmode.org/elpa/")))

; Apparently needed for the package auto-complete (why?)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)

(package-initialize)
(setq url-http-attempt-keepalives nil)
(setq sml/no-confirm-load-theme t)

(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;; No splash screen please ... jeez
(setq inhibit-startup-message t)

;; Set path to dependencies
(setq general-lisp-dir
      (expand-file-name "general-lisp" user-emacs-directory))

(setq site-lisp-dir
      (expand-file-name "site-lisp" user-emacs-directory))

(setq user-lisp-dir
      (expand-file-name "user-lisp" user-emacs-directory))

(setq w3m-lisp-dir
      (expand-file-name "site-misc/emacs-w3m" user-emacs-directory))


;; Set up load path
(add-to-list 'load-path general-lisp-dir)
(add-to-list 'load-path site-lisp-dir)
(add-to-list 'load-path user-lisp-dir)
(add-to-list 'load-path w3m-lisp-dir)

;; Set up appearance early
(require 'appearance)

;; Keep emacs Custom-settings in separate file
(setq custom-file (expand-file-name "custom.el" general-lisp-dir))
(unless '(find-file custom-file)
  (write-region "" nil custom-file))
(load custom-file)

;; Write backup files to own directory
(setq backup-directory-alist
      `(("." . ,(expand-file-name
                 (concat user-emacs-directory "backups")))))

;; Add external projects to load path. That means site-lisp
;; stores some 3rd party projects that are not on melpa
(dolist (project (directory-files site-lisp-dir t "\\w+"))
  (when (file-directory-p project)
    (add-to-list 'load-path project)))

;; Add User Defined Functions
(dolist (defuns (directory-files user-lisp-dir t "\\w+"))
  (when (file-directory-p defuns)
    (add-to-list 'load-path defuns)))

;; Make backups of files, even when they're in version control
(setq vc-make-backup-files t)

;; Are we on a mac?
(setq is-mac (equal system-type 'darwin))

;; Setup packages
(require 'setup-package)

;; Install extensions if they're missing
(defun init--install-packages ()
  (packages-install
   '(
     ;; Org Mode
     org
     org-plus-contrib
     o-blog

     ;; WordPress Edit
     metaweblog
     xml-rpc
     org2blog

     ;; Git
     magit
     ansi
     travis
     git-gutter
     gitconfig-mode
     gitignore-mode
     ;;git-commit-mode
     git-messenger
     git-timemachine
     gist

     ;; Company Mode for Completions
     company
     company-tern
     company-math
     ;; company-anaconda
     company-ycmd
     ycmd

     dired-details
     yasnippet
     flx-ido
     ido-ubiquitous
     smartparens
     rainbow-delimiters
     perspective
     projectile
     ;; multi-term
     exec-path-from-shell
     whitespace-cleanup-mode
     saveplace
     browse-kill-ring
     guide-key
     expand-region
     diminish
     pretty-mode
     itail
     prodigy
     restclient
     deferred

     ;; C/C++ Development
     ggtags

     ;; Elisp
     dash
     elisp-slime-nav
     esup

     ;; Evil
     evil
     evil-visualstar
     evil-surround
     evil-leader
     evil-numbers
     evil-escape
     evil-lisp-state

     ;; Haskell
     haskell-mode
     hi2

     ;; Helm
     helm
     helm-projectile
     helm-themes
     helm-c-yasnippet
     helm-gtags
     helm-flycheck
     helm-descbinds
     helm-github-stars

     thumb-frm

     ;; MongoDB
     inf-mongo
     ob-mongo

     ;; Gnus and Mail
     ;; gnus
     ;; bbdb

     ;; OSX
     erc-terminal-notifier
     dash-at-point

     ;; Clojure
     cider
     ac-cider
     clj-refactor
     clojure-cheatsheet
     clojure-snippets
     latest-clojure-libraries
     align-cljlet
     slamhound
     midje-mode

     ;; Elixir
     elixir-mode
     alchemist

     ;; YAML
     yaml-mode
     ansible
     ansible-doc

     ;; Zeal (Dash Replacement for Linux)
     ;; zeal-at-point
     helm-dash

     ;; MATLAB
     ;; matlab-mode

     ;; ;; Server
     ;; elnode
     ;; peek-mode

     ;; LaTeX
     auctex
     latex-preview-pane
     ac-math
     ebib
     gnuplot-mode
     ac-ispell

     ;; HTML
     emmet-mode
     web-mode
     less-css-mode
     rainbow-mode
     htmlize
     stylus-mode
     jinja2-mode

     ;; Python
     elpy
     flycheck
     jedi
     ;; anaconda-mode
     epc

     ;; Lua
     lua-mode

     ;; Coffeescript
     coffee-mode

     ;; javaScript
     js2-mode
     js2-refactor
     requirejs-mode
     flymake-jshint
     tern
     skewer-mode

     ;;Goodies
     smooth-scrolling
     ace-jump-mode
     paradox
     ox-reveal
     aggressive-indent
     wakatime-mode ;; This keeps track of your time in Emacs
     auto-dim-other-buffers ;; Pretty verbatim right?
     mpages ;; Morning Pages
     spray ;; Speed-reading
     seethru ;; Change Transparency
     nyan-mode

     ;; jabber
     ;; twittering-mode
     ;; golang
     ;; auto-completion是一个代码自动补全工具
     auto-complete
     go-mode
     go-autocomplete

     ;; Themming
     smart-mode-line
     )))

(condition-case nil
    (init--install-packages)
  (error
   (package-refresh-contents)
   (init--install-packages)))

;; Lets start with a smattering of sanity
(require 'sane-defaults)

;; Setup Key bindings
(require 'key-bindings)

(require 'go-autocomplete)
(require 'auto-complete-config)
(ac-config-default)
;;保存文件的时候对该源文件做一下gofmt
(add-hook 'before-save-hook #'gofmt-before-save)

(setq face-font-rescale-alist '(("Microsoft Yahei" . 1.2) ("WenQuanYi Zen Hei" . 1.2)))
;; Load Mac-only config

(when is-mac (require 'mac))

;; _____________________________________________________________________________
;; ________________________________ GOODIES ____________________________________
;; _____________________________________________________________________________

;; Save point position between sessions
(require 'saveplace)
(setq-default save-place t)
(setq save-place-file (expand-file-name ".places" user-emacs-directory))

;; Transparency setup
(require 'seethru)
(seethru 100)


;; Here you put your own github token for when you use paradox-list-packages
(setq paradox-github-token "83a6194df4e80edc925fbaf6ee718eed71cbd2ef")

;; For wakatime see this https://wakatime.com/help/plugins/emacs

;; (require 'wakatime-mode)
;; (setq wakatime-api-key "813b0d78-1f17-43eb-bede-a5c008651d4a")
;; (setq wakatime-cli-path "/usr/local/bin/wakatime")
;; (global-wakatime-mode)

;; _____________________________________________________________________________
;; ______________________________ END GOODIES __________________________________
;; _____________________________________________________________________________
;; Emacs server
(require 'server)
(unless (server-running-p)
  (server-start))

;; Load PATH from shell
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

;; Aggressive Indent Mode is better than electric
(global-aggressive-indent-mode 1)
(add-to-list 'aggressive-indent-excluded-modes 'html-mode)
(add-to-list 'aggressive-indent-excluded-modes 'rcirc-mode)
(add-to-list 'aggressive-indent-excluded-modes 'python-mode)
(add-to-list 'aggressive-indent-excluded-modes 'stylus-mode)

;; Load user specific configuration
(when (file-exists-p user-lisp-dir)
  (mapc 'load (directory-files user-lisp-dir nil "^[^#].*el$")))

(setq browse-url-generic-program
      (substring (shell-command-to-string "gconftool-2 -g /desktop/gnome/applications/browser/exec") 0 -1)
      browse-url-browser-function 'browse-url-generic)

(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'set-goal-column 'disabled nil)
