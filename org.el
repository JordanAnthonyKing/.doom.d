(after! org
  (add-hook! 'org-mode-hook #'valign-mode)
  (setq org-startup-folded t
        org-id-track-globally t
        org-startup-indented nil
        org-list-demote-modify-bullet '(("1." . "a."))))
        ; org-tags-match-list-sublevels nil))
