
;; Variables

(setq-default fill-column 120
              display-line-numbers-type 'relative)

(setq doom-font (font-spec :family "FantasqueSansM Nerd Font Mono" :size 18 :weight 'regular)
      doom-big-font (font-spec :family "FantasqueSansM Nerd Font Mono" :size 36 :weight 'regular)
      doom-theme 'doom-rose-pine-moon

      org-directory "~/org/"

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
  (require 'org-re-reveal)

  (defun +org-capture-at-end-of-ideas ()
    "Position point at the end of the last top-level IDEA subtree."
    (goto-char (point-max))
    (when (re-search-backward "^\\* IDEA\\b" nil t)
      (org-end-of-subtree))
    (point))

  (setq org-pretty-entities t
        org-use-sub-superscripts "{}"
        org-hide-emphasis-markers t
        org-ellipsis " ▾ "

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
        org-appear-trigger 'manual
        org-re-reveal-margin "0.15"

        org-latex-compiler "xelatex"

        org-export-headline-levels 4

        org-re-reveal-root (expand-file-name "assets/reveal.js/" doom-user-dir)
        org-re-reveal-extra-css (expand-file-name "assets/reveal.css" doom-user-dir)
        org-re-reveal-revealjs-version "6"
        org-re-reveal-theme "serif"
        org-re-reveal-width 1024
        org-re-reveal-height 768
        org-re-reveal-single-file t
        org-re-reveal-subtree-with-title-slide nil

        org-capture-templates
        `(("t", "To Do" entry
           (file ,(expand-file-name "admin/todo.org" org-directory))
           "* TODO %?"
           :prepend t
           :empty-lines-before 1)

          ("l" "Log" entry
           (file ,(expand-file-name "admin/log.org" org-directory))
           "* %u\n%?"
           :prepend t
           :empty-lines-before 1
           :empty-lines-after 1)

          ("j" "Journal" entry
           (file+olp+datetree ,(expand-file-name "admin/journal.org" org-directory))
           "* %?\nEntered on %U\n")

          ("v" "Video" plain
           (file+function
            ,(expand-file-name "content/videos.org" org-directory)
            +org-capture-at-end-of-ideas)
           (file ,(expand-file-name "templates/videos.org" org-directory))
           :empty-lines-before 1
           :empty-lines-after 1)

          ("r" "Research")

          ("rb" "Research books" plain
           (file ,(expand-file-name "research/books.org" org-directory))
           (file ,(expand-file-name "templates/research-books.org" org-directory))
           :empty-lines-before 1
           :empty-lines-after 1)

          ("rw" "Research web" plain
           (file ,(expand-file-name "research/web.org" org-directory))
           (file ,(expand-file-name "templates/research-web.org" org-directory))
           :empty-lines-before 1
           :empty-lines-after 1)))

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

(after! ox
  (defvar +org-export-dir (expand-file-name "~/Desktop/org-export/"))

  (advice-add
   'org-export-output-file-name
   :filter-args
   (lambda (args)
     (unless (file-directory-p +org-export-dir)
       (make-directory +org-export-dir t))
     (list (nth 0 args) (nth 1 args) +org-export-dir))))

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
