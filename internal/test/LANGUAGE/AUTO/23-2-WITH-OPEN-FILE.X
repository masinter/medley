;; Function To Be Tested: WITH-OPEN-FILE
;;
;; Source:        Steele's book    
;;                Section 23.2	        
;;                Page: 422
;;
;; Created By:    Henry Cate III
;;
;; Creation Date: November 21,1986
;;
;; Last Update:    
;;
;; Filed As:      {ERIS}<LISPCORE>CML>TEST>23-2-WITH-OPEN-FILE.TEST
;;
;;
;; Syntax:        (WITH-OPEN-FILE (stream filename {options}*)
;;						{declaration}* {form}*)
;;
;;
;;
;; Function Description:
;;     opens a file while within the control of the body
;; 
;; 
;; 
;; Argument(s):   stream - to a file
;;			   filename - pointer to a file
;;
;; Returns:       not clear, the last form inside?
;;


(do-test "need to load the functions file"
(unless (fboundp '23check-parse-list)   (load "{eris}<lispcore>cml>test>23-functions.def"))
  T)	


(do-test "try a simple case"
  (let* ((temp-pathname (23BUILD-PATHNAME "DSK" nil "lispfiles"))
	    (result (with-open-file (temp-stream temp-pathname :direction :io)
			(probe-file temp-stream))))
	(delete-file temp-pathname)
	result))


(do-test-group "test do same type of test on several different HOSTS"
	:before (PROGN

(test-defun 23With-Open-Basic (host)
  (let* ((temp-pathname (23BUILD-PATHNAME host))
	    (result (with-open-file (temp-stream temp-pathname :direction :io)
			(probe-file temp-stream))))
	(delete-file temp-pathname)
	(pathnamep result)))

(test-defun 23With-Open-More-Test (host)
  (let* ((probe-result nil) (temp-stream nil) 
	    (length-result nil) (with-open-result nil)
	    (temp-name (string (gensym)))
	    (temp-pathname (23BUILD-PATHNAME host nil "CMLTEST" temp-name))
	    (expect (concatenate 'string "{" host "}<CMLTEST>" temp-name ".;1")))
	(setq with-open-result
	  (with-open-file (temp-stream temp-pathname :direction :io)
		(setq probe-result (probe-file temp-stream))
		(setq length-result (file-length temp-stream))
		"HI"))
	(and 
	  (string-equal expect (namestring probe-result))
	  (eq nil temp-stream)
	  (eq 0 length-result)
	  (equal "HI" with-open-result)
	  (delete-file temp-pathname)
	)))

(test-defun 23DRIVE-With-Open (host)
	"run a set of tests across several hosts"
  (and
	(23With-Open-Basic host)
	(23With-Open-More-Test host)
  ))

)	; End of defining functions for this test group.

(do-test "test with lots of variations in {core}"
  (23DRIVE-With-Open "core"))

(do-test "test with lots of variations in {erinyes}"
  (23DRIVE-With-Open "erinyes"))

)	; end of do-test-group





STOP
