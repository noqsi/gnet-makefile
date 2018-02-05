;;; gEDA - GPL Electronic Design Automation
;;; gnetlist back end for generating a Makefile from a drawing
;;; Copyright (C) 2015 John P. Doty
;;;
;;; This program is free software; you can redistribute it and/or modify
;;; it under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 2 of the License, or
;;; (at your option) any later version.
;;;
;;; This program is distributed in the hope that it will be useful,
;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with this program; if not, write to the Free Software
;;; Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

; Create a Makefile from a flow diagram

(define (makefile filename)
	
	(set-current-output-port
		(open-output-file filename)
	)
	
	(set! packages
		(sort! packages string<)
	)
	
	(for-each write-boilerplate 
		(get-packages "makefile-prolog")
	)
	
	(for-each write-command
		(get-packages "makefile-command")
	)
	
	(for-each write-rule 
		(get-packages "makefile-rule")
	)
	
	(for-each write-boilerplate 
		(get-packages "makefile-epilog")
	)
)


; yield a list of packages whose device attributes match device-attr

(define (get-packages device-attr)
	
	(filter 
		(lambda (refdes)
			(equal? 
				device-attr
				(gnetlist:get-package-attribute refdes "device")
			)
		)
		packages
	)
)


(define (write-boilerplate refdes)
	
	(format #t "~A\n" 
		(gnetlist:get-package-attribute refdes "value")
	)
)


(define (write-rule refdes)
	
	(format #t "# Rule ~A\n\n" refdes)
	(write-targets refdes)
	(write-prerequisites refdes)
	(write-recipe refdes)
)


(define (write-command refdes)
	
	(format #t "# Command ~A\n\n" refdes)
	(write-phony refdes)
	(write-prerequisites refdes)
	(write-recipe refdes)
)


(define (write-phony refdes)

	(let 	
		(
		(target (gnetlist:get-package-attribute refdes "value"))
		)
		
		(format #t ".PHONY : ~A\n" target)
		(format #t "~A" target)
	)
)


(define (write-targets refdes)
	(write-names "to-target" refdes "from-writer")
)


(define (write-prerequisites refdes)

	(format #t " : ")	
	(write-names "from-prerequisites" refdes "to-reader")
	(format #t "\n")
)


(define (write-recipe refdes)

	(let
		(
			(recipe (gnetlist:get-package-attribute refdes "recipe"))
		)
		
		(if (equal? recipe "unknown")
			(format #t "\n")
			(begin
				(format-recipe (to-lines recipe))
				(format #t "\n")
			)
		)
	)
)

; write-names writes the names associated with a particular flow.
; package should be a symbol that represents a rule.
; pintype attributes on the pins of the package and the pins it connects
; with control the flow direction.
; rule-pintype is the pintype on the rule package to select.
; file-pintype is the pintype on the connected pins to select.

(define (write-names rule-pintype refdes file-pintype)
	
	(for-each 
		(lambda (net) 
			(write-names-on-net net file-pintype)
		) 
		(map 
			(lambda (pin) 
				(car 
					(gnetlist:get-nets refdes pin)
				)
			) 
			(pins-with-type refdes rule-pintype)
		)
	)
)

(define (write-names-on-net net pintype)

	(for-each
		(lambda (name)
			(format #t "~A " name)
		)
		(names-on-net net pintype)
	)
)

(define (names-on-net net pintype)

	(sort
		(apply append 
			(map 
				get-files
				(packages-with-pintype net pintype)
			)
		)
		string<
	)
)


(define (packages-with-pintype net pintype)

	(map car
		(pins-on-net-with-type net pintype)
	)
)


(define (get-files refdes)
 
	(delq #f
		(append
			(gnetlist:get-all-package-attributes refdes "source")
			(gnetlist:get-all-package-attributes refdes "file")
		)
	)
)

; Find all pins with the given type attached to a net

(define (pins-on-net-with-type net pintype)
	
	(filter
		(lambda (refdes-pin)
			(equal?  
				pintype
				(gnetlist:get-attribute-by-pinnumber 
					(car refdes-pin)	; refdes
					(cadr refdes-pin)	; pin
					"pintype"
				)
			)
		)
		(gnetlist:get-all-connections net)
	)
)

	
(define (pins-with-type refdes type)
	
	(filter 
		(lambda (p) 
			(equal? 
				type 
				(gnetlist:get-attribute-by-pinnumber refdes p "pintype")
			)
		)
		(gnetlist:get-pins refdes)
	)
)

; Parse a multiline attribute into a list of lines.
; Leaves out the newline characters. No terminating newline required.

(define (to-lines s)
	
	(let
		(
			(n (string-index s #\nl))	; find the first newline.
		)
		
		(if n 	; then we have a newline in s, so more than one line
			; take the first line as car of our list
			; recurse to get cdr
			(cons 
				(string-take s n) 
				(to-lines 
					(string-drop s 
						(+ n 1)		; drop the newline, too
					)
				)
			)
			; else s has no newline and is thus the last line
			(list s)
		)
	)
)

; format a makefile recipe

(define (format-recipe r)

	(for-each
		(lambda (line)
			(format #t "\t~A\n"	; recipe lines have tabs in front
				line
			)
		)
		r
	)
)
