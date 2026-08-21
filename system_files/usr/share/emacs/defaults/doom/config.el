
;; Variables

(setq-default fill-column 120
              display-line-numbers-type t)

(setq doom-font (font-spec :family "FantasqueSansM Nerd Font Mono" :size 13.5 :weight 'regular)
      doom-big-font (font-spec :family "FantasqueSansM Nerd Font Mono" :size 28.0 :weight 'regular)
      doom-theme 'doom-rose-pine-moon

      org-directory "~/org/"

      browse-url-browser-function 'browse-url-xdg-open

      delete-by-moving-to-trash t

      +evil-want-o/O-to-continue-comments nil
      +default-want-RET-continue-comments nil)

(add-to-list 'face-font-rescale-alist '("Noto Color Emoji" . 0.85))
(set-fontset-font t 'emoji (font-spec :family "Noto Color Emoji" :spacing 100) nil 'prepend)

(set-frame-parameter nil 'alpha-background 85)
(add-to-list 'default-frame-alist '(alpha-background . 85))


;; Keybindings

(map! "C-c o" #'browse-url-at-point)

(map! :leader
      :prefix ("n T" . "templates")

      :desc "Insert video template"
      "v" #'dlt/org-insert-video-template

      :desc "Insert book template"
      "b" #'dlt/org-insert-book-template

      :desc "Insert web template"
      "w" #'dlt/org-insert-web-template)


;; Hooks

(add-hook 'prog-mode-hook #'display-fill-column-indicator-mode)


;; Packages

(use-package! keychain-environment
  :config
  (keychain-refresh-environment))

(use-package org-table-wrap-functions
  :load-path
  (lambda ()
    (expand-file-name
     ".local/straight/repo/org-table-wrap-functions"
     doom-emacs-dir)))

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

  (defun dlt/org-appear-setup ()
    (add-hook 'evil-insert-state-entry-hook #'org-appear-manual-start nil t)
    (add-hook 'evil-insert-state-exit-hook #'org-appear-manual-stop nil t))

  (defun dlt/org-capture-after-last (keyword)
    "Position point at the end of the last top-level todo keyword subtree."
    (goto-char (point-max))
    (when (re-search-backward (format "^\\* %s\\b" keyword) nil t)
      (org-end-of-subtree))
    (point))

  (defun dlt/org-insert-template-file (filename)
    "Insert and process an org template file."
    (interactive
     (list
      (completing-read
       "Template: "
       (directory-files
        (expand-file-name "templates" org-directory)
        nil
        "\\.org\\'")
       nil
       t)))
    (let* ((level (or (org-current-level) 0))
           (template
            (with-temp-buffer
              (insert-file-contents
               (expand-file-name
                filename
                (expand-file-name "templates" org-directory)))
              (buffer-string)))
           (template (org-capture-fill-template template)))
      (insert
       (with-temp-buffer
         (insert template)
         (goto-char (point-min))
         (while (re-search-forward "^\\(\\*+\\) " nil t)
           (replace-match
            (concat (make-string level ?*)
                    (match-string 1)
                    " ")
            t))
         (buffer-string)))))

  (defun dlt/org-insert-video-template ()
    "Insert and process the video template."
    (interactive)
    (dlt/org-insert-template-file "video.org"))

  (defun dlt/org-insert-book-template ()
    "Insert and process the book template."
    (interactive)
    (dlt/org-insert-template-file "book.org"))

  (defun dlt/org-insert-web-template ()
    "Insert and process the web template."
    (interactive)
    (dlt/org-insert-template-file "web.org"))

  (setq org-pretty-entities t
        org-use-sub-superscripts "{}"
        org-hide-emphasis-markers t
        org-ellipsis " ▾ "

        org-agenda-files
        (list
         (expand-file-name "admin/todo.org" org-directory))

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

        org-latex-compiler "lualatex"
        org-preview-latex-default-process 'lualatex

        org-export-headline-levels 4
        org-export-initial-scope 'subtree

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
           (file+olp+datetree ,(expand-file-name "admin/journal.org.gpg" org-directory))
           "* %?\nEntered on %U\n")

          ("v" "Video")

          ("vi" "Video Idea" plain
           (file+function
            ,(expand-file-name "content/videos.org" org-directory)
            (lambda () (dlt/org-capture-after-last "IDEA")))
           "* IDEA %?"
           :empty-lines-before 1)

          ("vt" "Video To Do" plain
           (file+function
            ,(expand-file-name "content/videos.org" org-directory)
            (lambda () (dlt/org-capture-after-last "TODO")))
           "* TODO %?"
           :empty-lines-before 1)

          ("r" "Research")

          ("rb" "Research Book" plain
           (file ,(expand-file-name "research/books.org" org-directory))
           (file ,(expand-file-name "templates/book.org" org-directory))
           :empty-lines-before 1
           :empty-lines-after 1)

          ("rw" "Research Web" plain
           (file ,(expand-file-name "research/web.org" org-directory))
           (file ,(expand-file-name "templates/web.org" org-directory))
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

  (add-to-list 'org-latex-packages-alist '("" "amsmath" t))
  (add-to-list 'org-latex-packages-alist '("" "amssymb" t))

  (add-to-list
   'org-preview-latex-process-alist
   '(lualatex
     :programs ("lualatex" "convert")
     :description "LuaLaTeX + ImageMagick (PDF to PNG)"
     :message "You need to install lualatex and imagemagick."
     :image-input-type "pdf"
     :image-output-type "png"
     :image-size-adjust (0.99 . 0.99)
     :latex-compiler ("lualatex -interaction=nonstopmode -output-format=pdf -output-directory=%o %f")
     :image-converter ("convert -density %D %f -trim +repage -antialias -quality 100 %O")))

  (add-hook!
   'org-mode-hook
   #'org-superstar-mode
   #'org-appear-mode
   #'dlt/org-appear-setup))

(after! ox
  (defvar +org-export-dir (expand-file-name "~/Desktop/org-export/"))

  (advice-add
   'org-export-output-file-name
   :filter-args
   (lambda (args)
     (unless (file-directory-p +org-export-dir)
       (make-directory +org-export-dir t))
     (list (nth 0 args) (nth 1 args) +org-export-dir))))

(after! ox-latex
  (add-to-list 'org-latex-classes
               '("article"
                 "\\documentclass{article}
\\usepackage[left=1.5cm,right=1.5cm,top=1.5cm,bottom=3cm]{geometry}
\\usepackage{fontspec}
\\directlua{luaotfload.add_fallback(\"emoji\", {\"Noto Emoji:mode=harf\"})}
\\setmainfont{Latin Modern Roman}[RawFeature={fallback=emoji}]"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))))

(after! epa
  (setq epa-file-encrypt-to '("your.email@example.com"))
  (setq epa-file-select-keys 'silent))

(after! sh-script
  (defun dlt/sh-mode-bash ()
      (when (and (buffer-file-name)
                 (not (file-exists-p (buffer-file-name))))
        (sh-set-shell "bash")))
  (add-hook 'sh-mode-hook #'dlt/sh-mode-bash))

(after! just-mode
  (add-to-list 'auto-mode-alist '("\\.just\\'" . just-mode)))

(after! treemacs
  (define-key treemacs-mode-map [mouse-1] #'treemacs-single-click-expand-action))

(after! git-commit
  (setq git-commit-summary-max-length 72))
