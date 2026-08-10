
;; Variables

(setq doom-font (font-spec :family "FantasqueSansM Nerd Font" :size 18 :weight 'regular)
      doom-big-font (font-spec :family "FantasqueSansM Nerd Font" :size 36 :weight 'regular)
      doom-theme 'doom-rose-pine-moon

      org-directory "~/org/"

      fill-column 120
      display-line-numbers-type 'relative
      browse-url-browser-function 'browse-url-xdg-open

      delete-by-moving-to-trash t

      +evil-want-o/O-to-continue-comments nil
      +default-want-RET-continue-comments nil)

(set-frame-parameter nil 'alpha-background 85)
(add-to-list 'default-frame-alist '(alpha-background . 85))


;; Keybindings

(map! "C-c o" #'browse-url-at-point)


;; Hooks

(add-hook 'prog-mode-hook #'display-fill-column-indicator-mode)


;; Packages

(use-package! keychain-environment
  :config
  (keychain-refresh-environment))

(after! emacs
  (setq mouse-wheel-progressive-speed nil
        mouse-wheel-scroll-amount '(3))


  (global-set-key (kbd "<M-wheel-up>")
                  (lambda () (interactive) (scroll-down 10)))

  (global-set-key (kbd "<M-wheel-down>")
                  (lambda () (interactive) (scroll-up 10))))

(after! noctalia-theme
  (custom-theme-set-faces! 'noctalia
    '(fixed-pitch :inherit default)))

(after! org
  (require 'org-superstar)
  (require 'org-appear)

  (setq org-pretty-entities t
        org-use-sub-superscripts "{}"
        org-hide-emphasis-markers t
        org-startup-indented t
        org-startup-with-inline-images nil
        org-startup-align-all-tables t
        org-startup-folded 'content
        org-appear-autolinks t
        org-appear-autoemphasis t
        org-appear-autosubmarkers t
        org-appear-autoentities t
        org-appear-inside-latex t
        org-appear-autokeywords t
        org-appear-trigger 'manual)

  (custom-set-faces!
    '(org-document-title :height 1.0 :bold t :underline nil)
    '(org-level-1 :inherit outline-1 :height 1.0)
    '(org-level-2 :inherit outline-2 :height 1.0)
    '(org-level-3 :inherit outline-3 :height 1.0)
    '(org-level-4 :inherit outline-3 :height 1.0)
    '(org-level-5 :inherit outline-3 :height 1.0)
    '(org-level-6 :inherit outline-3 :height 1.0)
    '(org-level-7 :inherit outline-3 :height 1.0)
    '(org-level-8 :inherit outline-3 :height 1.0))

  (add-hook 'org-mode-hook #'org-superstar-mode)
  (add-hook 'org-mode-hook #'org-appear-mode)

  (defun +org-appear-setup ()
    (add-hook 'evil-insert-state-entry-hook #'org-appear-manual-start nil t)
    (add-hook 'evil-insert-state-exit-hook #'org-appear-manual-stop nil t))

  (add-hook 'org-mode-hook #'+org-appear-setup))

(after! sh-script
  (defun +sh-mode-bash ()
      (when (and (buffer-file-name)
                 (not (file-exists-p (buffer-file-name))))
        (sh-set-shell "bash")))
  (add-hook 'sh-mode-hook #'+sh-mode-bash))

(after! treemacs
  (define-key treemacs-mode-map [mouse-1] #'treemacs-single-click-expand-action))

(after! git-commit
  (setq git-commit-summary-max-length 72))
