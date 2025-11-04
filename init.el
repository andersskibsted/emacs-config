;; -*- lexical-binding: t; -*-
;;; Code:

;; Disable package.el
(setq package-enable-at-startup nil)
(setq package-archives nil)

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))
;; Load config
(org-babel-load-file (expand-file-name "~/.emacs.d/config.org"))

;;; init.el ends here
