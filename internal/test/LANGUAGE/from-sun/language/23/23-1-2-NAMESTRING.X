;; Function To Be Tested: NAMESTRING
;;
;; Source:        Steele's book    
;;                Section 23.1.2	PATHNAME Functions        
;;                Page: 417
;;
;; Created By:    Henry Cate III
;;
;; Creation Date: November 7,1986
;;
;; Last Update:    
;;
;; Filed As:      {ERIS}<LISPCORE>CML>TEST>23-1-2-NAMESTRING.TEST
;;
;;
;; Syntax:        (NAMESTRING pathname)
;;
;;
;;
;; Function Description:
;;     returns the full name of the file
;; 
;; 
;; 
;; Argument(s):   pathname - pointing to a file 
;;
;; Returns:       the full name of the file
;;


(do-test "load functions for chapter 23 tests"
(unless (fboundp '23check-parse-list)   (load "{eris}<lispcore>cml>test>23-functions.def"))
  T)			; get here and functions were defined


(do-test "test a simple case"
	:before (progn (setq temp-name (string (gensym)))
	  (setq simple-list (23BUILD-LIST-OF-FILENAME-PATHNAMES "core" 
			1 "tempdev" "tempdir" temp-name "type")))
	:after (progn (23Delete-file-list simple-list))
	(23TEST-NAMESTRING-VALUE-list simple-list 'name 
		(concatenate 'string "{CORE}TEMPDEV:<TEMPDIR>" temp-name ".TYPE")))

(do-test-group "test do same type of test on several different HOSTS"
	:before (PROGN

(test-defun 23DRIVE-NAMESTRING-LIST (host device dir name type expectvalue)
	"build the list and check get what want"
  (let* ((delete-list (23BUILD-LIST-OF-STREAM host 1 device dir name type))
	    (big-list (23Multiply-stream delete-list))
	    (result (23TEST-NAMESTRING-VALUE-list big-list 'name expectvalue)))
	(23Delete-file-list delete-list)
	result)) 

)	; End of defining functions for this test group.

(do-test "test lots of variations in {CORE}"
  (let ((temp-name (string (gensym))))
  (and
	(23DRIVE-NAMESTRING-LIST "core" nil "tdir" temp-name nil
		(concatenate 'string "{CORE}<tdir>" temp-name ".;1"))
	(23DRIVE-NAMESTRING-LIST  
		"core" "tdev12-23" "cmlfiletest>sub" temp-name "type"
		(concatenate 'string 
		  "{CORE}TDEV12-23:<CMLFILETEST>SUB>" temp-name ".TYPE;1"))
  )))

(do-test "test lots of variations in {dsk}"
  (let ((temp-name (string (gensym))))
    (23DRIVE-NAMESTRING-LIST  
		"dsk" nil "lispfiles>cmltest>sub" temp-name "type"
		(concatenate 'string 
		  "{DSK}<LISPFILES>CMLTEST>SUB>" temp-name ".TYPE;1"))
  ))

(do-test "test lots of variations in {ERINYES}"
  (let ((temp-name (string (gensym))))
    (23DRIVE-NAMESTRING-LIST  
		"erinyes" nil "cmltest>sub" temp-name "type"
		(concatenate 'string 
		  "{ERINYES}<CMLTEST>SUB>" temp-name ".TYPE;1"))
  ))

(do-test "test lots of variations in {POLLUX:AISNORTH:XEROX}"
  (let ((temp-name (string (gensym))))
    (23DRIVE-NAMESTRING-LIST  
		"pollux:aisnorth:xerox" nil "cmltest>sub" temp-name "type"
		(concatenate 'string 
		  "{POLLUX:AISNORTH:XEROX}<CMLTEST>SUB>" temp-name ".TYPE;1"))
  ))




)	; end of do-test-group
	

(do-test "test error conditions"
   (flet ((handle-expect-errors (value) 
		  (xcl-test:expect-errors (cl:error) 
			(namestring value))
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
   )))



STOP
