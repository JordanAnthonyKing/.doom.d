(after! org
  (add-hook! 'org-mode-hook #'(valign-mode t))
  (add-hook! 'org-mode-local-vars-hook (highlight-indent-guides-mode -1))
  (setq org-startup-folded t
        org-id-track-globally t
        org-startup-indented nil
        org-link-descriptive nil
        org-list-demote-modify-bullet '(("1." . "a."))))
        ; org-tags-match-list-sublevels nil))
