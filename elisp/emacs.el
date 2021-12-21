;; https://www.masteringemacs.org/article/introduction-to-ido-mode
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

(setq ido-use-filename-at-point 'guess)
(setq ido-create-new-buffer 'always)

;; Don't ask for confirmation on creating a new buffer.
;; From a comment on:
;; https://www.masteringemacs.org/article/introduction-to-ido-mode
(defadvice ido-switch-buffer (around no-confirmation activate)
  (let ((confirm-nonexistent-file-or-buffer nil))
    ad-do-it))
