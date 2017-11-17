(setq inhibit-startup-message t)

(require 'package)
(setq package-enable-at-startup nil)
(setq package-user-dir "~/projects/learn-lisp/elpa")
(add-to-list 'package-archives
             '("melpa" ."https://melpa.org/packages/"))
(package-initialize)

;; bootstrap 'use-package

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-pacakge))

(use-package try
             :ensure t)
(use-package which-key
             :ensure t
             :config
             (which-key-mode))