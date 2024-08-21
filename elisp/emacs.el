;; TODO: Remove trivial code, document anything that remains.

;; Don't ask for confirmation on creating a new buffer.
;; From a comment on:
;; https://www.masteringemacs.org/article/introduction-to-ido-mode
(defadvice ido-switch-buffer (around no-confirmation activate)
  (let ((confirm-nonexistent-file-or-buffer nil))
    ad-do-it))

;; No longer in use, but I refer back to it now and again.
(defun count-overdue (start end)
  """Format the overdue values from Org Agenda for summing and insertion into the kill ring. """
  (interactive "r")

  (let ((oldbuf (current-buffer)))
    (with-temp-buffer
      (insert-buffer-substring oldbuf start end)

      (goto-char (point-min))
      (while (re-search-forward ".*?\\([[:digit:]]+\\).*" nil t)
	(replace-match "\\1"))

      (goto-char (point-min))
      (subst-char-in-region (point-min) (point-max) ?\n ?\s)

      (fixup-whitespace)
      (insert "(+ ")
      (delete-trailing-whitespace)

      (goto-char (point-max))
      (insert ")")

      (kill-new
       (number-to-string
	(eval (car (read-from-string
		    (buffer-substring-no-properties (point-min) (point-max))))))))))

;;{{{ Logic

(defun insert-logical-operator (arg)
  "Insert the ARGth logical operator from a predefined list.
Calling the function with \"0\" prints the list."
  (interactive "*N")
  (let ((operator-list (list "∧" "∨" "¬" "⊃" "≡" "∃" "∀" "∅" "〈〉" "′")))
    (if (= 0 arg)
	(message "%s" operator-list)
      (insert (nth (- arg 1) operator-list)))))
(global-set-key (kbd "<f5>") 'insert-logical-operator)

;; http://xahlee.info/comp/unicode_circled_numbers.html
(defun insert-predicate-number (arg)
  "Insert the ARGth predicate number."
  (interactive "*N")
  (let ((predicate-list
	 (list "⓪" "①" "②" "③" "④" "⑤" "⑥" "⑦" "⑧" "⑨")))
    (insert (nth arg predicate-list))))
(global-set-key (kbd "<f6>") 'insert-predicate-number)

;;}}}
