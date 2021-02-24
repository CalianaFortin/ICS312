;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Caliana Fortin
; ICS 312
; Professor Henri Casanova
; Homework 3 - Exercise 2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; For exercise 2, we are to ask the user for a 3-character 
; string of lowercase letters s1, and then for a 4 
; character string s2. The program then prints, as part of a 
; message, the following “encoded” string: s2[3] S1[0] S1[0]
; s2[2] S1[1] S1[1] s2[1] S1[2] S1[2] s2[0] 
; (where “S1[i]” means the upper-case version of “s1[i]”).
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

%include "asm_io.inc"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Initialized data is put into the data segment.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

segment		.data
	entry1	db	"Enter a 3-character string: ", 0
	entry2	db	"Enter a 4-character string: ", 0
	output1	db	"The output is ", 0

	null 	db	0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Uninitialized data is put into the bss segment
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

segment		.bss
	s1			resd	1 ;string1 is a 3-character string lowercase
	s2 			resd	1 ;string2 is a 4 character string
	result		resd	1 ;result is where the output is stored

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Code is put into the text segment
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

segment		.text
	global asm_main

asm_main:
	enter 	0,0 ;setup routine
	pusha

	;
	; entry 1 for s1 3-character lowercase
	;
	mov		eax, entry1
	call	print_string

	call 	read_char
	sub		al, 20h ; convert to uppercase Reference: https://programmersheaven.com/discussion/413781/x86-nasm-lowercase-to-uppercase
	mov		[s1], eax ;stores the first char from the user to eax

	; stores the second char from the string input into ebx, increases 
	; the ebx by 1 and moves the character after first character 
	call	read_char ; call read char
	sub 	al, 20h ; convert to uppercase
	mov		ebx, s1
	add 	ebx, 1
	mov 	[ebx], eax

	; stores the 3rd char from string input to ebx, increases the
	; address by 1 and moves the character after second character
	call 	read_char
	sub 	al, 20h ;convert to uppercase
	add 	ebx, 1
	mov 	[ebx], eax

	; reads the space return as next charater and places after 
	; second character
	call	read_char
	add 	ebx, 1
	mov 	[ebx], eax

	; take into account of null termination
	add 	ebx, 1
	mov 	eax, [null]
	mov 	[ebx], eax

	;
	; entry 2 4-character string
	;

	mov		eax, entry2
	call	print_string

	
	call 	read_char ; read char
	mov		[s2], eax ; stores first char from string input to eax

	; stores second char from string input to ebx, increases the
	; address by 1 and moves the character after first character
	call	read_char
	mov		ebx, s2
	add 	ebx, 1
	mov 	[ebx], eax

	; stores the 3rd char from string input to ebx, increases the
	; address by 1 and moves the character after second character
	call 	read_char
	add 	ebx, 1
	mov 	[ebx], eax

	; stores the 4th char from string input to ebx, increases the
	; address by 1 and moves the character after third character
	call 	read_char
	add 	ebx, 1
	mov 	[ebx], eax

	; reads the space return as next charater and places after 
	; third character
	call	read_char
	add 	ebx, 1
	mov 	[ebx], eax

	; take into account of null termination
	add 	ebx, 1
	mov 	eax, [null]
	mov 	[ebx], eax

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;					MOVING THE CHARACTERS 					;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	; Move the 4th character from s2 into result
	mov 	ebx, s2 		 ; s2
	add 	ebx, 3 			 ; add 3 to target 4th character
	mov 	eax, [ebx] 
	mov 	[result], eax 	 ; place into result

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;S1;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	; Move the 1st character from s1 into result
	mov 	eax, [s1] 		; look at 1st char
	mov 	ebx, result 	; place the 1st char into result
	add 	ebx, 1 			
	mov 	[ebx], eax 		; place after first char in result

	; Duplicate 1st letter from s1 into result
	add 	ebx, 1 			
	mov 	[ebx], eax 		; place after first char in result
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;S2;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	; Move the 3rd character from s2 into result
	mov 	ecx, s2 		; s2
	add 	ecx, 2 			; add 2 to target 3rd char
	mov 	eax, [ecx]
	add 	ebx, 1
	mov 	[ebx], eax 		; place after previous char in result
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;S1;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	; Move the 2nd character from s1 into result
	mov 	ecx, s1 		; s1
	add 	ecx, 1			; add 1 to target 2nd char
	mov 	eax, [ecx]
	add 	ebx, 1
	mov 	[ebx], eax 		; place after previous char in result

	; Duplicate 2nd letter from s1 into result
	mov 	ecx, s1 		; s1
	add 	ecx, 1 			; add 1 to target 2nd char
	mov 	eax, [ecx]
	add 	ebx, 1
	mov 	[ebx], eax 		; place after previous char in result
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;S2;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	; Move the 2nd character from s2 into result
	mov 	ecx, s2 		; s2
	add 	ecx, 1 			; add 1 to target 2nd char
	mov 	eax, [ecx]
	add 	ebx, 1
	mov 	[ebx], eax 		; place after previous char in result
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;S1;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	; Move the 3rd character from s1 into result
	mov 	ecx, s1 		; s1
	add 	ecx, 2 			; add 2 to target 3rd char
	mov 	eax, [ecx]
	add 	ebx, 1
	mov 	[ebx], eax 		; place after previous char in result
	
	; Duplicate 3rd letter from s1 into result
	mov 	ecx, s1 		; s1
	add 	ecx, 2 			; add 2 to target 3rd char
	mov 	eax, [ecx]
	add 	ebx, 1
	mov 	[ebx], eax 		; place after previous char in result
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;S2;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	; Move the 1st character from s2 into result
	mov 	ecx, s2 		; s2
	add 	ecx, 0 			; add 0 to target 1st char
	mov 	eax, [ecx]
	add 	ebx, 1
	mov 	[ebx], eax 		; place after previous char in result
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	;
	; null termination
	;
	add 	ebx, 1
	mov 	eax, [null]
	mov 	[ebx], eax

	
	mov 	eax, output1
	call 	print_string ; prints out the the message
	mov 	eax, result
	call 	print_string ;prints out the the result
	call 	print_nl

	; cleanup
	popa				
	mov		eax, 0			
	leave				
	ret					

