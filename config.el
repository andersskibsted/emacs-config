;; -*- lexical-binding: t; -*-

;;(setq package-enable-at-startup nil)
;;(setq package-archives nil)

;; Custom file
;; (setq custom-file (expand-file-name "custom.el" user-emacs-directory))
;; (when (file-exists-p custom-file)
  ;; (load custom-file))

(defvar elpaca-installer-version 0.11)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-repos-directory (expand-file-name "repos/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                              :ref nil :depth 1
                              :files (:defaults "elpaca-test.el" (:exclude "extensions"))
                              :build (:not elpaca--activate-package)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-repos-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (< emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
        (if-let* ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
                  ((zerop (apply #'call-process `("git" nil ,buffer t "clone"
                                                  ,@(when-let* ((depth (plist-get order :depth)))
                                                      (list (format "--depth=%d" depth) "--no-single-branch"))
                                                  ,(plist-get order :repo) ,repo))))
                  ((zerop (call-process "git" nil buffer t "checkout" (or (plist-get order :ref) "--"))))
                  (emacs (concat invocation-directory invocation-name))
                  ((zerop (call-process emacs nil buffer nil "-Q" "-L" "." "--batch"
                                        "--eval" "(byte-recompile-directory \".\" 0 'force)")))
                  ((require 'elpaca))
                  ((elpaca-generate-autoloads "elpaca" repo)))
            (progn (message "%s" (buffer-string)) (kill-buffer buffer))
          (error "%s" (with-current-buffer buffer (buffer-string))))
      ((error) (warn "%s" err) (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (load "./elpaca-autoloads")))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))

;; Install use-package support
(elpaca elpaca-use-package
  (elpaca-use-package-mode))

;; Wait for setup to complete
(elpaca-wait)

(setq inhibit-startup-message t)
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (setq use-short-answers t)
  (defun open-config-file ()
    "Åbn config.org"
    (interactive)
    (find-file "~/.emacs.d/config.org"))

  (global-set-key (kbd "C-c i") 'open-config-file)
;; ae, oe og aa
(add-hook 'text-mode-hook (lambda () (set-input-method "danish-postfix")))

(use-package modus-themes
  :ensure t
  :config)
 ;;(load-theme 'modus-vivendi-tinted t))
(use-package doom-themes
  :ensure t
  :config)
  ;;(load-theme 'doom-badger t))
(load-theme 'wombat t)
(set-face-attribute 'default nil :font "Fira Code Retina" :height 130)

(setq evil-want-keybinding nil)
(setq evil-want-integration t)
(setq evil-want-C-u-scroll t)

(use-package evil
  :ensure t
  :demand t
  :config
  (evil-mode 1))

(elpaca-wait)

(use-package evil-collection
  :ensure (:wait t)
  :after evil
  :demand t
  :config
  (evil-collection-init))

(elpaca-wait)

(use-package which-key
  :ensure t
  :demand t
  :diminish which-key-mode
  :config
  (which-key-mode))

(use-package vertico
  :ensure t
  :demand t
  :bind (:map vertico-map
	      ;; Navigation
              ("C-j" . vertico-next)
	      ("C-k" . vertico-previous)
              ("C-d" . vertico-scroll-down)
              ("C-u" . vertico-scroll-up)
              ;; Directory navigation (vertico-directory)
              ("C-h" . vertico-directory-delete-char)
              ("C-l" . vertico-directory-enter)
              ("M-h" . vertico-directory-delete-word))
  :config
  (vertico-mode 1))

(use-package vertico-directory
  :after vertico
  :ensure nil
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy))

(use-package orderless
   :ensure t
   :demand t
   :custom
   (completion-styles '(orderless basic))
   (completion-category-defaults nil)
   (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package marginalia
  :ensure t
  :demand t
  :config
  (marginalia-mode))

(use-package consult
  :ensure t
  :demand t)

;; Customize ripgrep args
(setq consult-ripgrep-args
      "rg --null --line-buffered --color=never --max-columns=1000 \
       --path-separator / --smart-case --no-heading \
       --with-filename --line-number --search-zip \
       --hidden")  ;; tilføj --hidden for at søge i skjulte filer

(use-package embark
  :ensure t
  :demand t
  :bind (("C-." . embark-act)
         ("C-;" . embark-dwim)
         ("C-h B" . embark-bindings)
         :map minibuffer-local-map
         ("C-." . embark-act)
         ("C-c C-e" . embark-export))
  
  :init
  ;; Vis hjælp for prefixes med embark
  (setq prefix-help-command #'embark-prefix-help-command)
  
  :config
  ;; Skjul standard modeline i embark
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

(use-package embark-consult
  :ensure t
  :after (embark consult)
  :demand t
  :hook (embark-collect-mode . consult-preview-at-point-mode))

(use-package avy
    :ensure t
    :defer t
    :config
    (setq avy-background t
  	  avy-style 'de-bruijn)

    (setq avy-keys '(?s ?n ?t ?h ?k ?a ?e ?i ?r)))

  ;; Kopier en linje med avy
;; (defun avy-copy-line ()
;;   (interactive)
;;   (save-excursion
;;     (avy-goto-line)
;;     (kill-ring-save (line-beginning-position) (line-end-position))))

;; ;; Flyt til linje og slet den
;; (defun avy-kill-line ()
;;   (interactive)
;;   (avy-goto-line)
;;   (kill-whole-line))

(global-set-key (kbd "C-c l c") 'avy-copy-line)
(global-set-key (kbd "C-c l k") 'avy-kill-line)

(use-package ace-window
  :ensure t
  :demand t
  :bind ("M-o" . ace-window)
  :config
  (setq aw-keys '(?s ?n ?t ?h ?k ?a ?e ?i ?r)))

(elpaca-wait)

(use-package general
  :ensure t
  :after evil
  :demand t
  :config
  (general-create-definer my-leader-def
    :states '(normal visual emacs)
    :keymaps 'override
    :prefix "SPC")
  
  (my-leader-def

    ;; Shortcuts
    "," 'switch-to-buffer
    "rr" 'reload-init-file
    "RET" 'bookmark-jump
    

    ;; buffers
    "b" '(:ignore t :which-key "buffers")
    "bb" 'switch-to-buffer
    "bk" 'kill-buffer
    ;;"bl" 'list-buffers
    "bl" 'next-buffer
    "bh" 'previous-buffer


    ;; frames
    ;; "a" '(:ignore t :which-key "frames")
    ;; embark
    "a" '(embark-act :which-key "embark act")
    "A" '(embark-dwim :which-key "embark dwim")
    
    ;; consult
    "c" '(:ignore t :which-key "consult")
    "cy" 'consult-yank-pop
    "cb" 'consult-buffer

    ;; dired
    "d" '(:ignore t :which-key "dired")
    "dp" #'my/dired-preview-toggle 

    "e" '(:ignore t :which-key "errors")
    "el" 'flycheck-list-errors
    "en" 'flycheck-next-error
    "ep" 'flycheck-previous-error
    "ev" 'flycheck-verify-setup
    "es" 'flycheck-select-checker
    "ec" 'flycheck-clear

    ;; files
    "f" '(:ignore t :which-key "files")
    "ff" 'find-file
    "fs" 'save-buffer
    "fr" 'open-recent-files
    "fS" 'write-file
    "fW" 'write-region
    "fo" 'ff-find-other-file
    "fO" 'ff-find-other-file-other-window 

    ;; help
    "h" '(:ignore t :which-key "help")
    "hk" 'describe-key
    "hK" 'describe-keymap
    "hm" 'describe-mode
    "hb" 'describe-bindings

    ;; avy
    "j" '(:ignore t :which-key "avy")
    "jj" 'avy-goto-char-2
    "jl" 'avy-goto-line
    "jw" 'avy-goto-word-1
    "jc" 'avy-copy-line
    "jC" 'avy-copy-region
    "jk" 'avy-kill-whole-line
    "jK" 'avy-kill-region
    
    ;; lsp
    "ll" '(:ignore t :which-key "lsp")
    "la" 'lsp-execute-code-action        ;; code actions
    "lr" 'lsp-rename                      ;; rename symbol
    "lf" 'lsp-format-buffer               ;; format
    "lF" 'lsp-format-region               ;; format region
    "ld" 'lsp-find-definition             ;; go to definition
    "lD" 'lsp-find-declaration            ;; go to declaration
    "li" 'lsp-find-implementation         ;; go to implementation
    "lt" 'lsp-find-type-definition        ;; go to type def
    "lR" 'lsp-find-references             ;; find references
    "ls" 'lsp-describe-thing-at-point     ;; show docs
    "lh" 'lsp-ui-doc-show                 ;; show hover
    "ll" 'lsp-workspace-show-log          ;; show log
    "lq" 'lsp-workspace-restart         ;; restart 		   
    "lK" 'lsp-ui-doc-show           ;; Hover docs
    "lgd" 'lsp-ui-peek-find-definitions
    "lgp" 'lsp-ui-peek-find-references

     ;;;;
    ;; org
     ;;;;
    "mc" 'org-capture 

    ;; org-agenda
    "m" '(:ignore t :which-key "org-agenda")
    "mt" 'org-todo
    "ma" 'org-agenda

    ;; org-roam
    ;; Find/Create
    "nr" '(:ignore t :which-key "nodes")
    "nrf" '(org-roam-node-find :which-key "find node")
    "nri" '(org-roam-node-insert :which-key "insert node")

    "nc" '(org-roam-capture :which-key "capture")

    ;; Buffer/Graph
    "nl" '(org-roam-buffer-toggle :which-key "toggle buffer")
    "ng" '(org-roam-graph :which-key "graph")
    "nu" '(org-roam-ui-open :which-key "ui")

    ;; Dailies
    "nd" '(:ignore t :which-key "dailies")
    "ndt" '(org-roam-dailies-goto-today :which-key "today")
    "ndd" '(org-roam-dailies-goto-date :which-key "date")
    "ndy" '(org-roam-dailies-goto-yesterday :which-key "yesterday")
    "ndm" '(org-roam-dailies-goto-tomorrow :which-key "tomorrow")
    "ndc" '(org-roam-dailies-capture-today :which-key "capture today")

    ;; Sync
    "ns" '(org-roam-db-sync :which-key "sync db")
    ;; "n" '(:ignore t :which-key "org-roam")
    ;; "ni" 'org-roam-node-insert
    ;; "nf" 'org-roam-node-find
    ;; "nl" 'org-roam-buffer-toggle
    ;; "nc" 'org-roam-capture 

    ;; projectile
    "p" '(:ignore t :which-key "project")
    "pp" 'projectile-switch-project
    "pf" 'projectile-find-file
    "pb" 'projectile-switch-to-buffer
    "pd" 'projectile-find-dir
    "pr" 'projectile-recentf
    "pc" 'projectile-compile-project
    "pR" 'projectile-run-project
    "ps" 'consult-ripgrep

    ;; olivetti
    "t" '(:ignore t :which-key "olivetti")
    "tf" '(my/distraction-free :which-key "focus mode")

    ;; consult-line
    "/" 'consult-line
    "s" '(:ignore t :which-key "search")
    "ss" 'consult-line
    "sl" 'consult-line
    ;; consult-rigprep
    "sp" 'consult-ripgrep
    "sw" '(my/consult-ripgrep-at-point :which-key "consult-ripgrep on word under cursor")

    ;; vterm
    "v" '(:ignore t :which-key "vterm")
    "vt" 'multi-vterm
    "vk" 'multi-vterm-next
    "vj" 'multi-vterm-prev
    "vd" 'multi-vterm-dedicated-toggle

    ;; windows
    "w" '(:ignore t :which-key "windows")
    "wh" 'evil-window-left
    "wH" '+evil/window-move-left
    "wk" 'evil-window-up
    "wK" '+evil/window-move-up
    "wj" 'evil-window-down
    "wJ" '+evil/window-move-down
    "wl" 'evil-window-right
    "wL" '+evil/window-move-right
    "wd" 'delete-window 
    "wn" 'evil-window-new
    "wv" 'split-window-right
    "ws" 'split-window-below
    ;; frames

    "wN" 'make-frame
    "wC" 'clone-frame
    "wcs" '((lambda () (interactive) (set-frame-font "Comic Sans MS")) :which-key "Comic Sans Frame") 

    ;; quit
    "q" '(:ignore t :which-key "quit")
    "qq" 'save-buffers-kill-terminal

    ;;evil-numbers
    "+" 'evil-numbers/inc-at-pt
    "-" 'evil-numbers/dec-at-pt)



    ;;;;;;
  ;; keybindings uden leader key
    ;;;;;;
  (general-define-key
   :states 'emacs
   "bb" '(previous-buffer :which-key "Buffer back")
   "BB" '(next-buffer :which-key "Buffer forward"))

  (general-define-key
   :states 'insert
   "C-a" 'beginning-of-line
   "C-e" 'end-of-line)

  (general-define-key
   :states 'visual
   "*" 'evil-visualstar/begin-search-forward
   "#" 'evil-visualstar/begin-search-backward)

  (general-define-key
   :states 'operator
   :prefix "SPC"
   "j" '(:ignore t :which-key "avy")
   "jj" 'avy-goto-char-2
   "jl" 'avy-goto-line
   "jw" 'avy-goto-word-1)
   ;; "jc" 'avy-copy-line
   ;; "jC" 'avy-copy-region
   ;; "jk" 'avy-kill-whole-line
   ;; "jK" 'avy-kill-region)

   (general-define-key
    :states 'normal
    "/" 'consult-line
    "?" 'consult-line
    "C->" 'lispyville->
    "C-<" 'lispyville-<
    "]e" 'flycheck-next-error       ;; næste fejl (som ]d i vim)
    "[e" 'flycheck-previous-error   ;; forrige fejl (som [d i vim)
    "]E" 'flycheck-first-error      ;; første fejl
    "[E" 'flycheck-last-error)      ;; sidste fejl

   (general-define-key
    :states '(normal visual operator)
    "s" 'avy-goto-char-2       ;; s = snipe (erstatter evil-substitute)
    "S" 'avy-goto-line         ;; S = snipe til linje
    "gs" 'avy-goto-word-1)     ;; gs = goto word

   ;; (general-define-key
   ;;  :states 'operator
   ;;  "s" 'avy-goto-char-2)
   
   (general-create-definer my-evil-mc-def
     :states '(normal visual)
     :prefix "gr"
     :prefix-name "evil-mc")

   (my-evil-mc-def
     "" '(:ignore t :which-key "evil-mc")
     "m" '(evil-mc-make-and-goto-next-match :wk "match →")
     "M" '(evil-mc-make-and-goto-prev-match :wk "match ←")
     "j" '(evil-mc-make-cursor-move-next-line :wk "↓")
     "k" '(evil-mc-make-cursor-move-prev-line :wk "↑")
     "J" '(evil-mc-make-cursor-move-last-line :wk "last ↓")
     "K" '(evil-mc-make-cursor-move-first-line :wk "first ↑")
     "u" '(evil-mc-undo-last-added-cursor :wk "undo")
     "q" '(evil-mc-undo-all-cursors :wk "quit")
     "p" '(evil-mc-pause-cursors :wk "pause")
     "r" '(evil-mc-resume-cursors :wk "resume"))

   ;; Visual mode extras
   (general-define-key
    :states 'visual
    :prefix "gr"
    "A" '(evil-mc-make-cursor-in-visual-selection-beg :wk "each line")
    "I" '(evil-mc-make-cursor-in-visual-selection-end :wk "line start")
    "a" '(evil-mc-make-all-cursors :wk "all matches")))

  (use-package key-chord
    :ensure t
    :config
    (setq key-chord-one-key-delay 0.2)
    (key-chord-mode 1)
    (key-chord-define evil-normal-state-map "bb" 'previous-buffer)
    (key-chord-define evil-normal-state-map "BB" 'next-buffer)
    (key-chord-define evil-motion-state-map "bb" 'previous-buffer)
    (key-chord-define evil-motion-state-map "BB" 'next-buffer))

(use-package evil-escape
  :ensure t
  :demand t
  :after evil
  :config
  (evil-escape-mode 1)
  (setq evil-escape-key-sequence "hh")
  (setq evil-escape-delay 0.2)) ;; ventetid i sekunder for sekvensen



(use-package evil-surround
  :ensure t
  :demand t
  :after evil 
  :config
  (global-evil-surround-mode 1))

(use-package evil-nerd-commenter
  :ensure t
  :demand t
  :after evil
  :config
  (evilnc-default-hotkeys))


(use-package evil-cleverparens
  :ensure t
  :hook ((lisp-mode emacs-lisp-mode scheme-mode clojure-mode) . 
  	 evil-cleverparens-mode))

(use-package evil-indent-plus
  :ensure t
  :demand t
  :after evil
  :config
  (evil-indent-plus-default-bindings))

(use-package evil-goggles
  :ensure t
  :demand t
  :after evil
  :config
  (evil-goggles-mode)
  
  ;; Juster duration (hvor længe highlight vises)
  (setq evil-goggles-duration 0.100) ; 100ms (default er 200ms)
  
  ;; Enable alle highlights
  (setq evil-goggles-enable-delete t)
  (setq evil-goggles-enable-change t)
  (setq evil-goggles-enable-yank t)
  (setq evil-goggles-enable-paste t)
  (setq evil-goggles-enable-indent t)
  (setq evil-goggles-enable-join t)
  (setq evil-goggles-enable-fill-and-move t)
  (setq evil-goggles-enable-shift t))

(use-package evil-mc
  :ensure t
  :demand t
  :after evil
  :config
  (global-evil-mc-mode 1))

(use-package evil-matchit
  :ensure t
  :demand t
  :after evil
  :config
  (global-evil-matchit-mode 1))

(use-package evil-numbers
  :ensure t
  :demand t
  :after evil)

(use-package evil-args
  :ensure t
  :demand t
  :after evil
  :config
  ;; bind evil-args text objects
  (define-key evil-inner-text-objects-map "a" 'evil-inner-arg)
  (define-key evil-outer-text-objects-map "a" 'evil-outer-arg)

  ;; bind evil-forward/backward-args
  (define-key evil-normal-state-map "L" 'evil-forward-arg)
  (define-key evil-normal-state-map "H" 'evil-backward-arg)

  ;; swapping arguments
  (define-key evil-normal-state-map "gL" 'evil-forward-arg)
  (define-key evil-normal-state-map "gH" 'evil-backward-arg))

(use-package evil-lion
  :ensure t
  :demand t
  :after evil
  :config
  (evil-lion-mode))

(use-package evil-visualstar
  :ensure t
  :demand t
  :config
  (evil-visualstar-mode))

(use-package evil-snipe
  :ensure t
  :demand t
  :after evil
  :config
  (evil-snipe-mode 1)
  (evil-snipe-override-mode 1)

  ;; Snipe settings
  (setq evil-snipe-scope 'line              ; kun nuværende linje
	evil-snipe-repeat-scope 'visible    ; men ; og , søger visible buffer
	evil-snipe-smart-case t))

(elpaca-wait)

;;  Enable ligatures in programming modes                                                           
(use-package ligature
  :ensure t
  :defer t
  :config
  (ligature-set-ligatures 't '("www"))
  (ligature-set-ligatures 'prog-mode '("www" "**" "***" "**/" "*>" "*/" "\\\\" "\\\\\\" "{-" "::"
                                       ":::" ":=" "!!" "!=" "!==" "-}" "----" "-->" "->" "->>"
                                       "-<" "-<<" "-~" "#{" "#[" "##" "###" "####" "#(" "#?" "#_"
                                       "#_(" ".-" ".=" ".." "..<" "..." "?=" "??" ";;" "/*" "/**"
                                       "/=" "/==" "/>" "//" "///" "&&" "||" "||=" "|=" "|>" "^=" "$>"
                                       "++" "+++" "+>" "=:=" "==" "===" "==>" "=>" "=>>" "<="
                                       "=<<" "=/=" ">-" ">=" ">=>" ">>" ">>-" ">>=" ">>>" "<*"
                                       "<*>" "<|" "<|>" "<$" "<$>" "<!--" "<-" "<--" "<->" "<+"
                                       "<+>" "<=" "<==" "<=>" "<=<" "<>" "<<" "<<-" "<<=" "<<<"
                                       "<~" "<~~" "</" "</>" "~@" "~-" "~>" "~~" "~~>" "%%"))
  (global-ligature-mode 't))

(use-package doom-modeline
  :ensure t
  :demand t
  :init
  (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))

(use-package rainbow-delimiters
  :ensure t
  :defer t
  :hook ((prog-mode org-mode) . rainbow-delimiters-mode))

;; Turn on line numbers in buffer
(add-hook 'prog-mode-hook #'display-line-numbers-mode)

(use-package company
  :ensure t
  :hook ((prog-mode . company-mode)
         (org-mode . company-mode)
         (text-mode . company-mode)))

(use-package company-org-block
  :ensure t
  :after company
  :hook (org-mode . (lambda ()
		      (add-to-list (make-local-variable
				    'company-backends)
				   'company-org-block)))
		       
  :config 
  (setq company-org-block-edit-style 'auto)) ;; Justér efter behov
;; (add-hook 'org-mode-hook
;;           (lambda ()
;;             (add-to-list (make-local-variable 'company-backends)
;;                          'company-org-block)))


;; ;;(use-package corfu
;;	:ensure t)
;;(global-corfu-mode -1)

(use-package yasnippet
 :ensure t
 :hook ((prog-mode text-mode conf-mode snippet-mode) . yas-minor-mode)
 :config
 (yas-global-mode 1))

(use-package consult-yasnippet
  :ensure t
  :after (consult yasnippet)
  :bind
  ("C-c y y" . consult-yasnippet)
  ("C-c y s" . yas-insert-snippet)
  ("C-c y n" . yas-new-snippet)
  ("C-c y v" . yas-visit-snippet-file))

(use-package lsp-mode
  :ensure t
  :hook ((c-mode . lsp)
         (c-ts-mode . lsp)
  	 (python-mode . lsp-deferred)
         (csharp-mode . lsp)
         (sh-mode . lsp-deferred)
         (typst-ts-mode . lsp-deferred))
  
  :commands (lsp lsp-deferred)
  :custom
  (lsp-typst-server-path "tinymist")
  (lsp-enable-symbol-highlighting t)
  (lsp-headerline-breadcrumb-enable t)
  :config
  (setq lsp-diagnostics-provider :flycheck)
  ;; Disable lsp's egen UI for fejl (hvis du bruger flycheck)
  (setq lsp-ui-sideline-show-diagnostics nil) ; hvis du bruger lsp-ui

  
  (add-to-list 'lsp-language-id-configuration '(typst-ts-mode . "typst"))
  (lsp-register-client
   (make-lsp-client
    :new-connection (lsp-stdio-connection '("tinymist"))
    :activation-fn (lsp-activate-on "typst")
    :server-id 'tinymist
    :major-modes '(typst-ts-mode))))

;; Disable specifikke checkers (hvis de konflikter med LSP)
(setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc))

;; Python: brug kun LSP, ikke pylint/flake8
(add-hook 'python-mode-hook
          (lambda ()
            (setq flycheck-disabled-checkers '(python-pylint python-flake8))))
(use-package lsp-ui
  :ensure t
  :after lsp-mode
  :custom
  (lsp-ui-doc-enable t)
  (lsp-ui-doc-position 'top)
  (lsp-ui-sideline-enable t)
  (lsp-ui-sideline-show-hover t)
  (lsp-ui-sideline-show-diagnostics t)
  (lsp-ui-sideline-show-code-actions t)
  :hook (lsp-mode . lsp-ui-mode))

(use-package treesit
  :ensure nil
  :init
  ;; Emacs 29+ har tree-sitter built-in
  (setq treesit-language-source-alist
      '((c "https://github.com/tree-sitter/tree-sitter-c" "v0.20.6")
        (cpp "https://github.com/tree-sitter/tree-sitter-cpp" "v0.20.3")
        (python "https://github.com/tree-sitter/tree-sitter-python" "v0.20.4")
        (bash "https://github.com/tree-sitter/tree-sitter-bash" "v0.20.4")
        (rust "https://github.com/tree-sitter/tree-sitter-rust" "v0.20.4")
        (typst "https://github.com/Typst/typst/tree/main/emacs/typst-ts-mode")
        (elisp "https://github.com/Wilfred/tree-sitter-elisp")))

  :config
  ;; Remap major modes to tree-sitter versions
  (setq major-mode-remap-alist
	'((c-mode . c-ts-mode)
          (c++-mode . c++-ts-mode)
          (python-mode . python-ts-mode)
          (bash-mode . bash-ts-mode)
          (css-mode . css-ts-mode)
          (javascript-mode . js-ts-mode)
          (json-mode . json-ts-mode)
          (rust-mode . rust-ts-mode))))

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode)
  
  :config
  (setq flycheck-check-syntax-automatically '(save mode-enabled)
        flycheck-display-errors-delay 0.3))

(use-package flycheck-inline
  :ensure t
  :defer t
  :after flycheck
  :hook (flycheck-mode . flycheck-inline-mode))

(use-package flycheck-color-mode-line
  :ensure t
  :defer t
  :after flycheck
  :hook (flycheck-mode . flycheck-color-mode-line-mode))

(use-package flycheck-posframe
  :ensure t
  :defer t
  :after flycheck
  :hook (flycheck-mode . flycheck-posframe-mode)
  :config
  (setq flycheck-posframe-position 'point-bottom-left-corner))

(use-package hydra 
  :ensure t
  :defer t)

;; Disable cleverparens når lispyville overtager
(use-package lispyville
  :ensure t
  :hook ((emacs-lisp-mode lisp-mode) . lispyville-mode)
  :config
  (lispyville-set-key-theme
   '(operators
     c-w
     slurp/barf-cp    ; Genbrug dine > og < muscle memory!
     prettify
     text-objects
     atom-movement
     additional))
  (add-hook 'org-src-mode-hook
          (lambda ()
              (when (derived-mode-p 'lisp-mode 
                                  'emacs-lisp-mode 
                                  'clojure-mode 
                                  'scheme-mode)
              (lispyville-mode 1)))))

(use-package projectile
  :ensure t
  :demand t
  :init
  ;; C compile kommando 
  (setq projectile-project-compilation-cmd "make")
  ;; (setq projectile-globally-ignored-directories
  ;;   '(".dSYM" "build" ".git"))

  ;; (setq projectile-globally-ignored-files
  ;;   '("#*" "~*" ))  ;; Ignorer filer som ender med #



  :config
  (projectile-mode +1)
  (setq projectile-globally-ignored-directories
	(append projectile-globally-ignored-directories '("build" "bin" ".obj")))
  (setq projectile-globally-ignored-files
	(append projectile-globally-ignored-files '("*.0" "*.a")))
  (setq projectile-globally-ignored-file-suffixes
	(append projectile-globally-ignored-file-suffixes '("#" "~"))))

(use-package transient
    :ensure (:host github 
             :repo "magit/transient"
             :branch "main"
             :depth nil)  ;; full history (ikke shallow)
    :demand t)
(elpaca-wait)
    (use-package magit
      :ensure t
      :commands magit-status)

(use-package org
  :ensure nil
  :defer t
  :mode ("\\.org\\'" . org-mode)
  :commands (org-capture org-agenda))

(use-package org-modern
  :ensure t
  :after org
  :hook ((org-mode . org-modern-mode)
	 (org-mode . org-indent-mode)))
(use-package evil-org
  :ensure t
  :after org
  :hook (org-mode . (lambda () (evil-org-mode)))
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))


(setq org-todo-keywords
      '((sequence
         "TODO(t)"
         "PROJ(p)"
         "STRT(s)"
         "WAIT(w)"
         "HOLD(h)"
         "|"
         "DONE(d)"
         "KILL(k)")
        (sequence
         "[ ](T)"
         "[-](S)"
         "[?](W)"
         "|"
         "[X](D)")))

(setq org-todo-keyword-faces
      '(("TODO" . (:foreground "#ff6c6b" :weight bold))
        ("PROJ" . (:foreground "#da8548" :weight bold))
        ("STRT" . (:foreground "#ECBE7B" :weight bold))
        ("WAIT" . (:foreground "#51afef" :weight bold))
        ("HOLD" . (:foreground "#c678dd" :weight bold))
        ("DONE" . (:foreground "#98be65" :weight bold))
        ("KILL" . (:foreground "#5B6268" :weight bold))
        ("[ ]"  . (:foreground "#ff6c6b" :weight bold))
        ("[-]"  . (:foreground "#ECBE7B" :weight bold))
        ("[?]"  . (:foreground "#51afef" :weight bold))
        ("[X]"  . (:foreground "#98be65" :weight bold))))

(setq org-capture-templates
'(("t" "Tasks")
  ("tt" "Unscheduled task" entry (file+headline "~/Documents/org/agenda/inbox.org" "Tasks")
   "* TODO %?")
  ("tD" "Task with deadline" entry (file+headline "~/Documents/org/agenda/inbox.org" "Task with deadline")
   "* TODO %? DEADLINE: %^{Deadline date}t\n %i"
   :time-prompt t)
   ("ts" "Scheduled task" entry (file+headline "~/Documents/org/agenda/dayplanner.org" "Tasks")
   "* TODO %? SCHEDULED: %^{Schedule date}t\n  %i\n"
   :time-prompt t)
  ("td" "Scheduled task with deadline" entry (file+headline "~/Documents/org/agenda/dayplanner.org" "Tasks")
   "* TODO %? SCHEDULED: %^{Schedule date}t DEADLINE: %^{Deadline}t\n  %i\n"
   :time-prompt t)

  ;; ("md" "Daily entry" entry
  ;;  (file+datetree "~/Documents/org/moodnotes.org")
  ;;  "* Dagens rating: %? \n** Uro: \n** Noter: \n** Motion: \n** Vågen: \n** Sengetid: \n** Medicin:")
  ;; ("mu" "Uddybende noter" entry
  ;;  (file+datetree "~/Documents/org/moodnotes.org")
  ;;  "Noter: %?")

  ("d" "Dayplanner")
  ("dd" "Dayplanner" entry
   (file+datetree "~/Documents/org/agenda/dayplanner.org")
   "** Morgen \n*** [ ] Aflever\n*** [ ] Tossefit\n** Formiddag \n %? \n** Frokost \n\n** Eftermiddag \n\n** Eftermiddag 2 \n*** [ ] Hente \n*** [ ] Tossefit \n** Aften "
   :time-prompt t)
  ("dt" "Task in dayplanner" entry
   (file+datetree "~/Documents/org/agenda/dayplanner.org")
   "TODO %?"
   :time-prompt t)
  ("dc" "Task in dayplanner with link to context" entry
   (file+datetree "~/Documents/org/agenda/dayplanner.org")
   "TODO %?\n %a"
   :time-prompt t)
  ("dn" "Add note to a day in dayplanner" entry
   (file+datetree "~/Documents/org/agenda/dayplanner.org")
   "** Note: %?"
   :time-prompt t)

  ("e" "Emails")
  ("eu" "Urgent response" entry
   (file+headline "~/Documents/org/agenda/inbox.org" "Urgent emails")
   "* TODO Respond to %? DEADLINE: %^{Deadline date}t \nSubject: ")
  ("en" "Non-urgent response" entry
   (file+headline "~/Documents/org/agenda/inbox.org" "Non-urgent emails")
   "* TODO Respond to %? \n Subject: ")))

;; (add-hook 'org-capture-after-finalize-hook
;;         (lambda ()
;;           (when (and (derived-mode-p 'org-mode)
;;                      (string= org-capture-entry "ts")) ;; "t" er template key
;;             (org-sort-entries nil ?d))))

;; Set the directory where your Org files are located
(with-eval-after-load 'org
  (setq org-agenda-files
	  (directory-files-recursively "~/Documents/org/agenda" "\\.org$")))

(use-package org-superstar
  :ensure t
  :hook (org-mode . org-superstar-mode)
  :config
  ;; Customize the bullets for headings
  (setq org-superstar-headline-bullets-list '("★" "◉" "○" "•" "◆"))
  ;; Customize list item bullets (optional)
  (setq org-superstar-item-bullet-alist '((?- . ?•) (?+ . ?◦)))
  ;; Remove leading stars if desired
  (setq org-superstar-remove-leading-stars t))
;; Archive tasks to a separate file in the same directory
(setq org-archive-location "%%s_archive::")

(use-package org-super-agenda
  :ensure t
  :after org
  :config
  (org-super-agenda-mode 1)
  (setq org-super-agenda-groups
	'((:name "Today"
		 :time-grid t
		 :date today)
	    (:name "Important"
		 :priority "A")
	    (:name "Due Soon"
		 :deadline future)
	    (:name "Overdue"
		 :deadline past
		 :face error)
	    (:name "To Read"
		 :tag "read")
	    (:name "Waiting"
		 :todo "WAIT")
	    (:name "Personal"
		 :tag "personal")
	    (:name "Work"
		 :tag "work"))))

(use-package org-roam
  :ensure t
  :init
  (setq org-roam-v2-ack t)
  :commands (org-roam-node-find
	     org-node-insert
	     org-roam-buffer-toggle)
  :custom
  (org-roam-directory "~/Documents/org/org-roam/")  ; Din org-roam mappe
  ;;(org-roam-completion-everywhere t)
  :config
  (org-roam-db-autosync-mode))


(use-package org-roam-ui
  :ensure t
  :after org-roam
  :custom
  (org-roam-ui-sync-theme t)
  (org-roam-ui-follow t)
  (org-roam-ui-update-on-save t)
  (org-roam-ui-open-on-start t))

(use-package ts
  :ensure t)

(org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (python . t)))

(setq org-confirm-babel-evaluate nil)
(setq org-babel-python-command "python3")

(use-package vterm
  :ensure t
  :defer t)
(use-package multi-vterm
  :ensure t
  :defer t
  :config
  (setq multi-vterm-dedicated-height-percent 30))

(use-package vterm-hotkey
  :ensure t
  :defer t)

(use-package dired
  :ensure nil
  :commands (dired dired-jump)
  :custom
  (dired-listing-switches "-agho --group-directories-first")
  :config
  (setq dired-create-destination-dirs 'ask)
  (general-define-key
   :states 'normal
   :keymaps 'dired-mode-map
   
   ;; Navigation (Vim-style)
   "h" 'dired-up-directory
   "l" 'dired-find-file
   "j" 'dired-next-line
   "k" 'dired-previous-line
   "gg" 'beginning-of-buffer
   "G" 'end-of-buffer
   
   ;; Actions
   "o" 'dired-find-file-other-window
   "v" 'dired-view-file
   "q" 'quit-window
   
   ;; File operations
   "d" 'dired-flag-file-deletion
   "x" 'dired-do-flagged-delete
   "D" 'dired-do-delete
   
   ;; Marking
   "m" 'dired-mark
   "u" 'dired-unmark
   "U" 'dired-unmark-all-marks
   
   ;; Create
   "+" 'dired-create-directory))

(use-package dired-preview
  :ensure t
  :defer t)

(use-package olivetti
  :ensure t
  :defer t
  :config
  (setq olivetti-body-width 100)
  
  ;; Custom distraction-free function
  (defun my/distraction-free ()
    "Toggle distraction-free writing mode."
    (interactive)
    (if olivetti-mode
        (progn
          (olivetti-mode -1)
          (setq mode-line-format (default-value 'mode-line-format))
          (when (bound-and-p 'display-line-numbers)
            (setq display-line-numbers t)))
      (progn
        (olivetti-mode 1)
        (setq-local mode-line-format nil)
        (when (bound-and-p 'display-line-numbers)
          (setq display-line-numbers nil))))))

(use-package websocket
  :ensure t)

(use-package typst-ts-mode
  :ensure t ;;(:type git :host sourcehut :repo "meow_king/typst-ts-mode")
  :mode ("\\.typ\\'" . typst-ts-mode)
  :hook ((typst-ts-mode . lsp-deferred)))

(use-package typst-preview
  ;;:load-path "~/.emacs.d/elpa/typst-preview/" ;; if installed manually
  :ensure (:host github
                 :repo "https://github.com/havarddj/typst-preview.el")
  :defer t
  :after typst-ts-mode
  :init
  (setq typst-preview-autostart t) ; start typst preview automatically when typst-preview-mode is activated
  (setq typst-preview-open-browser-automatically t) ; open browser automatically when typst-preview-start is run
  :custom
  (typst-preview-browser "default") 	; this is the default option
  (typst-preview-invert-colors "no")	; invert colors depending on system theme
  (typst-preview-executable "tinymist preview")) ; choose between tinymist and typst-preview (deprecated!)

(use-package sly
  :ensure t
  :defer t
  :config
  (setq inferior-lisp-program "sbcl"))

(advice-add 'sly-eval-last-expression :around #'my/sly-eval-and-connect)
(advice-add 'sly-eval-defun :around #'my/sly-eval-and-connect)

(use-package geiser
  :ensure t
  :defer t)

(use-package geiser-guile
  :ensure t
  :defer t
  :config
  (setq geiser-guile-binary "guile")
  (setq geiser-active-implementation '(guile)))

(use-package lilypond-mode
  :ensure (:type git
	         :host github
	         :repo "benide/lilypond-mode"
                 :files ("*.el"))
  :mode ("\\.ly$" . LilyPond-mode)
  :commands (LilyPond-mode))

  
  ;; (use-package lilypond-mode
  ;;   :ensure t
  ;;   :defer t
  ;;   :mode ("\\.ly\\'" . Lilypond-mode)
  ;;   :config
  ;;   (setq Lilypond-lilypond-command "/opt/homebrew/bin/lilypond")
  ;;   (setq Lilypond-pdf-command "open"))

(defun reload-init-file ()
    (interactive)
    (load-file user-init-file))

  (defun open-init-file ()
    "Åbn din init.el hurtigt."
    (interactive)
    (find-file user-init-file))


  (defun comic-sans ()
    (interactive)
    (set-face-attribute 'default nil
        		      :font "Comic Sans MS"))

  (defun enable-corfu ()
    (interactive)
    (global-corfu-mode 1)
    (company-mode -1)
    (message "Corfu enabled"))

  (defun enable-company ()
    (interactive)
    (global-corfu-mode -1)
    (company-mode 1)
    (message "Company enabled"))

  (defun show-load-path ()
    "Vis load-path i en midlertidig buffer."
    (interactive)
    (with-output-to-temp-buffer "*Load Path*"
      (princ (mapconcat #'identity load-path "\n"))))

  (global-set-key (kbd "C-c l") 'show-load-path)

  (defun my/consult-ripgrep-at-point ()
    "Search for word at point with consult-ripgrep"
    (interactive)
    (consult-ripgrep nil (thing-at-point 'symbol)))

  (defun my/dired-preview-toggle ()
    "Toggle dired-preview-mode."
    (interactive)
    (if (bound-and-true-p dired-preview-mode)
        (dired-preview-mode -1)
      (dired-preview-mode 1)))

(defun my/add-scheduled-to-string (str)
"Insert 'SCHEDULED: ' before timestamp in STR and return the result."
(if (string-match "<[0-9]\\{4\\}-[0-9]\\{2\\}-[0-9]\\{2\\}" str)
    (concat (substring str 0 (match-beginning 0))
            "SCHEDULED: "
            (substring str (match-beginning 0)))
  str))  ; Return unchanged if no timestamp found

 (defun md-to-org-todo (md-file org-file)
  "Læs en Markdown-fil og tilføj nye linjer som TODOs i en Org-fil."
  (interactive "fMarkdown file: \nfOrg file: ")
  (let ((lines (with-temp-buffer
                 (insert-file-contents md-file)
                 (split-string (buffer-string) "\n" t)))
        (existing-todos (with-temp-buffer
                          (insert-file-contents org-file)
                          (split-string (buffer-string) "\n" t))))
    (dolist (line lines)
      (when (and (not (string-blank-p line))
                 (not (member (concat "* TODO " line) existing-todos)))
        (with-temp-buffer
          (insert-file-contents org-file)
          (goto-char (point-max))
          (insert (concat "\n* TODO " line))
          (write-region (point-min) (point-max) org-file)))))) 

 (defun md-to-org-scheduled-todo (md-file org-file org-scheduled-file)
  "Læs en Markdown-fil og tilføj nye linjer som TODOs i en Org-fil."
  (interactive "fMarkdown file: \nfOrg file: ")
  (let ((lines (with-temp-buffer
                 (insert-file-contents md-file)
                 (split-string (buffer-string) "\n" t)))
        (existing-todos (append
			 (with-temp-buffer
                          (insert-file-contents org-file)
                          (split-string (buffer-string) "\n" t))
			 (with-temp-buffer
			   (insert-file-contents org-scheduled-file)
			   (split-string (buffer-string) "\n" t)))))
    (dolist (line lines)
      (if (string-match "<[0-9]\\{4\\}-[0-9]\\{2\\}-[0-9]\\{2\\}" line)
	  (let ((line-scheduled (my/add-scheduled-to-string line)))
	    (when (and (not (string-blank-p line))
                       (not (member (concat "* TODO " line-scheduled) existing-todos)))
	      (with-temp-buffer
		(insert-file-contents org-scheduled-file)
		(goto-char (point-max))
		(insert (concat "\n* TODO " line-scheduled))
		(write-region (point-min) (point-max) org-scheduled-file))))
	(when (and (not (string-blank-p line))
		   (not (member (concat "* TODO " line) existing-todos)))
	  (with-temp-buffer
	    (insert-file-contents org-file)
	    (goto-char (point-max))
	    (insert (concat "\n* TODO " line))
	    (write-region (point-min) (point-max) org-file))))))) 


(defun my/sly-eval-and-connect (orig-fun &rest args)
  "Ensure SLY is activated before evaluating"
  (unless (sly-connected-p)
    (save-window-excursion (sly))
    (sleep-for 1))
  (apply for-origin args))


(defun my/geiser-eval-and-connect (orig-fun &rest args)
  "Ensure SLY is activated before evaluating"
  (unless (geiser-repl--live-p)
    (save-window-excursion (run-geiser 'guile))
    (sleep-for 1))
  (apply for-origin args))

  ;; Den er ret langsom, men kan evt. være en start.

  (defun show-all-registers-in-buffer ()
    "Vis alle Emacs registra i en ny buffer."
    (interactive)
    (let ((buf (get-buffer-create "*Registers*")))
      (with-current-buffer buf
        (read-only-mode -1)
        (erase-buffer)
        (insert "Emacs Registers:\n\n")
        ;; Gå gennem alle mulige registertegn (ASCII 32-126)
        (dolist (reg (mapcar #'char-to-string (number-sequence 32 126)))
          (let ((content (get-register (string-to-char reg))))
            (when content
              (insert (format "Register %s:\n" reg))
              ;; Hvis content er en string indsættes den direkte
              (if (stringp content)
                  (insert (concat content "\n\n"))
                ;; Ellers forsøges at konvertere til string (eksempelvis point position)
                (insert (format "%S\n\n" content))))))
        (read-only-mode 1)
        (goto-char (point-min)))
      (pop-to-buffer buf)))

(defun +evil/window-move-left ()
  "Move window to the left or create new window if none exists."
  (interactive)
  (progn
    (evil-window-vsplit)
    (evil-window-left 1)))

(defun +evil/window-move-right ()
  "Move window to the right or create new window if none exists."
  (interactive)
  (progn
    (evil-window-vsplit)
    (evil-window-right 1)))

(defun +evil/window-move-up ()
  "Move window up or create new window if none exists."
  (interactive)
  (progn
     (evil-window-split)
     (evil-window-up 1)))

(defun +evil/window-move-down ()
  "Move window down or create new window if none exists."
  (interactive)
  (progn
     (evil-window-split)
     (evil-window-down 1)))

(use-package meow
    :ensure t
    :defer t
    :config
    (defun meow-setup ()
      (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)
      (meow-motion-overwrite-define-key
       '("j" . meow-next)
       '("k" . meow-prev)
       '("<escape>" . ignore))
      (meow-leader-define-key
       '("j" . "H-j")
       '("k" . "H-k")
       '("1" . meow-digit-argument)
       '("2" . meow-digit-argument)
       '("3" . meow-digit-argument)
       '("4" . meow-digit-argument)
       '("5" . meow-digit-argument)
       '("6" . meow-digit-argument)
       '("7" . meow-digit-argument)
       '("8" . meow-digit-argument)
       '("9" . meow-digit-argument)
       '("0" . meow-digit-argument)
       '("/" . meow-keypad-describe-key)
       '("?" . meow-cheatsheet))
      (meow-normal-define-key
       '("0" . meow-expand-0)
       '("9" . meow-expand-9)
       '("8" . meow-expand-8)
       '("7" . meow-expand-7)
       '("6" . meow-expand-6)
       '("5" . meow-expand-5)
       '("4" . meow-expand-4)
       '("3" . meow-expand-3)
       '("2" . meow-expand-2)
       '("1" . meow-expand-1)
       '("-" . negative-argument)
       '(";" . meow-reverse)
       '("," . meow-inner-of-thing)
       '("." . meow-bounds-of-thing)
       '("[" . meow-beginning-of-thing)
       '("]" . meow-end-of-thing)
       '("a" . meow-append)
       '("A" . meow-open-below)
       '("b" . meow-back-word)
       '("B" . meow-back-symbol)
       '("c" . meow-change)
       '("d" . meow-delete)
       '("D" . meow-backward-delete)
       '("e" . meow-next-word)
       '("E" . meow-next-symbol)
       '("f" . meow-find)
       '("g" . meow-cancel-selection)
       '("G" . meow-grab)
       '("h" . meow-left)
       '("H" . meow-left-expand)
       '("i" . meow-insert)
       '("I" . meow-open-above)
       '("j" . meow-next)
       '("J" . meow-next-expand)
       '("k" . meow-prev)
       '("K" . meow-prev-expand)
       '("l" . meow-right)
       '("L" . meow-right-expand)
       '("m" . meow-join)
       '("n" . meow-search)
       '("o" . meow-block)
       '("O" . meow-to-block)
       '("p" . meow-yank)
       '("q" . meow-quit)
       '("Q" . meow-goto-line)
       '("r" . meow-replace)
       '("R" . meow-swap-grab)
       '("s" . meow-kill)
       '("t" . meow-till)
       '("u" . meow-undo)
       '("U" . meow-undo-in-selection)
       '("v" . meow-visit)
       '("w" . meow-mark-word)
       '("W" . meow-mark-symbol)
       ;;'("x" . meow-line)
       '("X" . meow-goto-line)
       '("y" . meow-save)
       '("Y" . meow-sync-grab)
       '("z" . meow-pop-selection)
       '("'" . repeat)
       '("<escape>" . ignore)))

    (meow-setup) 
    (meow-global-mode 0)
    :bind ("C-c t m" . toggle-modal-mode))  ;; Start disabled

;; Toggle function
(defvar modal-mode 'evil
  "Current modal editing mode: 'evil or 'meow")

(defun toggle-modal-mode ()
  "Toggle between Evil mode and Meow mode."
  (interactive)
  (cond
   ((eq modal-mode 'evil)
    (evil-mode -1)
    (meow-global-mode 1)
    (setq modal-mode 'meow)
    (message "Switched to Meow mode (SPC x ? for cheatsheet)"))
   ((eq modal-mode 'meow)
    (meow-global-mode -1)
    (evil-mode 1)
    (evil-collection-init)
    (setq modal-mode 'evil)
    (message "Switched to Evil mode"))))

;; Vælg hvilken mode der skal starte
(if (eq modal-mode 'evil)
    (progn
      (evil-mode 1)
      (evil-collection-init))
  (meow-global-mode 1))

;; Bind toggle
(global-set-key (kbd "C-c t m") 'toggle-modal-mode)

;;(md-to-org-todo "/Users/andersskibsted/Library/Mobile Documents/iCloud~md~obsidian/Documents/Org-agenda/Org-agenda.md" "~/Documents/org/agenda/inbox.org")
(md-to-org-scheduled-todo "/Users/andersskibsted/Library/Mobile Documents/iCloud~md~obsidian/Documents/Org-agenda/Org-agenda.md" "~/Documents/org/agenda/inbox.org" "~/Documents/org/agenda/dayplanner.org")
