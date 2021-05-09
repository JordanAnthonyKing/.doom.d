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

;; TODO BUG: There is something wrong with how Doom handles JP characters. Enabling the
;; `unicode' module doesn't help. For now setting both `doom-font' and `doom-unicode-font'
;; to the same font seems to do the trick but font-resizing for unicode chars is broken.
;; Enabling `unicode' prevents the unicode font specified from even being used
; (setq doom-font (font-spec :family "M+ 2m" :size 30 :weight 'regular :slant 'italic))
; (setq doom-unicode-font (font-spec :family "M+ 2m" :size 30 :weight 'regular :slant 'italic))
; (setq doom-variable-pitch-font (font-spec :family "M+ 2c" :size 30 :weight 'light))
(setq doom-font (font-spec :family "Source Han Code JP" :size 26 :weight 'regular))
(setq doom-unicode-font (font-spec :family "Source Han Code JP" :size 26 :weight 'regular))

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

(load! "jira.el")
(load! "forge.el")
(load! "snips.el")

(use-package! scroll-on-jump
  :config
  (setq scroll-on-jump-duration 0.3))

(after! evil
  (map! :leader
        :desc "M-x" "SPC" #'execute-extended-command)

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

;; TODO: Find the record file
(after! japanese
  (map! "C-x C-j" #'skk-mode)
  (setq skk-large-jisyo "~/.local/share/skk/SKK-JISYO.L"
        skk-record-file "~/.local/share/skk/SKK-RECORD"))

;; TODO: typescript intellisense
(after! lsp-mode
  (add-hook! lsp-completion-mode
   ;(setq-local +lsp-company-backends '(:separate company-yasnippet company-capf)))
    (setq-local +lsp-company-backends '(company-capf)))
  (setq lsp-auto-execute-action nil
        lsp-signature-auto-activate nil
        lsp-signature-render-documentation nil
        lsp-modeline-diagnostics-enable nil
        lsp-modeline-code-actions-enable nil
        lsp-imenu-sort-methods '(position)
        lsp-clients-typescript-log-verbosity "debug"))

(after! lsp-ui
  (setq lsp-ui-sideline-actions-icon nil
        lsp-ui-sideline-diagnostic-max-lines 5))

(after! doom-modeline
  (setq doom-modeline-buffer-file-name-style 'file-name
        doom-modeline-buffer-encoding nil
        doom-modeline-vcs-max-length 18
        doom-modeline-buffer-modification-icon nil))

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

; TODO configure and add use-package
; (setq good-scroll-step 180
      ; good-scroll-avoid-vscroll-reset nil)
; (good-scroll-mode 1)

(after! company
  (setq company-global-modes '(not
                               text-mode ; This one may be overkill
                               erc-mode
                               message-mode
                               help-mode
                               gud-mode
                               gfm-mode
                               forge-post-mode
                               org-mode)))

;; Workaround for not being able to use `RET' in `org-mode'
;; TODO: Only needed in Emacs < 28 (actually seems like this isn't the case)
; (add-hook org-mode-hook (lambda () (electric-indent-local-mode -1)))
(after! org
  (add-hook! 'org-mode-hook #'valign-mode)
  (setq org-startup-folded t
        org-id-track-globally t
        org-tags-match-list-sublevels nil))

(after! ivy
  (setq +ivy-buffer-preview t)
  (add-to-list 'ivy-more-chars-alist
               '(counsel-rg . 3)))

;; TODO: Fix markdown mode icon in file browser
(after! all-the-icons
  ; Fix certain icons that're poorly sized
  (add-to-list 'all-the-icons-icon-alist
    '("\\.less$" all-the-icons-alltheicon "less"       :height 1.0 :face all-the-icons-dyellow))
  (add-to-list 'all-the-icons-icon-alist
    '("\\.png$"  all-the-icons-octicon    "file-media" :height 1.125 :v-adjust 0.0 :face all-the-icons-orange))
  (add-to-list 'all-the-icons-icon-alist
    '("\\.otf$"  all-the-icons-fileicon   "font"       :v-adjust 0.0 :face all-the-icons-dcyan))
  ; Mode icons
  (add-to-list 'all-the-icons-mode-icon-alist
    '(less-css-mode all-the-icons-alltheicon  "less"  :height 1.0 :face all-the-icons-dyellow))
  (add-to-list 'all-the-icons-mode-icon-alist
    '(web-mode      all-the-icons-alltheicon  "html5" :face all-the-icons-orange)))

(after! all-the-icons-ivy
  (add-hook! ivy-mode (setq-local tab-width 2))
  (add-hook! counsel-mode (setq-local tab-width 2)))

(after! all-the-icons-dired
  (add-hook! all-the-icons-dired-mode (setq-local tab-width 2))
  (setq all-the-icons-dired-monochrome nil))

(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "wslview")

; For suggestions `~/.emacs.d/.local/etc/ispell/en_GB.pws' needs modifying to specify
; the typical en dictionary
(setq ispell-dictionary "en_GB")
