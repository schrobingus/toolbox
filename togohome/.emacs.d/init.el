
;; Change some basic settings.
(blink-cursor-mode 0) ;; Disable the blinking cursor.
(setq auto-save-default nil) ;; Disable auto save, as it leaves junk files.
(column-number-mode 1) ;; Show the column number (along with line number).
(setq dired-kill-when-opening-new-dired-buffer t) ;; Prevent Dired buffers from opening on new directory.
(electric-pair-mode 1) ;; Match delimiters automatically.
(setq read-process-output-max (* 4 1024 1024)) ;; Bump the Process Output Buffer size to 4MB.
(setq redisplay-skip-fontification-on-input t) ;; Defer fontification until typing stops.
(setq history-delete-duplicates t) ;; Delete duplicates in command history
(setq-default mode-line-end-spaces nil) ;; Remove the "dashes" from the modeline in No Window mode.
(pixel-scroll-precision-mode 1) ;; Enable smooth scrolling.
(savehist-mode 1) ;; Save command history.
(setq vc-follow-symlinks t) ;; Automatically load files with symlinks.
(global-visual-line-mode 1) ;; Enable word wrapping.
(setq window-combination-resize t) ;; Make all window resizing proportional.
(xterm-mouse-mode 1) ;; Enable the mouse in the terminal.

;; Do not display native compilation warnings and errors.
(setq native-comp-async-report-warnings-errors nil)

;; Disable the welcome screen.
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)

;; Assume left-to-right for all text.
(setq-default bidi-display-reordering 'left-to-right
              bidi-paragraph-direction 'left-to-right)
(setq bidi-inhibit-bpa t)

;; Define an exit message to prevent accidental exits.
(add-hook 'kill-emacs-query-functions
          (lambda () (y-or-n-p "Do you really want to exit Emacs? "))
          'append)

;; Set Recentf mode to track the previously opened files.
(recentf-mode 1)
(setq recentf-max-menu-items 25)

;; Define functions that emphasizes lines and their numbers in buffer. 
(defun emphasize-lines ()
  (interactive)
  (display-line-numbers-mode 1)
  (hl-line-mode 1))
(defun deemphasize-lines ()
  (interactive)
  (display-line-numbers-mode 0)
  (hl-line-mode 0))
;; Subsequently, hook the "emphasize" function to programming major modes.
(add-hook 'prog-mode-hook #'emphasize-lines)

;; Scroll line-by-line, and leave a 6 line long amount of space from the edge.
(setq scroll-step 1
      ;; scroll-margin 6 ;; Interferes with smooth scrolling, but centered cursor mode makes this a lot more usable.
      scroll-conservatively 100000)

;; Throw all backup files in the trash, or disable entirely.
(setq backup-directory-alist '((".*" . "~/.Trash")))

;; Do not use word wrap (visual line mode) in Eshell and EAT.
(add-hook 'eat-mode-hook (lambda () (visual-line-mode 0)))
(add-hook 'eat-eshell-mode-hook (lambda () (visual-line-mode 0)))
(add-hook 'eshell-mode-hook (lambda () (visual-line-mode 0)))

;; Create aliases for eshell, taken from zsh config.
;; TODO: fix up nixos binds
(defun eshell-command-exists-p (command)
  (not (null (eshell-search-path command))))
(defun eshell-bingus-aliases ()
  ;; nix
  (when (eshell-command-exists-p "nix")
    (eshell/alias "nd" "nix develop $@*")
    (eshell/alias "nsh" "nix-shell $@*")
    (eshell/alias "ncs" "nix-store --gc $@* && sudo nix-store --gc $@*")
    (eshell/alias "ncg" "nix-collect-garbage -d $@* && sudo nix-collect-garbage -d $@*"))
  ;; nix-channel
  (when (eshell-command-exists-p "nix-channel")
    (eshell/alias "ncu" "nix-channel --update $@* && sudo nix-channel --update $@*")
    (eshell/alias "ncui" "nix-channel --update -vvvvv $@* && sudo nix-channel --update -vvvvv $@*"))
  ;; nixos-rebuild
  (when (eshell-command-exists-p "nixos-rebuild")
    (eshell/alias "nrs" "sudo nixos-rebuild switch $@*")
    (eshell/alias "nrf" "sudo nixos-rebuild switch --flake $DOTDIR $@*"))
  ;; darwin-rebuild
  (if (eshell-command-exists-p "darwin-rebuild")
      (progn
	(eshell/alias "drs" "sudo darwin-rebuild switch $@*")
	(eshell/alias "drf" "sudo darwin-rebuild switch --flake $DOTDIR $@*"))
    (when (and (eq system-type 'darwin) (eshell-command-exists-p "nix"))
      (eshell/alias "drs" "sudo nix run nix-darwin/master#darwin-rebuild -- switch $@*")
      (eshell/alias "drs" "sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake $DOTDIR $@*")))
  ;; home-manager
  (when (eshell-command-exists-p "home-manager")
    (eshell/alias "nhs" "home-manager switch $@*")
    (eshell/alias "nhs" "home-manager switch --flake $DOTDIR $@*"))
  ;; rosetta shell
  (when (file-exists-p "/usr/bin/arch")
    (eshell/alias "x86_sh" "/usr/bin/arch -x86_64 /bin/sh $@*"))
  ;; sudo doas alias
  (when (and (eshell-command-exists-p "doas") (not (eshell-command-exists-p "sudo")))
    (eshell/alias "sudo" "doas $@*"))
  ;; generic aliases
  (eshell/alias "x" "startx $@*")
  (eshell/alias "allah" "sudo $@*"))
(add-hook 'eshell-mode-hook #'eshell-bingus-aliases)

;; Bootstrap Elpaca.
(defvar elpaca-installer-version 0.12)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-sources-directory (expand-file-name "sources/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                              :ref nil :depth 1 :inherit ignore
                              :files (:defaults "elpaca-test.el" (:exclude "extensions"))
                              :build (:not elpaca-activate)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-sources-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (<= emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
        (if-let* ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
                  ((zerop (apply #'call-process `("git" nil ,buffer t "clone"
                                                  ,@(when-let* ((depth (plist-get order :depth)))
                                                      (list (format "--depth=%d" depth) "--no-single-branch"))
                                                  ,(plist-get order :repo) ,repo))))
                  ((zerop (call-process "git" nil buffer t "checkout"
                                        (or (plist-get order :ref) "--"))))
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
    (let ((load-source-file-function nil)) (load "./elpaca-autoloads"))))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))

;; Hook Elpaca into use-package.
(elpaca elpaca-use-package
	(elpaca-use-package-mode))
(setq use-package-always-ensure t)

;; Enable Evil mode.
;; TODO: replace with meow mode
(use-package evil
  :init
  (setq evil-search-module 'evil-search
	evil-ex-search-case 'smart
	evil-ex-complete-emacs-commands t
	evil-vsplit-window-right t
	evil-split-window-below t
	evil-want-C-u-scroll nil
	evil-want-C-d-scroll nil
	evil-want-keybinding nil)
  :config
  ;; Bind `;` to `:` in NORMAL mode.
  (define-key evil-normal-state-map (kbd ";") 'evil-ex)
  ;; Enable window movement in NORMAL using C-{HJKL}.
  (define-key evil-normal-state-map (kbd "C-h") #'windmove-left)
  (define-key evil-normal-state-map (kbd "C-j") #'windmove-down)
  (define-key evil-normal-state-map (kbd "C-k") #'windmove-up)
  (define-key evil-normal-state-map (kbd "C-l") #'windmove-right)
  ;; Navigate in INSERT using C-{HJKL}.
  (define-key evil-insert-state-map (kbd "C-h") #'backward-char)
  (define-key evil-insert-state-map (kbd "C-j") #'next-line)
  (define-key evil-insert-state-map (kbd "C-k") #'previous-line)
  (define-key evil-insert-state-map (kbd "C-l") #'forward-char)
  ;; Define some leader-bound keys to some general Emacs functions.
  (evil-define-key 'normal 'global
    (kbd "<leader>fe") #'eval-buffer
    (kbd "<leader>fs") #'save-buffer
    (kbd "<leader>ff") #'find-file
    (kbd "<leader>fF") #'recentf
    (kbd "<leader>fl") #'load-file
    (kbd "<leader>fr") #'revert-buffer
    (kbd "<leader>z")  #'text-scale-adjust)
  ;; Define some leader-bound keys to some general Emacs functions.
  (evil-define-key 'normal 'global
    (kbd "<leader>fe") #'eval-buffer
    (kbd "<leader>fs") #'save-buffer
    (kbd "<leader>ff") #'find-file
    (kbd "<leader>fF") #'recentf
    (kbd "<leader>fl") #'load-file
    (kbd "<leader>fr") #'revert-buffer
    (kbd "<leader>z")  #'text-scale-adjust)
  ;; Assign Evil's delete function to the black hole register.
  ;; In other words, disabling yank on delete.
  (defun bb/evil-delete (orig-fn beg end &optional type _ &rest args)
    (apply orig-fn beg end type ?_ args))
  (advice-add 'evil-delete :around 'bb/evil-delete)
  ;; Enable Evil Mode.
  (evil-mode 1))

;; Enable XClip mode for "No Window" clipboard usage.
(use-package xclip
  :config
  (unless (display-graphic-p)
    (xclip-mode 1)))

;; Use the Undo-Tree to implement proper undo and redo for Evil mode.
(use-package undo-tree
  :init
  (global-undo-tree-mode 1)
  (setq undo-tree-auto-save-history nil)
  (evil-set-undo-system 'undo-tree))

;; Get the Evil Collection of bindings.
(use-package evil-collection
  :after evil
  :config (evil-collection-init))

;; Bind SPACE to the Evil Leader key.
(use-package evil-leader
  :after evil
  :config (evil-set-leader 'motion (kbd "SPC")))

;; Install Evil Escape to escape from INSERT to NORMAL when pressing `jk`.
(use-package evil-escape
  :after evil
  :custom
  (evil-escape-key-sequence "jk")
  (evil-escape-delay 0.5)
  (evil-escape-excluded-states ;; Prevents VISUAL / Collection binding collisions.
   '(normal visual multiedit emacs motion))
  :config
  (evil-escape-mode 1))

;; Enable Avy. Bindings should be akin to leap.nvim.
;; TODO: extend so it's more than a leap plugin here. consider casual avy
(use-package avy
  :after evil
  :init (setq avy-all-windows t)
  :config
  (evil-define-key '(normal visual operator) 'global
    (kbd "s") #'avy-goto-char-2-below)
  (evil-define-key 'normal 'global
    (kbd "S") #'avy-goto-char-2-above))

;; Enable Evil Surround.
;; NOTE: gone unused. being replaced by embrace.el soon
;; (use-package evil-surround
;;   :after evil
;;   :config (global-evil-surround-mode 1))

;; Enable Aggressive Indent Mode, and turn off Electric Indent Mode.
(use-package aggressive-indent
  :config
  (add-to-list 'aggressive-indent-protected-commands 'evil-undo)
  (electric-indent-mode 0)
  (global-aggressive-indent-mode 1))

;; Enable Evil Commentary mode.
(use-package evil-commentary
  :config (evil-commentary-mode 1))

;; TODO: corfu and vertico config syntax is inconsistent. make it more consistent when you're fine with going insane for a bit

;; Enable Corfu for in-buffer completion.
(use-package corfu
  :custom
  (corfu-auto nil) ;; or t
  (corfu-cycle t)
  (corfu-preselect 'prompt)
  (corfu-quit-no-match 'separator)
  (corfu-preview-current nil)
  (tab-always-indent 'complete)
  :init
  (global-corfu-mode 1)
  :bind
  (:map prog-mode-map
	("C-SPC" . completion-at-point))
  :config
  (with-eval-after-load 'corfu
    (define-key corfu-map (kbd "C-j") #'corfu-next)
    (define-key corfu-map (kbd "TAB") #'corfu-next)
    (define-key corfu-map (kbd "<tab>") #'corfu-next)
    (define-key corfu-map (kbd "C-k") #'corfu-previous)
    (define-key corfu-map (kbd "S-TAB") #'corfu-previous)
    (define-key corfu-map (kbd "<backtab>") #'corfu-previous)
    (define-key corfu-map (kbd "RET") #'corfu-complete)
    (define-key corfu-map (kbd "<return>") #'corfu-complete)))

;; Enable Vertico for mini-buffer completion.
(use-package vertico
  :custom
  (vertico-cycle t)
  ;; (completion-in-region-function #'consult-completion-in-region)
  :config (vertico-mode 1))
(use-package vertico-directory
  :ensure nil
  :after vertico
  :bind (:map vertico-map
	      ("C-j"   . vertico-next)
	      ("C-k"   . vertico-previous)
	      ("RET"   . vertico-directory-enter)
	      ("DEL"   . vertico-directory-delete-word)
	      ("M-DEL" . vertico-directory-delete-char)))

;; Enable Orderless for more flexible completion.
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-pcm-leading-wildcard t))

;; Enable Dirvish for a facelifted Dired.
(use-package dirvish
  :defer t
  :init
  (dirvish-override-dired-mode)
  ;; (dirvish-peek-mode) ;; Preview in Minibuffer
  (dirvish-side-follow-mode) ;; Useful to Tree Layout
  :config
  (evil-collection-define-key 'normal 'dirvish-mode-map
    "q" 'dirvish-quit)
  :custom
  (dirvish-large-directory-threshold 20000)
  (dirvish-use-header-line nil)
  (dirvish-use-mode-line nil)
  (dirvish-default-layout '(0 0.0 0.5))
  (dirvish-layout-recipes '((2 0.25 0.0)
			    (1 0.2 0.35)
			    (0 0.0 0.5)))
  :bind (("C-c f" . dirvish)
	 :map dirvish-mode-map
	 (";"     . dired-up-directory)
	 ("?"     . dirvish-dispatch)
	 ("a"     . dirvish-setup-menu)
	 ("f"     . dirvish-file-info-menu)
	 ("o"     . dirvish-quick-access)
	 ("s"     . dirvish-quicksort)
	 ("r"     . dirvish-history-jump)
	 ("l"     . dirvish-ls-switches-menu)
	 ("v"     . dirvish-vc-menu)
	 ("*"     . dirvish-mark-menu)
	 ("y"     . dirvish-yank-menu)
	 ("N"     . dirvish-narrow)
	 ("^"     . dirvish-history-last)
	 ("TAB"   . dirvish-subtree-toggle)
	 ("<tab>" . dirvish-subtree-toggle)
	 ("M-f"   . dirvish-history-go-forward)
	 ("M-b"   . dirvish-history-go-backward)
	 ("M-e"   . dirvish-emerge-menu)))

;; Enable Agent Shell for LLM integration using Goose.
(use-package agent-shell
  :custom (agent-shell-goose-authentication
	   (agent-shell-make-goose-authentication :openai-api-key ""))) ;; All models are local.

;; Define a typical list of Org Mode keywords.
(setq org-todo-keywords '((sequence
			   "TODO" "NEXT" "MEETING" "|" "DONE" "WAITING" "CANCELLED" "INACTIVE")))

;; Set the Org Agenda directory to my notes directory.
(setq org-agenda-files '("~/Notes"))

;; Enable Adaptive Wrap to make break-indents consistent.
(use-package adaptive-wrap
  :init
  (setq-default adaptive-wrap-extra-indent 0)
  (defun enable-adaptive-wrap-on-hook ()
    ;; VTerm, Eshell and EAT should have it left off.
    (unless (derived-mode-p 'vterm-mode 'eshell-mode 'eat-eshell-mode 'eat-mode)
      (adaptive-wrap-prefix-mode 1)))
  (add-hook 'visual-line-mode-hook #'enable-adaptive-wrap-on-hook))

;; Use the Frame module to tweak many stylistic features of Emacs.
(use-package frame
  ;; :ensure (:type built-in)
  :ensure nil
  :config
  (setq-default default-frame-alist
		(append (list
			 '(ns-transparent-titlebar . t)
			 (cons 'menu-bar-lines
			       (if (and (eq system-type 'darwin) (display-graphic-p))
				   1 0))
			 (cons 'font (if (eq system-type 'darwin) "SF Mono:size=13" "GeistMono Nerd Font:size=13"))
			 '(internal-border-width . 16)
			 '(left-fringe           . 0)
			 '(right-fringe          . 0)
			 '(tool-bar-lines        . 0)
			 '(line-spacing          . 1)
			 '(vertical-scroll-bars  . nil))
			default-frame-alist))
  (setq-default window-resize-pixelwise t)
  (setq-default frame-resize-pixelwise t))

;; Enable Olivetti for comfortable margins in buffers.
(use-package olivetti
  :init (setq-default olivetti-body-width 96)
  :config
  (evil-define-key 'normal 'global ;; Add some Evil bindings.
    (kbd "<leader>Zm") #'olivetti-mode
    (kbd "<leader>Zw") #'olivetti-set-width
    (kbd "<leader>Z-") #'olivetti-shrink
    (kbd "<leader>Z+") #'olivetti-expand))

;; Enable Rainbow Mode to highlight colors in-buffer.
(use-package rainbow-mode)

;; Allow centering the cursor in the view.
(use-package centered-cursor-mode
  :config
  ;; TODO: add horizontal scrolling here, it seems to always fuck it up
  (setq ccm-ignored-commands '(mouse-drag-region
                               mouse-set-point
                               mouse-set-region
                               widget-button-click
                               scroll-bar-toolkit-scroll
                               evil-mouse-drag-region
			       pixel-scroll-precision
			       pixel-scroll-start-momentum))
  (evil-define-key 'normal 'global (kbd "<leader>c") #'centered-cursor-mode))

;; If the buffer name is over 24 characters, truncate in modeline.
(setq-default mode-line-buffer-identification
	      `(-24 . ,(propertized-buffer-identification "%b")))

;; Install Minions for better minor mode display in the modeline.
(use-package minions
  :custom
  (minions-mode-line-lighter "...")
  (minions-mode-line-delimiters '("" . ""))
  :config (minions-mode 1))

;; Enable the Highlight To-Do package.
(use-package hl-todo
  :hook (prog-mode . hl-todo-mode))

;; Install YASnippet for snippets.
;; The snippets themselves are in .emacs.d/snippets, which is also in dotfiles.
;; FIXME: this is wrong, move snippets to dotfiles dir
(use-package yasnippet
  :config (yas-global-mode 1))

;; Add the Doom Themes for the future, albeit they are not for regular use yet.
;; TODO: submit pr to hlissner for doom flexoki theme
;; TODO: make the window divider face consistent in dark mode
(add-to-list 'load-path "~/Sources/doom-themes")
(use-package doom-themes
  ;; :straight (:local-repo "~/Sources/doom-themes" :type nil)
  :ensure nil
  :custom
  (doom-flexoki-padded-modeline t)
  (doom-flexoki-light-padded-modeline t)
  (doom-flexoki-opaque-vertical-bar nil)
  (doom-flexoki-light-opaque-vertical-bar nil))
(use-package solaire-mode) ;; for testing
(use-package doom-modeline) ;; also for testing

;; Add the Flexoki Themes, and make functions with my own appearance modifications.
;; Do note that this is mostly no longer used as anything other than a backup, since I have added Flexoki to Doom.
(use-package flexoki-themes
  :custom
  (flexoki-themes-use-bold-keywords t)
  (flexoki-themes-use-bold-builtins t)
  (flexoki-themes-use-italic-comments t))

;; Enable Auto Dark Mode, which will dynamically change light/dark themes.
(use-package auto-dark
  :after flexoki-themes
  :custom (auto-dark-allow-osascript t)
  :hook  
  (auto-dark-dark-mode  . (lambda () (load-theme 'doom-flexoki t)))
  (auto-dark-light-mode . (lambda () (load-theme 'doom-flexoki-light t)))
  :config ;; TODO: make a pr to auto-dark-emacs that is oriental to nw mode. do it like auto-dark-mode.nvim, since that works well
  (if (display-graphic-p)
      (auto-dark-mode 1)
    (load-theme 'doom-flexoki t)))

;; Change the "DONE" faces for Org, as their contrast is too low by default.
(with-eval-after-load 'org-faces
  (set-face-foreground 'org-headline-done (face-foreground 'font-lock-comment-face))
  (set-face-foreground 'org-done          (face-foreground 'font-lock-comment-face)))

;; Use the more seamless window dividers instead of window borders.
(setq window-divider-default-right-width 12)
(setq window-divider-default-places 'right-only)
(window-divider-mode 1)

;; Enable the EAT terminal, and hook it to eshell.
(use-package eat
  :ensure
  (:host codeberg
	 :repo "akib/emacs-eat"
	 :files ("*.el" ("term" "term/*.el") "*.texi"
		 "*.ti" ("terminfo/e" "terminfo/e/*")
		 ("terminfo/65" "terminfo/65/*")
		 ("integration" "integration/*")
		 (:exclude ".dir-locals.el" "*-tests.el")))
  :defer t
  :custom (eat-term-name "xterm-256color")
  :init (add-hook 'eshell-mode-hook #'eat-eshell-mode))

;; Enable the VTerm terminal.
(use-package vterm
  :defer t
  :custom (vterm-term-environment-variable "xterm-256color"))

;; Enable Magit.
(use-package transient
  :ensure (:repo "magit/transient" :host github))
(use-package magit
  :after transient)

;; Install PDF Tools, and enable Image Roll for it
(use-package pdf-tools
  :defer t
  :mode ("\\.pdf\\'" . pdf-view-mode)
  :hook (pdf-view-mode . (lambda ()
			   (display-line-numbers-mode 0)
			   (hl-line-mode 0)))
  :config
  (pdf-tools-install)
  (evil-set-initial-state 'pdf-view-mode 'normal)
  (evil-define-key 'normal pdf-view-mode-map
    (kbd "j") #'pdf-view-next-line-or-next-page
    (kbd "k") #'pdf-view-previous-line-or-previous-page
    (kbd "C-j") #'pdf-view-next-page-command
    (kbd "C-k") #'pdf-view-previous-page-command
    (kbd "gg") #'pdf-view-first-page
    (kbd "G")  #'pdf-view-last-page)
  (setq TeX-view-program-selection '((output-pdf "PDF Tools"))
	TeX-view-program-list '(("PDF Tools" TeX-pdf-tools-sync-view))
	TeX-source-correlate-start-server t)
  (add-hook 'TeX-after-compilation-finished-functions #'TeX-revert-document-buffer))
(add-hook 'LaTeX-mode-hook 'pdf-tools-install t) ;; PDF tools should be called immediately upon using AUCTeX.

;; Disable Electric Pairing on AUCTeX buffers.
(add-hook 'LaTeX-mode-hook (lambda () (electric-pair-local-mode -1)))

;; Enable Markdown mode.
(use-package markdown-mode
  :defer t
  :mode ("\\.md\\'" . markdown-mode))

;; Reduce AUCTeX "fontify" presence.
(setq font-latex-fontify-script nil)
(setq font-latex-fontify-sectioning 'color)

;; Integrate latexmk with AUCTeX.
(use-package auctex-latexmk
  :custom (auctex-latexmk-inherit-TeX-PDF-mode t)
  :config (auctex-latexmk-setup))

;; Enable Web Mode for HTML, XML, CSS, JS, JSON and others.
(use-package web-mode
  :defer t
  :mode
  ("\\.html?\\'" . web-mode)
  ("\\.css\\'"   . web-mode)
  ("\\.scss\\'"  . web-mode)
  ("\\.sass\\'"  . web-mode)
  ("\\.xml\\'"   . web-mode)
  ("\\.jsx?\\'"  . web-mode)
  ("\\.tsx?\\'"  . web-mode)
  ("\\.json\\'"  . web-mode)
  ("\\.php\\'"   . web-mode)
  :custom
  (web-mode-markup-indent-offset 2)
  (web-mode-css-indent-offset 2)
  (web-mode-code-indent-offset 2))

;; Install Pet for hooking into Python Virtualenv and UV environments.
(use-package pet
  :defer t
  :custom (pet-find-file-functions
	   '(pet-find-file-from-project-root
             pet-locate-dominating-file))
  :init
  (add-hook 'python-base-mode-hook 'pet-mode -10)
  (add-hook 'python-mode-hook
	    (lambda ()
	      (setq-local python-shell-interpreter (pet-executable-find "python")
			  python-shell-virtualenv-root (pet-virtualenv-root))
	      (setenv "VIRTUAL_ENV" (pet-virtualenv-root)) ;; TODO: make this buffer local, or make a reload function
	      (pet-eglot-setup))))
;; (pet-flycheck-setup))))

;; Hook up Eglot to LSP servers.
(add-to-list 'exec-path "/Users/brent/.local/bin") ;; For ty. TODO: remove when PATH is fixed
(use-package eglot
  :ensure nil
  :init
  (add-hook 'python-mode-hook 'eglot-ensure)
  (add-hook 'java-mode-hook 'eglot-ensure)
  :config
  (setq completion-category-overrides
        '((eglot (styles orderless))))
  (set-face-attribute 'eglot-inlay-hint-face nil :height 'unspecified)
  ;; TODO: figure if adding all of the servers manually is really necessary
  (add-to-list 'eglot-server-programs
	       ;; '(python-base-mode . ("pyright-langserver" "--stdio"))))
	       '(python-base-mode . ("ty" "server")))
  (add-to-list 'eglot-server-programs
	       '(java-mode . ("jdtls"))))

;; TODO: inspect treesitter to replace most (but not all) major modes

;; Enable the Nix major mode.
(use-package nix-mode
  :defer t
  :mode ("\\.nix\\'" . nix-mode))

;; Enable the Clojure major mode.
;; This also supports ClojureScript and ClojureDart.
(use-package clojure-mode
  :defer t
  :mode ("\\.clj\\'" .  clojure-mode)
  ;; :mode ("\\.cljd\\'" . clojuredart-mode) ;; Disabled until Dart stack is added.
  :mode ("\\.cljs\\'" .  clojurescript-mode))

;; Enable the Haskell major mode.
(use-package haskell-mode
  :defer t
  :mode ("\\.hs\\'" . haskell-mode))

;; Enable the Kotlin major mode.
(use-package kotlin-mode
  :defer t
  :mode ("\\.kt\\'" . kotlin-mode))

;; Enable the Lua major mode.
(use-package lua-mode
  :defer t
  :mode ("\\.lua\\'" . lua-mode))

;; Enable the OpenSCAD major mode.
(use-package scad-mode
  :defer t
  :mode ("\\.scad\\'" . scad-mode))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("9172a4c4731211a659b7d707f59eb699eea9ec68be7b7aac0a5e2cb822cc2920"
     "012cfd34db95b0fb42e78ca6bba781babc545fcaa2e87baff1bb9c540956b09a"
     "750fe2cceee653bd5fb3c8fb3d673066d98d43894122babb8886c8de2cda138a"
     "0325a6b5eea7e5febae709dab35ec8648908af12cf2d2b569bedc8da0a3a81c1"
     "4d5d11bfef87416d85673947e3ca3d3d5d985ad57b02a7bb2e32beaf785a100e"
     "c2ee3fa1cc967fa73fd707858e0a719f4842abbed48b67fc05621d65d1d339f2"
     "d8aff6895ebf529177e92f92a6ea26f8a78dad5bbbd2912e76933eefa7f5f321"
     "add98b283c0c61e5668f6b9de81a6bc7a24f9c7c9378c94276b1964eb33c45e9"
     "2ecaf11d48e2c052a72505515cf1e6b37a8cdf245d3729b3f95958f618966849"
     "64d97d2dfb37a7b5772b057a219ad0a0bed4706bb7c2cb96973a5610605f8c16"
     "95d20f29bdbaadc082f8f0cafbc8e5a000d262b5c946ed645bb2783dc8ef856e"
     default)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
