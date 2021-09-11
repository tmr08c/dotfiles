;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Troy Rosenberg"
      user-mail-address "tmr08c@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "JetBrains Mono" :size 13.0)
      doom-variable-pitch-font (font-spec :family "JetBrains Mono" :size 15))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; UI

;; Default to word-wrapping everywhere
(global-visual-line-mode t)

;; org

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Dropbox/Notes/org/")


(defvar tr/org-templates-directory (concat org-directory "templates/") "Directory for storing org-mode template")

;; DOOM defines some capture templates, add to the list
;; https://github.com/hlissner/doom-emacs/issues/1391#issuecomment-489993881
(after! org
  (add-to-list 'org-capture-templates
             `("l" "TIL" entry
               (file ,(concat org-directory "til.org"))
               "* %t\nSomething")))


;; org-roam
(setq org-roam-directory (concat org-directory  "roam/")
      org-roam-dailies-capture-templates
      (let ((head (with-temp-buffer
                    (insert-file-contents (concat tr/org-templates-directory "daily.org"))
                    (buffer-string))))
            `(("d" "default" entry
               #'org-roam-capture--get-point
               "* %?"
               :file-name "daily/%<%Y-%m-%d>"
               :head ,head
               :olp ("Journal" "Reflection" "How was yesterday?"))
              ("t" "todo" item
               #'org-roam--capture-get-point
               "[ ]"
               :file-name "daily/%<%Y-%m-%d>"
               :head ,head
               :olp ("Planning")))))
;; (setq org-roam-dailies-capture-templates
;;           (let ((head "#+title: %<%Y-%m-%d (%A)>\n#+startup: showall\n* [/] Do Today\n* [/] Maybe Do Today\n* Journal\n"))
;;             `(("j" "journal" entry
;;                #'org-roam-capture--get-point
;;                "* %<%H:%M> %?"
;;                :file-name "daily/%<%Y-%m-%d>"
;;                :head ,head
;;                :olp ("Journal"))
;;               ("t" "do today" item
;;                #'org-roam-capture--get-point
;;                "[ ] %(princ as/agenda-captured-link)"
;;                :file-name "daily/%<%Y-%m-%d>"
;;                :head ,head
;;                :olp ("Do Today")
;;                :immediate-finish t)
;;               ("m" "maybe do today" item
;;                #'org-roam-capture--get-point
;;                "[ ] %(princ as/agenda-captured-link)"
;;                :file-name "daily/%<%Y-%m-%d>"
;;                :head ,head
;;                :olp ("Maybe Do Today")
;;                :immediate-finish t))))


;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; programming

;; lsp
(after! lsp-mode
  ;; Using LSP for smarter folding with lsp-origami
  ;; https://blog.evalcode.com/enable-elixir-code-folding-in-doom-emacs/

  ;; Add origami and LSP integration
  (use-package! lsp-origami)
  (add-hook! 'lsp-after-open-hook #'lsp-origami-try-enable)

  ;; Enable folding
  (setq lsp-enable-folding t)

  ;; Ignore certain directories to limit file watchers
  (dolist (match
           '("[/\\\\].elixir_ls"
             "[/\\\\]node_modules$"
             "[/\\\\]deps"
             "[/\\\\]build"
             "[/\\\\]_build"))
    (add-to-list 'lsp-file-watch-ignored-directories match)))

;; polymode

;; Set up polymode to support web-mode in LiveView `render` functions
;; https://blog.evalcode.com/phoenix-liveview-inline-syntax-highlighting-for-emacs/
(use-package! polymode
  :mode ("\.ex$" . poly-elixir-web-mode)
  :config
  (define-hostmode poly-elixir-hostmode :mode 'elixir-mode)
  (define-innermode poly-liveview-expr-elixir-innermode
    :mode 'web-mode
    :head-matcher (rx line-start (* space) "~L" (= 3 (char "\"'")) line-end)
    :tail-matcher (rx line-start (* space) (= 3 (char "\"'")) line-end)
    :head-mode 'host
    :tail-mode 'host
    :allow-nested nil
    :keep-in-mode 'host
    :fallback-mode 'host)
  (define-polymode poly-elixir-web-mode
    :hostmode 'poly-elixir-hostmode
    :innermodes '(poly-liveview-expr-elixir-innermode))
  )
(setq web-mode-engines-alist '(("elixir" . "\\.ex\\'")))

;; projectile
(setq
 projectile-project-search-path '("~/code/"))

;; ruby
(setq
 rspec-use-spring-when-possible t)

;; rust
(after! rustic
  (setq rustic-lsp-server 'rls))

;; formatting
(setq +format-on-save-enabled-modes
      '(not mhtml-mode)) ; doesn't work well with partials
