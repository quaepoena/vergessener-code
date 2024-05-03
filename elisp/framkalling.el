(defun framkalling (mappe1 mappe2)
  (declare-function mønstermåta "framkalling" (fil avløysar))
  (declare-function filnamn "framkalling" (fil))
  (declare-function få-hjelpetekst "framkalling" (x))
  (declare-function visa-fil "framkalling" (fil))

  (defun mønstermåta (fil avløysar)
    "Mønstermåta filnamnet."
    (replace-regexp-in-string (car avløysar) (cdr avløysar) fil))

  (defun filnamn (fil)
    "Returnera alt etter den siste \"/\"-en av FIL."
    (when (string-match (rx bol
			    (zero-or-more any)
			    "/"
			    (group (one-or-more any)
				   "."
				   (one-or-more alnum))
			    eol)
			fil)
      (match-string 1 fil)))

  (defun visa-fil (fil)
    (find-file-other-window fil)
    (other-window 1))

  (defun få-hjelpetekst (x)
    "Hjelpeteksta som viser um eit bilete vert med."
    (if x
	"Dette biletet vert med."
      "Dette biletet vert IKKJE med."))

  (defun oppdatera-antal (gamal ny antal)
    "Um GAMAL er lik NY, heve valet ikkje endra seg, og me returnera
ANTAL. Um det ikkje stemmer, viser NY um me lyt auka eller minska ANTAL."
    (if (eq gamal ny)
	antal
      (if ny
	  (1+ antal)
	(1- antal))))

  (defun fulføring (x)
    "Særeigen fulføringsfunksjon til `completing-read'."
    (let ((val '("j" "n" "f" "p" "a" "S" "E" "")))

      (or (member x val)
	  (string-match-p (rx line-start (one-or-more digit) line-end) x))))

  (let* ((case-fold-search t)
	 (filtype-rx (rx (or "jpg" "jpeg" "png" "heic") eol))
	 (tmp-filar (directory-files-recursively mappe1 filtype-rx nil t))
	 (filar (mapcar (lambda (x) `(,x . nil)) tmp-filar))
	 (n (length filar))
	 (pos 0)
	 (antal-valde 0)
	 (avløysarpar (list (cons (rx "jpeg" eol) "jpg")
			    (cons (rx "JPEG" eol) "jpg")
			    (cons (rx "HEIC" eol) "heic")
			    (cons (rx "PNG" eol) "pngn"))))

    (catch 'avslutta
      (while t
	(catch 'start
	  (when (< pos 0)
	    (throw 'start (setf pos 0)))

	  (when (>= pos n)
	    (throw 'start (setf pos (1- n))))

	  (visa-fil (car (elt filar pos)))

	  (let ((svar (completing-read
		       (concat (format "Bilete %d/%d. Du heve hittil valde %d bilete." (1+ pos) n antal-valde)
			       "\n"
			       (få-hjelpetekst (cdr (elt filar pos)))
			       "\n\n"
			       "Behalda? (j/n)\n"
			       "Førre/Próximo? (f/p/Enter)\n"
			       "Gå til Starten/Enden (S/E)\n"
			       "Hoppa til eit tal (tal)\n"
			       "Avslutta (a): ")
		       nil nil #'fulføring)))

	    (cond ((string-equal svar "j") (setf antal-valde (oppdatera-antal (cdr (elt filar pos)) t antal-valde)
						 (cdr (elt filar pos)) t
						 pos (1+ pos)))
		  ((string-equal svar "n") (setf antal-valde (oppdatera-antal (cdr (elt filar pos)) nil antal-valde)
						 (cdr (elt filar pos)) nil
						 pos (1+ pos)))
		  ((string-equal svar "f") (setf pos (1- pos)))
		  ((or (string-equal svar "p") (string-empty-p svar))
		   (setf pos (1+ pos)))
		  ((string-equal svar "S") (setf pos 0))
		  ((string-equal svar "E") (setf pos (1- n)))
		  ((string-match-p (rx line-start (one-or-more digit) line-end) svar)
		   (setf pos (1- (string-to-number svar))))
		  ((string-equal svar "a") (throw 'avslutta t)))))))

    (dolist (fil filar)
      (when (cdr fil)
	(copy-file (car fil) (concat mappe2 (seq-reduce
					     #'mønstermåta
					     avløysarpar
					     (downcase (filnamn (car fil)))))
		   t t)))))

(defun framkalling-få-filtype (x)
  (when (string-match (rx bol
			  (zero-or-more any)
			  "/"
			  (one-or-more any)
			  "."
			  (group (one-or-more alnum))
			  eol)
		      x)
    (match-string 1 x)))

(defun framkalling-få-filtypane (dir)
  (delete-dups
   (cl-loop for fil being the elements of (directory-files-recursively dir "" nil t)
	    collect (framkalling-få-filtype fil))))

;; Skapa destinasjonsmappa.
;; HEIC-filar?
;; Bilete utan filtype?
