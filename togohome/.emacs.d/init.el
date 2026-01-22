
;; Change some basic settings.
(blink-cursor-mode 0) ;; Disable the blinking cursor.
(setq auto-save-default nil) ;; Disable auto save, as it leaves junk files.
(column-number-mode 1) ;; Show the column number (along with line number).
(setq dired-kill-when-opening-new-dired-buffer t) ;; Prevent Dired buffers from opening on new directory.
(electric-pair-mode 1) ;; Match delimiters automatically.
;; (global-display-line-numbers-mode 1) ;; Display line numbers on the left-hand side.
;; (global-hl-line-mode 1) ;; Highlight line with cursor.
(global-visual-line-mode 1) ;; Enable word wrapping.
(setq history-delete-duplicates t) ;; Delete duplicates in command history
(pixel-scroll-precision-mode 1) ;; Enable smooth scrolling.
(savehist-mode 1) ;; Save command history.
(xterm-mouse-mode 1) ;; Enable the mouse in the terminal.

;; Define an exit message to prevent accidental exits.
(add-hook 'kill-emacs-query-functions
          (lambda () (y-or-n-p "Do you really want to exit Emacs? "))
          'append)

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
      ;; scroll-margin 6 ;; FIXME: This interferes with smooth scrolling, figure out a fix as it gets annoying scrolling for sight every time, especially with Avy.
      scroll-conservatively 100000)

;; Add a scroll margin only when certain commands are run (generally those with the keyboard).
;; TODO: NOT READY FOR NORMAL USE, FOR DEBUGGING ONLY
;; (defun my/debug-next-prev-line (&rest _)
;;   (message "Ran %s" this-command))
;; (advice-add 'next-line     :after #'my/debug-next-prev-line)
;; (advice-add 'previous-line :after #'my/debug-next-prev-line)
;; (with-eval-after-load 'evil
;;   (advice-add 'evil-next-line     :after #'my/debug-next-prev-line)
;;   (advice-add 'evil-previous-line :after #'my/debug-next-prev-line))

;; Throw all backup files in the trash, or disable entirely.
(setq backup-directory-alist '((".*" . "~/.Trash")))
;; (setq make-backup-files nil)

;; Create aliases for eshell, taken from zsh config.
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
  (eshell/alias "ls" "ls -lH --color=auto $@*")
  (eshell/alias "x" "startx $@*")
  (eshell/alias "allah" "sudo $@*"))
(add-hook 'eshell-mode-hook #'eshell-bingus-aliases)

;; Bootstrap straight.el, then subsequently bootstrap use-package.
;; TODO: throw this into it's own script that can be enabled or disabled
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))
(setq straight-use-package-by-default t)

;; Use Diminish, which has use-package integration.
(use-package diminish)
(diminish 'visual-line-mode) ;; Diminish word wrapping from the mode-line.

;; Enable Evil mode.
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
  :config (evil-mode 1))

;; Use the Undo-Tree to implement proper undo and redo for Evil mode.
(use-package undo-tree
  :diminish
  :init
  (global-undo-tree-mode 1)
  (setq undo-tree-auto-save-history nil)
  (evil-set-undo-system 'undo-tree))

;; Get the Evil Collection of bindings.
(use-package evil-collection
  :after evil
  :config (evil-collection-init))

;; Bind SPACE to the Evil Leader key.
(evil-set-leader 'motion (kbd "SPC"))

;; Bind `;` to `:` in NORMAL mode.
(define-key evil-normal-state-map (kbd ";") 'evil-ex)

;; Enable window movement in NORMAL using C-{HJKL}.
(define-key evil-normal-state-map (kbd "C-h") #'windmove-left)
(define-key evil-normal-state-map (kbd "C-j") #'windmove-down)
(define-key evil-normal-state-map (kbd "C-k") #'windmove-up)
(define-key evil-normal-state-map (kbd "C-l") #'windmove-right)

;; For the window movement keys above, unbind some Org keys.
;; FIXME: this has never worked lmao
;; (with-eval-after-load 'org
;;   (define-key org-mode-map (kbd "C-j") nil)
;;   (define-key org-mode-map (kbd "C-k") nil)
;;   (evil-make-overriding-map evil-normal-state-map 'normal)
;;   (evil-normalize-keymaps))
(with-eval-after-load 'org
  (define-key org-mode-map (kbd "C-j") nil)
  (define-key org-mode-map (kbd "C-k") nil)
  (evil-define-key 'normal org-mode-map
    "C-h" #'windmove-left
    "C-j" #'windmove-down
    "C-k" #'windmove-up
    "C-l" #'windmove-right))

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
  (kbd "<leader>fl") #'load-file
  (kbd "<leader>fr") #'revert-buffer
  (kbd "<leader>z")  #'text-scale-adjust)

;; Assign Evil's delete function to the black hole register.
;; In other words, disabling yank on delete.
(defun bb/evil-delete (orig-fn beg end &optional type _ &rest args)
  (apply orig-fn beg end type ?_ args))
(advice-add 'evil-delete :around 'bb/evil-delete)

;; Escape from INSERT to NORMAL when pressing `jk`.
(defun jk-escape ()
  (interactive)
  (let ((modified (buffer-modified-p)))
    (insert "j")
    (let ((evt (read-event (format ""))))
      (if (and evt (equal evt ?k))
	  (progn
	    (delete-char -1)
	    (set-buffer-modified-p modified)
	    (evil-normal-state))
	(insert evt)))))
(define-key evil-insert-state-map (kbd "j")  #'jk-escape)
(define-key evil-replace-state-map (kbd "j") #'jk-escape)

;; Enable Avy. Bindings should be akin to leap.nvim.
(use-package avy
  :init (setq avy-all-windows t)
  :config
  (evil-define-key '(normal visual operator) 'global
    (kbd "s") #'avy-goto-char-2)
  (evil-define-key 'normal 'global
    (kbd "S") #'avy-goto-char-2))

;; Enable Evil Surround.
(use-package evil-surround
  :config
  (global-evil-surround-mode 1))

;; Enable Aggressive Indent Mode, and turn off Electric Indent Mode.
(use-package aggressive-indent
  :config
  (add-to-list 'minor-mode-alist '(aggressive-indent-mode " AggInd"))
  (add-to-list 'minor-mode-alist '(electric-indent-mode " ElcInd"))
  (electric-indent-mode 0)
  (global-aggressive-indent-mode 1))

;; Enable Evil Commentary mode.
(use-package evil-commentary
  :config
  (evil-commentary-mode 1))

;; Enable Corfu for in-buffer completion.
(use-package corfu
  :custom
  (corfu-auto nil)
  (corfu-cycle t)
  (corfu-preselect 'prompt)
  (corfu-quit-no-match 'separator)
  (corfu-preview-current 'nil)
  (tab-always-indent 'complete)
  ;; (global-corfu-minibuffer 't)
  :init
  (with-eval-after-load 'corfu ;; evil-friendly bindings
    (define-key corfu-map (kbd "TAB") #'corfu-next)
    (define-key corfu-map (kbd "<tab>") #'corfu-next)
    (define-key corfu-map (kbd "S-TAB") #'corfu-previous)
    (define-key corfu-map (kbd "<backtab>") #'corfu-previous)
    (define-key corfu-map (kbd "RET") #'corfu-complete)
    (define-key corfu-map (kbd "<return>") #'corfu-complete))
  :config (global-corfu-mode 1))

;; Enable Vertico for mini-buffer completion.
(use-package vertico
  :custom
  (vertico-cycle t)
  (completion-in-region-function #'consult-completion-in-region)
  :config (vertico-mode 1))

;; Enable Orderless for more flexible completion.
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-pcm-leading-wildcard t))

;; Define a typical list of Org Mode keywords.
(setq org-todo-keywords '((sequence
			   "TODO" "NEXT" "MEETING" "|" "DONE" "WAITING" "CANCELLED" "INACTIVE")))

;; Set the Org Agenda directory to my notes directory.
(setq org-agenda-files '("~/Notes"))

;; Enable Adaptive Wrap to make break-indents consistent.
(use-package adaptive-wrap
  :init
  (setq-default adaptive-wrap-extra-indent 0)
  (add-hook 'visual-line-mode-hook #'adaptive-wrap-prefix-mode))

;; Use the Frame module to tweak many stylistic features of Emacs.
(use-package frame
  :straight (:type built-in)
  :config
  (setq-default default-frame-alist
		(append (list
			 '(ns-transparent-titlebar . t)
			 ;; '(ns-appearance . dark) ;; Not needed, because of Auto Dark.
			 (cons 'menu-bar-lines (if (eq system-type 'darwin) 1 0))
			 ;; '(font . "SF Mono:style=medium:size=13")
			 '(font . "SF Mono:size=13")
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
  :init
  (setq-default olivetti-body-width 96)
  :config
  (evil-define-key 'normal 'global ;; Add some Evil bindings.
    (kbd "<leader>Zm") #'olivetti-mode
    (kbd "<leader>Zw") #'olivetti-set-width
    (kbd "<leader>Z-") #'olivetti-shrink
    (kbd "<leader>Z+") #'olivetti-expand))

;; Force all Boxdraw to SF Mono.
(setq inhibit-compacting-font-caches t)
(set-fontset-font t 'unicode "SF Mono" nil 'prepend)
(setq bidi-display-reordering nil)
(setq bidi-paragraph-direction 'left-to-right)
(setq vterm-term-environment-variable "xterm-256color")
(setq eat-term-name "xterm-256color")

;; Add the Flexoki Themes, and make functions with my own appearance modifications.
;; TODO: Inherit from existing faces rather than defining colors directly.
(use-package flexoki-themes
  :custom
  (flexoki-themes-use-bold-keywords t)
  (flexoki-themes-use-bold-builtins t)
  (flexoki-themes-use-italic-comments t))
(defun flexoki-bingus-dark ()
  (interactive)
  (load-theme 'flexoki-themes-dark t)
  (with-eval-after-load 'hl-line
    (set-face-background 'hl-line "#1c1b1a"))
  (set-face-attribute 'mode-line nil
		      :box '(:line-width 4 :color "#232726"))
  (set-face-attribute 'mode-line-active nil
		      :box '(:line-width 4 :color "#232726"))
  (set-face-attribute 'mode-line-inactive nil
		      :box '(:line-width 4 :color "#232726"))
  (set-face-foreground 'vertical-border
		       (face-background 'default nil t))
  (set-face-foreground 'window-divider
		       (face-background 'default nil t))
  (set-face-foreground 'window-divider-first-pixel
		       (face-background 'default nil t))
  (set-face-foreground 'window-divider-last-pixel
		       (face-background 'default nil t)))
(defun flexoki-bingus-light ()
  (interactive)
  (load-theme 'flexoki-themes-light t)
  (with-eval-after-load 'hl-line
    (set-face-background 'hl-line "#f2f0e5"))
  (set-face-attribute 'mode-line nil
		      :box '(:line-width 4 :color "#e6e4d9"))
  (set-face-attribute 'mode-line-active nil
		      :box '(:line-width 4 :color "#e6e4d9"))
  (set-face-attribute 'mode-line-inactive nil
		      :box '(:line-width 4 :color "#e6e4d9"))
  (set-face-foreground 'vertical-border
		       (face-background 'default nil t))
  (set-face-foreground 'window-divider
		       (face-background 'default nil t))
  (set-face-foreground 'window-divider-first-pixel
		       (face-background 'default nil t))
  (set-face-foreground 'window-divider-last-pixel
		       (face-background 'default nil t)))


;; Enable Auto Dark Mode, which will dynamically change light/dark themes.
(use-package auto-dark
  :after flexoki-themes
  :custom (auto-dark-allow-osascript t)
  :hook
  ;; FIXME: why doesn't it call the function directly?
  ;; (auto-dark-dark-mode  . flexoki-bingus-dark)
  ;; (auto-dark-light-mode . flexoki-bingus-light)
  (auto-dark-dark-mode  . (lambda () (flexoki-bingus-dark)))
  (auto-dark-light-mode . (lambda () (flexoki-bingus-light)))
  :config (auto-dark-mode 1))

;; Change the "DONE" faces for Org, as their contrast is too low by default.
(with-eval-after-load 'org-faces
  (set-face-foreground 'org-headline-done (face-foreground 'font-lock-comment-face))
  (set-face-foreground 'org-done          (face-foreground 'font-lock-comment-face)))

;; Use the more seamless window dividers instead of window borders.
;; Change `vertical-border`, `window-divider`, `window-divider-first-pixel`, and `window-divider-last-pixel`.
(setq window-divider-default-right-width 12)
(setq window-divider-default-places 'right-only)
(window-divider-mode 1)

;; Enable Frames-only mode in Emacs, which only uses frames (or OS windows) to view buffers.
(use-package frames-only-mode
  :config (frames-only-mode 1))

;; Enable the EAT terminal, and hook it to eshell.
(straight-use-package
 '(eat :type git
       :host codeberg
       :repo "akib/emacs-eat"
       :files ("*.el" ("term" "term/*.el") "*.texi"
               "*.ti" ("terminfo/e" "terminfo/e/*")
               ("terminfo/65" "terminfo/65/*")
               ("integration" "integration/*")
               (:exclude ".dir-locals.el" "*-tests.el"))))
(use-package eat
  :defer t
  :init (add-hook 'eshell-mode-hook #'eat-eshell-mode))

;; Enable the VTerm terminal.
(use-package vterm
  :defer t)

;; Install PDF Tools, and enable Image Roll for it.
(straight-use-package
 '(pdf-tools :type git :host github :repo "dalanicolai/pdf-tools" :branch "pdf-roll"))
(straight-use-package
 '(image-roll :type git :host github :repo "dalanicolai/image-roll.el"))
(use-package pdf-tools
  :defer t
  :mode ("\\.pdf\\'" . pdf-view-mode)
  :hook (pdf-view-mode . (lambda ()
			   (display-line-numbers-mode 0)
			   ;; (pdf-view-roll-minor-mode 1)
			   (hl-line-mode 0)))
  :config
  (pdf-tools-install)
  (evil-set-initial-state 'pdf-view-mode 'normal)
  (evil-define-key 'normal pdf-view-mode-map
    (kbd "j") #'pdf-view-next-line-or-next-page
    (kbd "k") #'pdf-view-previous-line-or-previous-page
    (kbd "C-j") #'pdf-view-next-page-command
    (kbd "C-k") #'pdf-view-previous-page-command
    (kbd "M-r") #'pdf-view-roll-minor-mode
    (kbd "gg") #'pdf-view-first-page
    (kbd "G")  #'pdf-view-last-page)
  (setq TeX-view-program-selection '((output-pdf "PDF Tools"))
	TeX-view-program-list '(("PDF Tools" TeX-pdf-tools-sync-view))
	TeX-source-correlate-start-server t)
  (add-hook 'TeX-after-compilation-finished-functions #'TeX-revert-document-buffer))
(use-package image-roll
  :after pdf-tools)
(add-hook 'LaTeX-mode-hook 'pdf-tools-install t) ;; PDF tools should be called immediately upon using AUCTeX.

;; Enable Markdown mode.
(use-package markdown-mode
  :defer t
  :mode ("\\.md\\'" . markdown-mode))

;; Reduce AUCTeX "fontify" presence, and adapt LaTeX faces to Flexoki.
(setq font-latex-fontify-script nil)
(setq font-latex-fontify-sectioning 'color)
(defun adapt-font-lock-faces-for-latex ()
  ;; Font-lock faces.
  (face-remap-add-relative 'font-lock-type-face
			   '(:inherit flexoki-themes-purple :underline t))
  (face-remap-add-relative 'font-lock-warning-face
			   '(:inherit flexoki-themes-purple :underline t))
  (face-remap-add-relative 'font-lock-keyword-face 'flexoki-themes-blue)
  (face-remap-add-relative 'font-lock-function-call-face 'flexoki-themes-cyan)
  (face-remap-add-relative 'font-lock-function-name-face 'flexoki-themes-cyan)
  (face-remap-add-relative 'font-lock-property-name-face 'flexoki-themes-purple)
  (face-remap-add-relative 'font-lock-property-use-face 'flexoki-themes-purple)
  (face-remap-add-relative 'font-lock-variable-name-face 'flexoki-themes-purple)
  (face-remap-add-relative 'font-lock-variable-use-face 'flexoki-themes-purple)
  ;; AUCTeX faces.
  (face-remap-add-relative 'font-latex-bold-face
			   '(:inherit flexoki-themes-fg :weight bold))
  (face-remap-add-relative 'font-latex-italic-face
			   '(:inherit flexoki-themes-fg :slant 'italic))
  (face-remap-add-relative 'font-latex-underline-face
			   '(:inherit flexoki-themes-fg :underline t))
  (face-remap-add-relative 'font-latex-slide-title-face
			   '(:inherit flexoki-themes-purple :underline t))
  (face-remap-add-relative 'font-latex-warning-face
			   'flexoki-themes-cyan)
  (face-remap-add-relative 'font-latex-doctex-preprocessor-face
			   '(:inherit font-latex-doctex-documentation-face :weight bold))
  (face-remap-add-relative 'font-latex-math-face
			   '(:inherit flexoki-themes-fg :slant italic))
  (face-remap-add-relative 'font-latex-script-char-face
			   '(:inherit font-lock-comment-face :weight bold))
  (face-remap-add-relative 'font-latex-string-face
			   '(:inherit flexoki-themes-highlight :weight bold))
  (face-remap-add-relative 'font-latex-verbatim-face 'flexoki-themes-highlight)
  (face-remap-add-relative 'font-latex-sectioning-0-face 'outline-1)
  (face-remap-add-relative 'font-latex-sectioning-1-face 'outline-2)
  (face-remap-add-relative 'font-latex-sectioning-2-face 'outline-3)
  (face-remap-add-relative 'font-latex-sectioning-3-face 'outline-4)
  (face-remap-add-relative 'font-latex-sectioning-4-face 'outline-5)
  (face-remap-add-relative 'font-latex-sectioning-5-face 'outline-6))
(add-hook 'LaTeX-mode-hook 'adapt-font-lock-faces-for-latex t)

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

;; TODO: inspect treesitter to replace most (but not all) major modes
;; TODO: also consider making a snippet for major modes use-package when you start implementing those

;; Enable the Nix major mode.
;; TODO: for some reason, some of the default faces for the nix mode are light / slim font. make them the regular or semibold.
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

