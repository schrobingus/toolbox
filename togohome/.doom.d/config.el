;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Brent Monning"
      user-mail-address "brent.monning.jr@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (if (eq system-type 'darwin)
                    (font-spec :family "SF Mono" :size 13)
                  (font-spec :family "GeistMono Nerd Font" :size 15))
      doom-variable-pitch-font (if (eq system-type 'darwin)
                                   (font-spec :family "SF Pro" :size 13)
                                 (font-spec :family "Geist" :size 15)))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-flexoki-padded-modeline t)
;; (setq doom-flexoki-light-padded-modeline t)
(setq doom-flexoki-opaque-vertical-bar nil)
(setq doom-flexoki-light-opaque-vertical-bar nil)
(setq doom-theme 'doom-flexoki)
;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; Change some basic settings.
(setq auto-save-default nil) ;; Disable auto save, as it leaves junk files.
(setq dired-kill-when-opening-new-dired-buffer t) ;; Prevent Dired buffers from opening on new directory.
(pixel-scroll-precision-mode 1) ;; Enable smooth scrolling.
(+global-word-wrap-mode 1) ;; Enable word wrapping (the Doom way).

;; Create aliases for eshell, taken from the zsh config.
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

;; Bind `;` to `:` in NORMAL mode.
(map! :n ";" #'evil-ex)

;; Bind C-{HJKL} for navigation in INSERT mode.
(map! :i "C-h" #'backward-char)
(map! :i "C-j" #'next-line)
(map! :i "C-k" #'previous-line)
(map! :i "C-l" #'forward-char)

;; TODO: add text scale adjustment binding

;; Assign Evil's delete function to the black hole register.
;; In other words, disabling yank on delete.
(defun bb/evil-delete (orig-fn beg end &optional type _ &rest args)
  (apply orig-fn beg end type ?_ args))
(advice-add 'evil-delete :around 'bb/evil-delete)

;; Install Evil Escape to escape from INSERT to NORMAL when pressing `jk`.
(use-package! evil-escape
  :custom
  (evil-escape-key-sequence "jk")
  (evil-escape-delay 0.5)
  (evil-escape-excluded-states
   '(normal visual multiedit emacs motion))
  :config
  (evil-escape-mode 1))

;; Enable Avy. Bindings should be akin to leap.nvim.
;; TODO: extend so it's more than a leap plugin here. consider casual avy
(use-package! avy
  :custom
  (avy-all-windows t)
  :config
  (map! :n "s" #'evil-avy-goto-char-2-below)
  (map! :n "S" #'evil-avy-goto-char-2-above))

;; Enable Aggressive Indent Mode, and turn off Electric Indent Mode.
(use-package! aggressive-indent
  :config
  (add-to-list 'aggressive-indent-protected-commands 'evil-undo)
  (electric-indent-mode 0)
  (global-aggressive-indent-mode 1))

;; TODO: make corfu run with TAB or C-SPC

;; TODO: consider readding dirvish

;; TODO: consider readding agent shell

(use-package! frame
  :config
  (setq-default default-frame-alist
                (append (list
                         '(ns-transparent-titlebar . t)
                         '(internal-border-width . 16)
                         '(left-fringe           . 0)
                         '(right-fringe          . 0)
                         '(tool-bar-lines        . 0)
                         '(line-spacing          . 1)
                         '(vertical-scroll-bars  . nil))
                        default-frame-alist))
  (setq-default window-resize-pixelwise t)
  (setq-default frame-resize-pixelwise t))

;; Use the more seamless window dividers instead of window borders.
(setq window-divider-default-right-width 12)
(setq window-divider-default-places 'right-only)
(window-divider-mode 1)

;; Nuke the calls for hiding the mode line at any given point.
;; NOTE: This is too deeply engrained to remove the package itself, this effectively disables it.
(advice-add #'hide-mode-line-mode :override #'ignore)

;; TODO: consider readding olivetti

;; TODO: consider readding minions (if you revert back to the default modeline)

;; Enable the EAT terminal, and hook it into Eshell and calls for Term.
(use-package! eat
  :custom (eat-term-name "xterm-256color")
  :init
  (add-hook 'eshell-load-hook #'eat-eshell-mode)
  (add-hook 'eshell-load-hook #'eat-eshell-visual-command-mode))

;; TODO: consider readding auto-dark

;; TODO: figure out how well latex is working out here

;; Integrate latexmk with AUCTeX.
(use-package! auctex-latexmk
  :custom (auctex-latexmk-inherit-TeX-PDF-mode t)
  :config (auctex-latexmk-setup))

;; TODO: consider readding pet mode AFTER the python stack on doom has been figured

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
