;; Basic clean configuration
(setq inhibit-startup-message t)
(menu-bar-mode 1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; (defvar default-font "JetBrains Mono")
(defvar default-font "DejaVu Sans Mono")
(defvar default-font-size 14)

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("elpa" . "https://elpa.gnu.org/packages/") t)
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)
(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(company company-org-block consult corfu evil marginalia orderless
	     org-modern vertico which-key-posframe)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; (load-theme 'tango-dark t)
(load-theme 'wombat t)

(set-face-attribute 'default nil
      		    ;;:family default-font
      		    ;;:height (* default-font-size 10))
      		    ;; :font "DejaVu Sans Mono-14") ;; erstat med ønsket font og størrelse
      		    :font "Fira Code Retina" :height 140)
  ;; (use-package fira-code-mode
  ;;   :custom (fira-code-mode-disabled-ligatures '("[]" "#{" "#(" "#_" "#_(" "x")) ;; List of ligatures to turn off
  ;;   :hook prog-mode) ;; Enables fira-code-mode automatically for programming major modes
    ;; Enable the www ligature in every possible major mode

;;  Enable ligatures in programming modes                                                           
(use-package ligature
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

(add-hook 'text-mode-hook (lambda () (set-input-method "danish-postfix")))

(use-package evil
  :ensure t
  :init
  (setq evil-want-keybinding nil)
  (setq evil-want-integration t)
  (setq evil-want-C-u-scroll t)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-a") 'beginning-of-line)
  (define-key evil-insert-state-map (kbd "C-e") 'end-of-line))
    
(use-package evil-collection
  :ensure t
  :after evil
  :config
      (evil-collection-init))
(use-package evil-escape
  :ensure t
  :config
  (evil-escape-mode 1)
  (setq evil-escape-key-sequence "hh")
  (setq evil-escape-delay 0.2)) ;; ventetid i sekunder for sekvensen



(use-package evil-surround
  :ensure t
  :config
  (evil-surround-mode 1))
(use-package evil-nerd-commenter
  :ensure t
  :config
  (evilnc-default-hotkeys))

(use-package meow
    :ensure t
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
    (meow-global-mode 0))  ;; Start disabled

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

(require 'company)
(global-company-mode 1)

(require 'company-org-block)
(setq company-org-block-edit-style 'auto) ;; Justér efter behov

(add-hook 'org-mode-hook
          (lambda ()
            (add-to-list (make-local-variable 'company-backends)
                         'company-org-block)))


(require 'corfu)
(global-corfu-mode -1)

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

(require 'which-key)
(which-key-mode)

(require 'consult)
(global-set-key (kbd "C-x e") #'consult-buffer)

(require 'vertico)
(vertico-mode 1)
(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles basic partial-completion)))))


(require 'marginalia)
(marginalia-mode)

(use-package doom-modeline
	      :ensure t
	      :init
	      (doom-modeline-mode 1)
	      :custom ((doom-modeline-height 15)))

(defun reload-init-file ()
    (interactive)
    (load-file user-init-file))

  (defun open-init-file ()
    "Åbn din init.el hurtigt."
    (interactive)
    (find-file user-init-file))

  (defun open-config-file ()
    "Åbn config.org"
    (interactive)
    (find-file "~/.emacs.d/config.org"))

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

(defun +evil/window-move-left ()
  "Move window to the left or create new window if none exists."
  (interactive)
  (progn
    (evil-window-vsplit)
    (evil-window-left)))

(defun +evil/window-move-right ()
  "Move window to the right or create new window if none exists."
  (interactive)
  (progn
    (evil-window-vsplit)
    (evil-window-right)))

(defun +evil/window-move-up ()
  "Move window up or create new window if none exists."
  (interactive)
  (progn
     (evil-window-split)
     (evil-window-up)))

(defun +evil/window-move-down ()
  "Move window down or create new window if none exists."
  (interactive)
  (progn
     (evil-window-split)
     (evil-window-down)))

(global-set-key (kbd "C-c i") 'open-config-file)
;;(global-set-key (kbd "C-c i i") 'comis-sans) 

;; Genvejstaster til at skifte
(global-set-key (kbd "C-c c") 'enable-corfu)
(global-set-key (kbd "C-c p") 'enable-company)

(use-package general
  :config
  (general-create-definer my-leader-def
    :states '(normal visual emacs)
    :keymaps 'override
    :prefix "SPC")
    ;;:global-prefix "C-SPC")
  
  (my-leader-def

   ;; Shortcuts
   "," 'switch-to-buffer
   "rr" 'reload-init-file
   "RET" 'bookmark-jump
   
   ;; files
   "f" '(:ignore t :which-key "files")
   "ff" 'find-file
   "fs" 'save-buffer
   "fr" 'open-recent-files

   ;; buffers
   "b" '(:ignore t :which-key "buffers")
   "bb" 'switch-to-buffer
   "bk" 'kill-buffer
   "bl" 'list-buffers

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
   "a" '(:ignore t :which-key "frames")
   "an" 'make-frame
   "ac" 'clone-frame
   "aC" '((lambda () (interactive) (set-frame-font "Comic Sans MS")) :which-key "Comic Sans Frame") 
		 
   ;; consult
   "c" '(:ignore t :which-key "consult")
   "cy" 'consult-yank-pop
   "cb" 'consult-buffer
   
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

   ;; quit
   "q" '(:ignore t :which-key "quit")
   "qq" 'save-buffers-kill-terminal
   ))
;; (use-package key-chord
;;   :ensure t
;;   :config 
;;   (key-chord-mode 1)
;;   (key-chord-define evil-insert-state-map "hh" 'evil-normal-state))

(require 'org-modern)
  (add-hook 'org-mode-hook #'org-modern-mode)
  (add-hook 'org-mode-hook 'org-indent-mode)

  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (python . t)
     (shell . t) ;; Tilføj andre sprog du ønsker at aktivere
     ))

(setq org-confirm-babel-evaluate nil)
(setq org-babel-python-command "python3")
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
  (setq org-agenda-files (directory-files-recursively "~/Documents/org/agenda" "\\.org$")))
(message "%s" org-agenda-files)

  ;;  (setq org-agenda-files (directory-files-recursively "~/Documents/org/agenda" "\\.org$"))
    ;; (setq org-agenda-files (directory-files-recursively "~/Documents/org/agenda/" "\\.org$"))
         (use-package org-superstar
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
    :custom
    (org-roam-directory "~/Documents/org/org-roam/")  ; Din org-roam mappe
    (org-roam-completion-everywhere t)
    ;; :bind (("C-c n l" . org-roam-buffer-toggle)
    ;;        ("C-c n f" . org-roam-node-find)
    ;;        ("C-c n i" . org-roam-node-insert)
    ;;        ("C-c n c" . org-roam-capture)
    ;;        ("C-c n j" . org-roam-dailies-capture-today))
    :config
    (org-roam-db-autosync-mode))
(use-package ts
  :ensure t)

  (use-package org-roam-ui
    :ensure t
    :after org-roam
    :custom
    (org-roam-ui-sync-theme t)
    (org-roam-ui-follow t)
    (org-roam-ui-update-on-save t)
    (org-roam-ui-open-on-start t))

(use-package lsp-mode
  :ensure t
  :hook ((c-mode . lsp)
	 (csharp-mode . lsp))
  :commands lsp)

(use-package dap-mode
  :ensure t
  :after lsp-mode
  :config
  (dap-auto-configure-mode)
  (require 'dap-lldb)
  (dap-ui-mode 1)

  (setq dap-lldb-debug-program '("/Library/Developer/CommandLineTools/usr/bin/lldb-dap"))
  ;; Sti til lldb-dap
  ;; (setq dap-lldb-debug-program '("/opt/homebrew/opt/llvm/bin/lldb-dap"))

  ;; debug keybindings
  (define-key dap-mode-map (kbd "<f5>") 'dap-debug)
  (define-key dap-mode-map (kbd "<f9>") 'dap-breakpoint-toggle)
  (define-key dap-mode-map (kbd "<f10>") 'dap-next))
