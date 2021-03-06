;; Function To Be Tested: pathname
;;
;; Source:        CLtL p. 413 
;; Chapter 23: File System Interface Section 23-1-2: Pathname Functions
;;
;; Created By:    Herb Jellinek
;;
;; Creation Date:  8 August 86
;;
;; Last Update:    October 9, 1986
;;
;; Filed As:      {eris}<lispcore>cml>test>23-1-2-pathname.test
;;
;;
;; Syntax: pathname pathname               
;;
;; Function Description: converts pathname to a pathname.
;;
;; Argument(s):  pathname - a pathname, string, symbol or stream        	
;;
;; Returns: a pathname             
;;

 ;;
;;;; Watch out for implementation-dependent filenames below
 ;;

(do-test-group ("pathname-test" 
	:before
	(progn
		(test-setq	 termstream	(make-broadcast-stream *terminal-io*))
		(test-setq closed-stream
			(let ((s (open "{core}<some>directory>empty"
						:direction :output)))
				(close s)
				s))
		(test-setq bstream		(open "{core}<some>directory>empty"
								:if-does-not-exist :create))
		(test-setq cstream 		(make-broadcast-stream bstream))
		(test-setq	 dstream 		(open "{core}<aisbu.modem>junk"
								:direction :output))
		(test-setq	 open-streams
			(list termstream bstream cstream dstream))
		(test-setq	 all-streams
			(list termstream closed-stream bstream
				cstream dstream))
		(test-setq	 some-symbol	'five)
		(test-defun pathtest (object) (cl:pathnamep (cl:pathname object)))
		))
	:after
	(progn
		(cl:mapcar #'cl:close open-streams)
		(cl:mapcar #'cl:delete-file all-streams))

	(do-test pathname-test
;; Will the function accept all these files and streams?
		(and
			(cl:every #'(lambda (item) (streamp item)) all-streams)
;; Will it accept t and nil?
			(cl:every #'(lambda (x) x) (cl:mapcar #'pathtest '(t nil)))
;; Symbols?
			(pathtest (cl:gensym))
			(pathtest (cl:gentemp))
			(pathtest some-symbol)
;; Pathnames?
			(cl:every #'(lambda(x) x)
				  (cl:mapcar #'pathtest (cl:mapcar #'pathname all-streams)))
;; Strings?
			(pathtest "abc")
			(pathtest (cl:pathname (cl:make-array 10
								:element-type 'cl:string-char
								:initial-element #\newline)))
			(pathtest (cl:pathname (cl:make-array 4
								:element-type 'cl:string-char
								:initial-contents "path"
								:adjustable t :fill-pointer t))))))


STOP

