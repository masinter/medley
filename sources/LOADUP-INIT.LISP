(* "make init files")

(CNDIR (MEDLEYDIR "tmp"))
(MOVD 'NILL 'PAGEFULLFN)
(LOAD (MEDLEYDIR "sources" "MAKEINITGREET.LCOM"))
(PROGN (DRIBBLE "makeinit.dribble")
       (BKSYSBUF " ")
       (MAKEINITGREET)
       (DRIBBLE)
       (LOGOUT T))