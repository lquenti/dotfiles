(setq inhibit-startup-message t)
(setq initial-scratch-message ";; happy hacking")
(scroll-bar-mode -1)

;; no bells or blinking
(setq visible-bell nil ring-bell-function 'ignore)

;; I said no blinking!
(blink-cursor-mode -1)

;; Once I get better I'll remove it
;; For now it's quite useful
; (tool-bar-mode -1) ;; Toolbar are big icons
; (menu-bar-mode -1) ;; the smol bar

;; Frame title
(setq frame-title-format '("" "emacs schmemacs sag ich ma"))

;; Don't trash everything with autosaves
(setq backup-directory-alist '(("." . "/tmp/emacsbackups")))

;; TODO: Add linum-relative for absolute relative line numbers
(global-display-line-numbers-mode)

;; Show where to aggregate my agenda from
(setq org-agenda-files (directory-files-recursively "~/Documents/org/" "\\.org$"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Bootstrap use-package
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))
(package-initialize)

;; Repoinit. Analagous to apt update
(unless package-archive-contents (package-refresh-contents))

;; <SOMETHING>-p => its a predicate <=> a -> Bool
(unless (package-installed-p 'use-package) (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)


;; Make ESC quit prompts
;; Normally it would take ESC-ESC-ESC
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Iosevka Term" :foundry "CYEL" :slant normal :weight normal :height 98 :width normal)))))
