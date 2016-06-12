;;; init.el --- The first thing GNU Emacs runs

;; Decrease the number of times garbage collection is invoked during startup.
;; This drastically improves `emacs-init-time'.
(setq gc-cons-threshold 250000000)      ; 250 MB

;; Free up screen real estate early on
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)

;; Ignore default regex checks of filenames during startup. This also
;; drastically improves `emacs-init-time'.
;; NOTE: Some bogus warnings will occur.
(let ((file-name-handler-alist nil))
  (require 'package)
  (setq package-enable-at-startup nil)
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
  (package-initialize)

  ;; Bootstarp `use-package'. It will manage all other packages.
  (unless (package-installed-p 'use-package)
    (package-refresh-contents)
    (package-install 'use-package))
  (eval-when-compile
    (require 'use-package))
  (require 'bind-key)
  (require 'diminish)

  ;; Needed for certain major modes
  (require 'cl)

  ;; Tangle and load the rest of the config
  (org-babel-load-file (concat user-emacs-directory "config.org"))

  ;; Tangle and load more private settings (delete or change this to fit your setup)
  (when (eq system-type 'gnu/linux)
    (org-babel-load-file "~/Dropbox/.private.org"))
  (when (eq system-type 'windows-nt)
    (org-babel-load-file "C:/Users/geoff/Dropbox/.private.org")))

;; Revert garbage collection behavior
(run-with-idle-timer
 5 nil
 (lambda ()
   (setq gc-cons-threshold 1000000)))   ; 1 MB
