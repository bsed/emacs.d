(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(require 'js2-refactor)
(add-hook 'js2-mode-hook 'skewer-mode)
(add-hook 'js2-mode-hook 'ac-js2-mode)

(require 'flymake-jshint)
(add-hook 'js-mode-hook 'flymake-mode)

(provide 'setup-js2)
