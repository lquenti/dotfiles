(setq inhibit-startup-message t)
(setq initial-scratch-message ";; happy hacking")
(scroll-bar-mode -1)

;; no blinking in this house
(blink-cursor-mode -1)

;; Once I get better I'll remove it
;; For now it's quite useful
;; (tool-bar-mode -1) ;; Toolbar are big icons
;; (menu-bar-mode -1) ;; the smol bar

;; Frame title
;; TODO: What is the first empty string for
(setq frame-title-format '("" "emacs :: %b -> screen"))

;; Don't trash everything with autosaves
;; TODO: Again, what is the noise
(setq backup-directory-alist '(("." . "/tmp/emacsbackups")))

;; TODO: Add linum-relative for absolute relative line numbers
(global-display-line-numbers-mode)
