;; Function To Be Tested: PATHNAME-TYPE
;;
;; Source:        Steele's book    
;;                Section 23.1.2	PATHNAME Functions        
;;                Page: 417
;;
;; Created By:    Henry Cate III
;;
;; Creation Date: November 5,1986
;;
;; Last Update:    
;;
;; Filed As:      {ERIS}<LISPCORE>CML>TEST>23-1-2-PATHNAME-TYPE.TEST
;;
;;
;; Syntax:        (PATHNAME-TYPE pathname)
;;
;;
;;
;; Function Description:
;;     returns the type of the fil as a string or symbol
;; 
;; 
;; 
;; Argument(s):   pathname - pointing to a file 
;;
;; Returns:       the type of the file 
;;


(do-test "load functions for chapter 23 tests"
(unless (fboundp '23check-parse-list)   (load "{eris}<lispcore>cml>test>23-functions.def"))
  T)			; get here and functions were defined


(do-test "test a simple case"
	:before (progn (setq simple-list (23BUILD-LIST-OF-FILENAME-PATHNAMES 
			"dsk" 3 nil "lispfiles>tempdir" nil "hello")))
	:after (progn (23Delete-file-list simple-list))
	(23TEST-PATHNAME-VALUE-list simple-list 'type "HELLO"))

(do-test-group "test do same type of test on several different HOSTS"
	:before (PROGN

; this function is just for this test case.
(test-defun 23BUILD-TYPE-LIST (host type result-type)
    (append 
	(23file-generator result-type host 2 nil "cmltest" nil type)
	(23file-generator result-type host 2 nil "cmltest>sub" nil type)
    ))

;Do each type
(test-defun 23BUILD-TYPE-LIST-ALL (host type)
  (append
	(23BUILD-TYPE-LIST host type 'PATHNAME)
	(23BUILD-TYPE-LIST host type 'STREAM)
	(23BUILD-TYPE-LIST host type 'STRING)
	(23BUILD-TYPE-LIST host type 'SYMBOL)
  ))

(test-defun 23DRIVE-TYPE-LIST (host type-create type-match)
  (let* ((big-list (23BUILD-TYPE-LIST-ALL host type-create))
	    (result (23TEST-PATHNAME-VALUE-list big-list 'type type-match)))
	(23Delete-file-list big-list)
	result))

)	; End of defining functions for this test group.


(do-test "test lots of variations in {CORE}"
  (23DRIVE-TYPE-LIST "core" "hello" "HELLO"))

(do-test "test lots of variations in {erinyes}"
  (23DRIVE-TYPE-LIST "erinyes" "Nalpha-123" "NALPHA-123"))

)	; end of do-test-group
	

(do-test "test a few variations in {dsk}"
  (let* ((big-list (23file-generator 
			'STREAM "dsk" 2 nil "lispfiles>sub" nil "temptype12"))
	    (result (23TEST-PATHNAME-VALUE-list 
			big-list 'type "temptype12")))
	(23Delete-file-list big-list)
	result))

(do-test "test a few variations in {polux}"
  (let* ((big-list (23file-generator 'STREAM 
		"pollux:aisnorth:xerox" 2 nil "cmltest" nil "temptype12"))
	    (result (23TEST-PATHNAME-VALUE-list 
			big-list 'type "temptype12")))
	(23Delete-file-list big-list)
	result))



(do-test "test error conditions"
   (flet ((handle-expect-errors (value) 
		  (xcl-test:expect-errors (cl:error) 
			(PATHNAME-TYPE value))
		))
   (and
	(handle-expect-errors 54)
	(handle-expect-errors #\h)
	(handle-expect-errors (list 'hi 'bye))
	(handle-expect-errors (make-array '(2 3 4)))
	(handle-expect-errors (make-hash-table))
	(handle-expect-errors (copy-readtable))
	(handle-expect-errors (find-package 'Lisp))
;	(handle-expect-errors (make-random-state))
	(not (PATHNAME-TYPE "DF"))
	(not (PATHNAME-TYPE "OCT-6-65"))
	(not (PATHNAME-TYPE 'hello))
	(not (PATHNAME-TYPE 'bye))
	(not (PATHNAME-TYPE (make-broadcast-stream *terminal-io*)))
   )))



STOP
