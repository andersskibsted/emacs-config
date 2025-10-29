(org-babel-load-file (expand-file-name "~/.emacs.d/config.org"))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files
   '("/Users/andersskibsted/Documents/org/agenda/dayplanner.org"
     "/Users/andersskibsted/Documents/org/agenda/inbox.org"))
 '(package-selected-packages
   '(company-org-block consult-yasnippet corfu dap-mode dired-preview
		       doom-modeline embark-consult evil-args
		       evil-cleverparens evil-collection evil-escape
		       evil-goggles evil-indent-plus evil-lion
		       evil-matchit evil-mc evil-nerd-commenter
		       evil-numbers evil-org evil-surround
		       evil-visualstar fira-code-mode general
		       key-chord ligature lispyville lsp-ui magit
		       marginalia meow multi-vterm olivetti orderless
		       org-modern org-roam-ui org-super-agenda
		       org-superstar projectile rainbow-delimiters
		       treesit-auto typst-ts-mode vertico vterm-hotkey
		       which-key-posframe yasnippet-classic-snippets
		       yasnippet-snippets))
 '(safe-local-variable-values
   '((eval with-eval-after-load 'dap-mode
	   (dap-register-debug-template "LLDB::Run Peer"
					(list :type "lldb-vscode" :cwd
					      "${workspaceFolder}"
					      :request "launch"
					      :program
					      "${workspaceFolder}/peer.c"
					      :name
					      "LLDB::Run Fauxgrep MT")))
     (eval with-eval-after-load 'dap-mode
	   (dap-register-debug-template "LLDB::Run Fauxgrep MT"
					(list :type "lldb-vscode" :cwd
					      "${workspaceFolder}"
					      :request "launch"
					      :program
					      "${workspaceFolder}/fauxgrep-mt"
					      :name
					      "LLDB::Run Fauxgrep MT"
					      :args
					      '("-n" "5" "for" "test"))))
     (eval with-eval-after-load 'dap-mode
	   (dap-register-debug-template "LLDB::Run Fauxgrep MT"
					(list :type "lldb-vscode" :cwd
					      "${workspaceFolder}"
					      :request "launch"
					      :program
					      "${workspaceFolder}/fauxgrep-mt"
					      :name
					      "LLDB::Run Fauxgrep MT"
					      :args
					      '("-n " "5" "for" "test"))))
     (eval with-eval-after-load 'dap-mode
	   (dap-register-debug-template "LLDB::Run Fauxgrep MT"
					(list :type "lldb-vscode" :cwd
					      "${workspaceFolder}"
					      :request "launch"
					      :program
					      "${workspaceFolder}/fauxgrep-mt"
					      :name
					      "LLDB::Run Fauxgrep MT"
					      :args
					      '("-n " "1" "for" "test"))))
     (eval with-eval-after-load 'dap-mode
	   (dap-register-debug-template "LLDB::Run Fauxgrep MT"
					(list :type "lldb-vscode" :cwd
					      "${workspaceFolder}"
					      :request "launch"
					      :program
					      "${workspaceFolder}/fauxgrep-mt"
					      :name
					      "LLDB::Run Fauxgrep MT"
					      :args
					      (split-string
					       (read-string
						"Arguments: ")))))
     (eval with-eval-after-load 'dap-mode
	   (dap-register-debug-template "LLDB::Run Fauxgrep MT"
					(list :type "lldb-vscode" :cwd
					      "/users/andersskibsted/Desktop/datalogi/CompSys/Afleveringer/A2/"
					      :request "launch"
					      :program
					      "/users/andersskibsted/Desktop/datalogi/CompSys/Afleveringer/A2/src/fauxgrep-mt"
					      :name
					      "LLDB::Run Fauxgrep MT"
					      :args
					      '("-n" "5" "for" "test"))))
     (eval with-eval-after-load 'dap-mode
	   (dap-register-debug-template "LLDB::Run Fauxgrep MT"
					(list :type "lldb-vscode" :cwd
					      "/users/andersskibsted/Desktop/datalogi/CompSys/Afleveringer/A2/"
					      :request "launch"
					      :program
					      "/users/andersskibsted/Desktop/datalogi/CompSys/Afleveringer/A2/src/fauxgrep-mt"
					      :name
					      "LLDB::Run Fauxgrep MT"
					      :argument
					      ["-n" "5" "for" "test"])))
     (git-commit-major-mode . git-commit-elisp-text-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
