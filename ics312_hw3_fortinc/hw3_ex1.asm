;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Caliana Fortin
; ICS 312
; Professor Henri Casanova

; Homework 3 - Exercise 1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; For exercise 1, we are to ask the user for a character and
; then for an integer. The program subtracts the ASCII code 
; of the character from the integer, and prints the opposite
; of the result as part of the message.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

%include "asm_io.inc"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Initialized data is put into the data segment.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
segment .data
	entry1		db    "Enter a character: ",0 ;Dont forget the null terminator
	entry2          db    "Enter an integer: ",0
	output1		db    "The transformed number is: ",0

	quotes 		db    "'", 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Uninitialized data is put into the bss segment
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
segment .bss
	charInput 		resd 1
	integerInput 	        resd 1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Code is put into the text segment
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
segment .text
	global asm_main

asm_main:
	enter	0,0		;setup routine
	pusha

	;
	; entry 1
	;
    	mov eax, entry1		;print out the first entry
	call print_string
	call read_char
	mov [charInput],eax ;stores the char from the user to eax

	;
	; entry 2
	;
	mov eax, entry2		;print out the second entry
	call print_string
	call read_int           ;read integer
	mov  [integerInput],eax ;stores the integer from the user to eax

	;
	; Subtraction of charInput and intergerInput
	;
	mov eax,[charInput]     ;eax = dword at charInput
	sub eax,[integerInput]  ;eax -= dword at interInput
	mov ebx, eax	;result = eax


	;
	; result messages
	;
	mov eax, output1
	call print_string      ;prints out the the message
	mov eax, quotes
	call print_string      ;print the quotes
	mov eax, ebx
	call print_int         ;print out sum (ebx)
        mov eax, quotes
        call print_string      ;print the quotes
	call print_nl	       ;print out new line



	popa
	mov	eax, 0
	leave
	ret

