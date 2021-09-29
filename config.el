;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
(setq user-full-name "Jordan King"
      user-mail-address "jordan@jordanking.dev")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.

; (setq doom-font (font-spec :family "M+ 2m" :size 30 :weight 'regular))
; (setq doom-unicode-font (font-spec :family "M+ 2m" :size 30 :weight 'regular))
; (setq doom-variable-pitch-font (font-spec :family "M+ 2c" :size 30 :weight 'light))
(setq doom-font (font-spec :family "Source Han Code JP" :size 16 :weight 'regular))
(setq doom-unicode-font (font-spec :family "Source Han Code JP" :size 16 :weight 'regular))

(setq doom-theme 'doom-one)
(setq org-directory "~/documents/org/")
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

; (load! "snips.el")
(load! "org.el")

;; Scrolling
(setq
 scroll-margin 3
 mouse-wheel-scroll-amount '(1 ((shift) . hscroll)))

(use-package! scroll-on-jump
  :config
  (setq scroll-on-jump-duration 0.3
        scroll-on-jump-smooth nil))

(after! evil
  (map! :leader
        :desc "M-x" "SPC" #'execute-extended-command)
  (map! :n "gj" #'evil-next-visual-line
        :n "gk" #'evil-previous-visual-line)

  (scroll-on-jump-advice-add evil-jump-item)
  (scroll-on-jump-advice-add evil-ex-search-previous)
  (scroll-on-jump-advice-add evil-ex-search-next)
  (scroll-on-jump-advice-add evil-forward-paragraph)
  (scroll-on-jump-advice-add evil-backward-paragraph)
  ;; Actions that themselves scroll.
  (scroll-on-jump-with-scroll-advice-add evil-scroll-down)
  (scroll-on-jump-with-scroll-advice-add evil-scroll-up))

(after! undo-fu
  (scroll-on-jump-advice-add undo-fu-only-undo)
  (scroll-on-jump-advice-add undo-fu-only-redo))

(after! better-jumper
  (scroll-on-jump-advice-add better-jumper-jump-forward)
  (scroll-on-jump-advice-add better-jumper-jump-backward))

;; Japanese
(after! skk
  (setq skk-large-jisyo "~/.local/share/skk/SKK-JISYO.L"
        skk-record-file "~/.local/share/skk/SKK-RECORD")
  (remove-hook 'doom-escape-hook 'skk-mode-exit))

(after! japanese
  (remove-hook 'text-mode-hook 'pangu-spacing-mode))

;; LSP
(after! lsp-mode
 (setq lsp-clients-typescript-plugins
       (vector (list
        :name "@vsintellicode/typescript-intellicode-plugin"
        :location "/home/jordan/.vscode/extensions/visualstudioexptteam.vscodeintellicode-1.2.13/"))))

;(after! lsp-mode
  ; (add-hook! lsp-completion-mode
    ; (setq-local +lsp-company-backends '(company-capf)))
  ; ; (add-hook! css-mode-hook #'(lsp-headerline-breadcrumb-mode))
  ; (advice-add 'lsp :before (lambda (&rest _args) (eval '(setf (lsp-session-server-id->folders (lsp-session)) (ht)))))
  ; (setq ; lsp-auto-execute-action nil
        ; ; lsp-signature-auto-activate nil
        ; ; lsp-signature-render-documentation nil
        ; ; lsp-modeline-diagnostics-enable nil
        ; ; lsp-modeline-code-actions-enable nil
        ; ; lsp-imenu-sort-methods '(position)
        ; ; lsp-clients-typescript-log-verbosity "debug"
        ; lsp-headerline-breadcrumb-segments '(file symbols)
        ; ; lsp-headerline-breadcrumb-enable t
        ; lsp-headerline-breadcrumb-icons-enable t
        ; lsp-clients-typescript-plugins (vector
                                        ; (list
                                        ; :name "@vsintellicode/typescript-intellicode-plugin"
                                        ; :location "/home/jordan/.vscode/extensions/visualstudioexptteam.vscodeintellicode-1.2.13/"))))
;
; ; (after! lsp-ui
; ; (setq lsp-ui-sideline-actions-icon nil
; ; lsp-ui-sideline-diagnostic-max-lines 5))
;
; (add-hook! '(css-mode-local-vars-hook
             ; scss-mode-local-vars-hook
             ; sass-mode-local-vars-hook
             ; less-css-mode-local-vars-hook)
             ; #'lsp-headerline-breadcrumb-mode)

;; Modeline
; (after! doom-modeline
  ; (setq doom-modeline-buffer-file-name-style 'file-name
        ; doom-modeline-buffer-encoding nil
        ; doom-modeline-vcs-max-length 18
        ; doom-modeline-buffer-modification-icon nil))

(after! doom-modeline
  (setq doom-modeline-buffer-encoding nil
        doom-modeline-vcs-max-length 18))

;; Guides
(after! highlight-indent-guides
  (setq highlight-indent-guides-character 124
        highlight-indent-guides-responsive 'top))

(after! flycheck
  (setq flycheck-global-modes '(not org-mode))
  (map! :leader
        (:prefix-map ("c" . "code")
         :desc "Next error"     "n" #'flycheck-next-error
         :desc "Previous error" "p" #'flycheck-previous-error)))

(after! ranger
  (add-hook! ranger-mode #'hide-mode-line-mode)
  (map! :map ranger-mode-map
        (:prefix-map ("c")
         :desc "Create file"           "f" #'dired-create-empty-file
         :desc "Create directory"      "d" #'dired-create-directory))
  (setq ranger-show-hidden t
        ranger-modify-header nil))

(after! dired
  (map! :leader
        (:prefix-map ("f" . "file")
         :desc "Open current directory" "o" #'dired-jump)))

;; DOOG
(setq fancy-splash-image "~/.doom.d/doog2.png")
(add-hook! +doom-dashboard-mode
  (setq +doom-dashboard-banner-padding '(2 . 2)))

(after! company
  (plist-put! company-global-modes 'org-mode 'forge-post-mode 'markdown-mode 'text-mode))

;; Ivy
(after! ivy
  (add-to-list #'ivy-more-chars-alist '(counsel-rg . 3))
  (setq +ivy-buffer-preview t))

;; Icons
(after! all-the-icons-ivy
  (add-hook! ivy-mode (setq-local tab-width 2))
  (add-hook! counsel-mode (setq-local tab-width 2)))

(after! all-the-icons-dired
  (add-hook! all-the-icons-dired-mode (setq-local tab-width 2))
  (setq all-the-icons-dired-monochrome nil))

;; Browser
;; TODO: I don't know if this works
(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "wslview")

;; Spelling
;; For suggestions `~/.emacs.d/.local/etc/ispell/en_GB.pws' needs modifying to specify
;; the typical en dictionary
(setq ispell-dictionary "en_GB")
