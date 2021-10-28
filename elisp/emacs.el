;; Helper function for cleaning up Latin conjugation files.
(defun declinatio-macrons ()
  """Replace a/e/i/o/u with their respective variants with macrons."""
  (interactive)

  (cond ((eq (char-after (point)) 97)
	 (progn (delete-forward-char 1)
		(insert-char ?ā)))
	((eq (char-after (point)) 101)
	 (progn (delete-forward-char 1)
		(insert-char ?ē)))
	((eq (char-after (point)) 105)
	 (progn (delete-forward-char 1)
		(insert-char ?ī)))
	((eq (char-after (point)) 111)
	 (progn (delete-forward-char 1)
		(insert-char ?ō)))
	((eq (char-after (point)) 117)
	 (progn (delete-forward-char 1)
		(insert-char ?ū)))
	(t (forward-char))))


;; ;; https://www.masteringemacs.org/article/introduction-to-ido-mode
;; (setq ido-enable-flex-matching t)
;; (setq ido-everywhere t)
;; (ido-mode 1)

;; (setq ido-use-filename-at-point 'guess)
;; (setq ido-create-new-buffer 'always)

;; ;; Don't ask for confirmation on creating a new buffer.
;; ;; From a comment on:
;; ;; https://www.masteringemacs.org/article/introduction-to-ido-mode
;; (defadvice ido-switch-buffer (around no-confirmation activate)
;;   (let ((confirm-nonexistent-file-or-buffer nil))
;;     ad-do-it))
