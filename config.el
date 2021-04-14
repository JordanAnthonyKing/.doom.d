;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Jordan King"
      user-mail-address "jordan@jordanking.dev")

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
;; BUG: There is something wrong with how Doom handles JP characters. Enabling the
;; `unicode' module doesn't help. For now setting both `doom-font' and `doom-unicode-font'
;; to the same font seems to do the trick but font-resizing for unicode chars is broken.
;; Enabling `unicode' prevents the unicode font specified from even being used
(setq doom-font (font-spec :family "M+ 2m" :size 16 :weight 'regular))
(setq doom-unicode-font (font-spec :family "M+ 2m" :size 16 :weight 'regular))
;;(setq doom-font (font-spec :family "Source Han Code JP" :size 13 :weight 'normal))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/documents/org/")

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

(use-package! scroll-on-jump
  :config
  (setq scroll-on-jump-duration 0.3))

(after! evil
  (map! :leader
        :desc "M-x" "SPC" #'execute-extended-command)

  ;; Just experimenting for now
  (scroll-on-jump-advice-add evil-jump-item)
  (scroll-on-jump-advice-add evil-ex-search-previous)
  (scroll-on-jump-advice-add evil-forward-paragraph)
  (scroll-on-jump-advice-add evil-backward-paragraph)
  ; (scroll-on-jump-advice-add evil-goto-first-line)
  ;; Actions that themselves scroll.
  (scroll-on-jump-advice-add better-jumper-jump-forward)
  (scroll-on-jump-advice-add better-jumper-jump-backward)
  ; (scroll-on-jump-with-scroll-advice-add evil-goto-line)
  (scroll-on-jump-with-scroll-advice-add evil-scroll-down)
  ; (scroll-on-jump-with-scroll-advice-add evil-scroll-line-to-center)
  ; (scroll-on-jump-with-scroll-advice-add evil-scroll-line-to-top)
  ; (scroll-on-jump-with-scroll-advice-add evil-scroll-line-to-bottom)
  (scroll-on-jump-with-scroll-advice-add evil-scroll-up))

(after! undo-fu
  (scroll-on-jump-advice-add undo-fu-only-undo)
  (scroll-on-jump-advice-add undo-fu-only-redo))

(after! japanese
  (map! "C-x C-j" #'skk-mode)
  (setq skk-large-jisyo "~/.local/share/skk/SKK-JISYO.L"
        skk-record-file "~/.local/share/skk/SKK-RECORD"))

;; For when lsp-mode fixes imenu support for typescript
(defun my/filter-items (orig-fun item)
  (or (funcall orig-fun item)
      (eq (gethash "kind" item) 13)
      (eq (gethash "kind" item) 14)
      (eq (gethash "kind" item) 15)
      (eq (gethash "kind" item) 16)
      (eq (gethash "kind" item) 17)
      (eq (gethash "kind" item) 18)
      (eq (gethash "kind" item) 19)
      (eq (gethash "kind" item) 20)
      (eq (gethash "kind" item) 21)
      (eq (gethash "kind" item) 22)
      (eq (gethash "kind" item) 23)
      (eq (gethash "kind" item) 24)
      (eq (gethash "kind" item) 25)
      (eq (gethash "kind" item) 26)))

(after! lsp-mode
  (setq lsp-auto-execute-action nil
        ; lsp-enable-imenu 1
        ; lsp-imenu-index-symbol-kinds '(Method Property Field Constructor Enum Interface Event Struct)
        ; lsp-imenu-index-symbol-kinds '(Miscellaneous)
        lsp-clients-typescript-log-verbosity "debug"
        ; Could be great for csharp
        ; lsp-headerline-breadcrumb-enable 1
        ; lsp-headerline-breadcrumb-segments '(project file symbols)
        lsp-clients-typescript-plugins
        (vector
         (list :name "typescript-tslint-plugin"
               ; :location "~/.emacs.d/.local/npm/node_modules/typescript-tslint-plugin/"))))
               :location "/usr/lib/node_modules/typescript-tslint-plugin/"))))

(after! lsp-ui
  (setq lsp-ui-sideline-show-code-actions nil
        lsp-ui-sideline-show-symbol nil
        lsp-ui-sideline-diagnostic-max-lines 10
        lsp-ui-sideline-diagnostic-max-line-length 75))

(after! doom-modeline
  (setq doom-modeline-bar-width 3
        ; doom-modeline-buffer-file-name-style 'buffer-name
        doom-modeline-buffer-file-name-style 'file-name
        doom-modeline-buffer-encoding nil
        doom-modeline-vcs-max-length 18
        doom-modeline-persp-icon nil
        doom-modeline-buffer-modification-icon nil))

(after! treemacs
  (setq treemacs-width 50
        treemacs-recenter-distance 0.05
        treemacs-recenter-after-file-follow 'on-distance)
  (treemacs-follow-mode 1)
  (treemacs-fringe-indicator-mode 1))

(add-hook! treemacs-mode
  (treemacs-load-theme "doom-colors"))

(after! highlight-indent-guides
  (setq highlight-indent-guides-character 124))

;; TODO: Automatically open company on . if not already
(after! company
  (setq company-minimum-prefix-length 1))

;; TODO: Make this purely idle-delay based instead
(after! flycheck
  (setq flycheck-check-syntax-automatically
        '(save mode-enabled idle-buffer-switch new-line))
  (map! :leader
        (:prefix-map ("c" . "code")
         :desc "Next error"     "n" #'flycheck-next-error
         :desc "Previous error" "p" #'flycheck-previous-error)))

;; DOOG
(setq fancy-splash-image "~/.doom.d/doog2.png")

(add-hook! +doom-dashboard-mode
  (setq +doom-dashboard-banner-padding '(0 . 2)))

; (good-scroll-mode 1)

; (after! org
  ; ;; Workaround for not being able to use `RET' in `org-mode'
  ; (add-hook org-mode-hook (lambda () (electric-indent-local-mode -1)))
  ; (setq org-startup-indent 0
        ; org-startup-folded t)
  ; (add-hook! org-mode ((company-mode 0)
                       ; (flycheck-mode 0))))
