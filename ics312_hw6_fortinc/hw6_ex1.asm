;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Caliana Fortin
; ICS 312
; Professor Henri Casanova
; Homework 6
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; For Exercise 1
;Each data item in the dataset is a record with 4 booleans:
;b1: true if the person is under 40, false otherwise;
;b2: true if the person has an Android phone, false if they have an 
;	 iPhone
;b3: true if the person prefers Netflix, false if they prefer 
;	 Hulu
;b4: true if the person prefers Star Wars, 
;	 false if they prefer Star Trek
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

%include "asm_io.inc"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Initialized data is put into the data segment.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
segment .data	
    msg1    db      "Enter an integer: ", 0 ;this is a message to the user 
    msg2    db      "Binary representation: ", 0
    msg3    db      "Semantic: ", 0
    msg4    db      "YNGR/IPHN/HULU/SWRS count: ", 0
    msg5    db      "*/ANDR/*/STRK count: ", 0
    codes   db      "YNGR", 0, "OLDR", 0, "ANDR", 0, "IPHN", 0, "NFLX", 0, "HULU", 0, "SWRS", 0, "STRK", 0
    four_spaces db  "    ",0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Uninitialized data is put into the bss segment
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
segment .bss

		input	resd  1     ; only 4 bytes! 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Code is put into the text segment
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
segment .text
	global asm_main

asm_main:
    enter   0,0
    pusha

    mov eax, msg1
	call print_string

    ;read user input
    call 	read_int

    ; clear ebx register
    xor 	ebx, ebx
    ; clear ecx register
    xor 	ecx, ecx
    
    ; user input number
    mov		ecx, eax

    ; counter is equal to 32
    mov 	bl, 32

    mov eax, msg2
	call print_string

loop:
	; left shift bits by 1
    shl 	ecx, 1
    ; don't print a 1 if there is no carry
    jnc 	print0
    ; print a 1 if there is a carry
    jc 		print1

print0:
	; print a 0
    mov 	eax, 0
    call 	print_int
    jmp 	exit

print1:
	; print a 1
    mov 	eax, 1
    call 	print_int

exit:

	;decrement counter for loop
    dec 	bl
    ; return to loop 
    jne 	loop

    call 	print_nl

	; cleanup
	popa				
	mov		eax, 0			
	leave				
	ret


