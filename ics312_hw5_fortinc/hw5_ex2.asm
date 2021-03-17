;;;;;;;;;;;;;;;;;;;;;;;;;;this is yours;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Caliana Fortin
; ICS 312
; Professor Henri Casanova
; Homework 5 - Exercise 1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; For Exercise 1 we are to write an assembly program called 
; hw5_ex1, stored in file hw5_ex1.asm, which prompts the user 
; for a string. The program then prints the count for each of 
; the 26 letters of the alphabet, not distinguishing between 
; upper case and lower case, and ignoring all non-letter 
; characters.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

%include "asm_io.inc"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Initialized data is put into the data segment.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
segment .data	
	entry1		db    "Enter a string written in some language: ", 0 ;Dont forget the null terminator
	entry2		db    "THIS Q2 ", 0 ;Dont forget the null terminator
	entry3		db    "NOSWAP ", 0 ;Dont forget the null terminator
	entry4		db    "SWAP ", 0 ;Dont forget the null terminator

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Uninitialized data is put into the bss segment
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
segment .bss

	occurrenceCount resd 26 ;This is a counter array holding the count of each letter
	sortedChars 	resd 26	;This is the sorted letters array
	temp 			resd 1	;this is the counter

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Code is put into the text segment
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
segment .text
	global asm_main

asm_main:
	enter	0,0
	pusha

	
	; Print out entry 1
    mov eax, entry1		;print out the first entry
	call print_string

	
	; this is done to ensure that registers are 0
	mov 	eax, 0
	mov 	ebx, 0
	mov 	ecx, 0
	mov 	edx, 0
	
L1:
	; read the first char and determine what it is
	call 	read_char

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; COMPARISON 1																		;
	; - we must check to see if the char being read is a new line character 			;
	; - To do this compare the char to 00Ah which is '\n' in hex 						;
	; - if it is a new line exit L1 													;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	cmp al, 00Ah 	;We must check to see if the char is equal to 
					;the new line character.
	je exitL1 		;IF eax == newLine go to exitL1

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; COMPARISON 2																		;
	; - we must check to see if the char being read is a lowercase letter 				;
	; - To do this compare the char to 96 which is 'a' in decimal form					;
	; - IF it is less than 96 then we need to do a deeper compare, so go to 			;
	;	LowerCaseCompare																;
	; - IF it is greater than 96 then it is a lower case letter and we can increment	;
	; - Since the range of a - z is 97 - 122 then we have to check after 122 			;
	; - IF it is greater than 122 then we have to do compare further or go to the next  ;
	;	character 																		;
	; - IF it is less than or equal to 122 then we can increment 						;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	cmp 	al, 96		  ;We must check to see if the input is equal to 'a-z'
	jle		LowerCaseCompare
	jg     	LowerCaseINC

	cmp al, 122 
	jg 		LowerCaseCompare
	jle     LowerCaseINC



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; FUNCTION: LowerCaseCompare 														;
; - This function first jumps to L2													;
; - After going through L2 we increment eax to get to the next character 			;
; - we also tell the user that the character is unknown								;
; - then go back to the main loop L1 												;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
LowerCaseCompare:
	jmp L2 
	add al, 1
	jmp L1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; FUNCTION: L2				 														;
; - This function checks to see if the character is an upper case character 		;
; - The range of 'A- Z' is 65 - 90													;
; - We check that range by saying:													;
; 			* IF the character is <= 64 then its not an upperCase letter 			;
;			* ELSE go to UpperCaseINC									 			;
;			* IF > 90 then its not an upperCase letter 								;
;			* ELSE ELSE go to UpperCaseINC											;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
L2:
	cmp 	al, 64		  ;We must check to see if the input is equal to 'a-z'
	jle		UpperCaseCompare
	jge     UpperCaseINC

	cmp al, 90 
	jg 		UpperCaseCompare
	jle     UpperCaseINC

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; FUNCTION: UpperCaseCompare 														;
; - This function basically goes to the next char if not a uppercase letter 		;
; - it then goes back to main loop L1 												;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
UpperCaseCompare:
	add al, 1
	jmp L1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; FUNCTION: LowerCaseINC															;
; - This function increments														;
; - We go back to the main loop L1 													;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
LowerCaseINC:
	xor dx, dx ; clear dx register
	mov bx, 'a' ;set bx to a 
	div bx 
	xor ebx, ebx
	mov bx, dx
	mov dx, bx
	inc dword [occurrenceCount + ebx * 4] ;Multiply by 4 since dword is 4 bytes 
	jmp L1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; FUNCTION: UpperCaseINC															;
; - This function increments														;
; - We go back to the main loop L1 													;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
UpperCaseINC:
	xor dx, dx
	mov bx, 'A' ; move bx = A
	div bx ; divide dx with bx
	xor ebx, ebx
	mov bx, dx
	mov dx, bx
	inc dword [occurrenceCount + ebx * 4] ;Multiply by 4 since dword is 4 bytes
	jmp L1	

exitL1: 
	mov ecx, 000h
	jmp charFrequncyOutput

charFrequncyOutput:

	xor ecx, ecx


	mov eax, 'a' 
	call print_char 
	mov eax, ':' 
	call print_char 
	mov eax, [occurrenceCount + ecx * 4] ;Multiply by 4 since dword is 4 bytes
	call print_int
	mov eax, ' ' ; the hex encoding for space 
	call print_char

		inc ecx


	mov eax, 'b' 
	call print_char 
	mov eax, ':' 
	call print_char 
	mov eax, [occurrenceCount + ecx * 4] ;Multiply by 4 since dword is 4 bytes ;*
	call print_int ;*
	mov eax, ' ' ; the hex encoding for space 
	call print_char

		inc ecx


	mov eax, 'c' 
	call print_char 
	mov eax, ':' 
	call print_char 
	mov eax, [occurrenceCount + ecx * 4] ;Multiply by 4 since dword is 4 bytes
	call print_int
	mov eax, ' ' ; the hex encoding for space 
	call print_char

		inc ecx


	mov eax, 'd' 
	call print_char 
	mov eax, ':' 
	call print_char 
	mov eax, [occurrenceCount + ecx * 4] ;Multiply by 4 since dword is 4 bytes
	call print_int
	mov eax, ' ' ; the hex encoding for space 
	call print_char

		inc ecx


	mov eax, 'e' 
	call print_char 
	mov eax, ':' 
	call print_char 
	mov eax, [occurrenceCount + ecx * 4] ;Multiply by 4 since dword is 4 bytes
	call print_int
	mov eax, ' ' ; the hex encoding for space 
	call print_char

		inc ecx


	mov eax, 'f' 
	call print_char 
	mov eax, ':' 
	call print_char 
	mov eax, [occurrenceCount + ecx * 4] ;Multiply by 4 since dword is 4 bytes
	call print_int
	mov eax, ' ' ; the hex encoding for space 
	call print_char

		inc ecx


	mov eax, 'g' 
	call print_char 
	mov eax, ':' 
	call print_char 
	mov eax, [occurrenceCount + ecx * 4] ;Multiply by 4 since dword is 4 bytes
	call print_int
	mov eax, ' ' ; the hex encoding for space 
	call print_char

		inc ecx


	mov eax, 'h' 
	call print_char 
	mov eax, ':' 
	call print_char 
	mov eax, [occurrenceCount + ecx * 4] ;Multiply by 4 since dword is 4 bytes
	call print_int
	mov eax, ' ' ; the hex encoding for space 
	call print_char

		inc ecx


	mov eax, 'i' 
	call print_char 
	mov eax, ':' 
	call print_char 
	mov eax, [occurrenceCount + ecx * 4] ;Multiply by 4 since dword is 4 bytes
	call print_int
	mov eax, ' ' ; the hex encoding for space 
	call print_char

		inc ecx


	mov eax, 'j' 
	call print_char 
	mov eax, ':' 
	call print_char 
	mov eax, [occurrenceCount + ecx * 4] ;Multiply by 4 since dword is 4 bytes
	call print_int
	mov eax, ' ' ; the hex encoding for space 
	call print_char

		inc ecx


	mov eax, 'k' 
	call print_char 
	mov eax, ':' 
	call print_char 
	mov eax, [occurrenceCount + ecx * 4] ;Multiply by 4 since dword is 4 bytes
	call print_int
	mov eax, ' ' ; the hex encoding for space 
	call print_char

		inc ecx


	mov eax, 'l' 
	call print_char 
	mov eax, ':' 
	call print_char 
	mov eax, [occurrenceCount + ecx * 4] ;Multiply by 4 since dword is 4 bytes
	call print_int
	mov eax, ' ' ; the hex encoding for space 
	call print_char

		inc ecx


	mov eax, 'm' 
	call print_char 
	mov eax, ':' 
	call print_char 
	mov eax, [occurrenceCount + ecx * 4] ;Multiply by 4 since dword is 4 bytes
	call print_int
	mov eax, ' ' ; the hex encoding for space 
	call print_char

		inc ecx


	mov eax, 'n' 
	call print_char 
	mov eax, ':' 
	call print_char 
	mov eax, [occurrenceCount + ecx * 4] ;Multiply by 4 since dword is 4 bytes
	call print_int
	mov eax, ' ' ; the hex encoding for space 
	call print_char

		inc ecx


	mov eax, 'o' 
	call print_char 
	mov eax, ':' 
	call print_char 
	mov eax, [occurrenceCount + ecx * 4] ;Multiply by 4 since dword is 4 bytes
	call print_int
	mov eax, ' ' ; the hex encoding for space 
	call print_char

		inc ecx


	mov eax, 'p' 
	call print_char 
	mov eax, ':' 
	call print_char 
	mov eax, [occurrenceCount + ecx * 4] ;Multiply by 4 since dword is 4 bytes
	call print_int
	mov eax, ' ' ; the hex encoding for space 
	call print_char

		inc ecx


	mov eax, 'q' 
	call print_char 
	mov eax, ':' 
	call print_char 
	mov eax, [occurrenceCount + ecx * 4] ;Multiply by 4 since dword is 4 bytes
	call print_int
	mov eax, ' ' ; the hex encoding for space 
	call print_char

		inc ecx


	mov eax, 'r' 
	call print_char 
	mov eax, ':' 
	call print_char 
	mov eax, [occurrenceCount + ecx * 4] ;Multiply by 4 since dword is 4 bytes
	call print_int
	mov eax, ' ' ; the hex encoding for space 
	call print_char

		inc ecx


	mov eax, 's' 
	call print_char 
	mov eax, ':' 
	call print_char 
	mov eax, [occurrenceCount + ecx * 4] ;Multiply by 4 since dword is 4 bytes
	call print_int
	mov eax, ' ' ; the hex encoding for space 
	call print_char

		inc ecx


	mov eax, 't' 
	call print_char 
	mov eax, ':' 
	call print_char 
	mov eax, [occurrenceCount + ecx * 4] ;Multiply by 4 since dword is 4 bytes
	call print_int
	mov eax, ' ' ; the hex encoding for space 
	call print_char

		inc ecx


	mov eax, 'u' 
	call print_char 
	mov eax, ':' 
	call print_char 
	mov eax, [occurrenceCount + ecx * 4] ;Multiply by 4 since dword is 4 bytes
	call print_int
	mov eax, ' ' ; the hex encoding for space 
	call print_char

		inc ecx


	mov eax, 'v' 
	call print_char 
	mov eax, ':' 
	call print_char 
	mov eax, [occurrenceCount + ecx * 4] ;Multiply by 4 since dword is 4 bytes
	call print_int
	mov eax, ' ' ; the hex encoding for space 
	call print_char

		inc ecx


	mov eax, 'w' 
	call print_char 
	mov eax, ':' 
	call print_char 
	mov eax, [occurrenceCount + ecx * 4] ;Multiply by 4 since dword is 4 bytes
	call print_int
	mov eax, ' ' ; the hex encoding for space 
	call print_char

		inc ecx


	mov eax, 'x' 
	call print_char 
	mov eax, ':' 
	call print_char 
	mov eax, [occurrenceCount + ecx * 4] ;Multiply by 4 since dword is 4 bytes
	call print_int
	mov eax, ' ' ; the hex encoding for space 
	call print_char

	inc ecx


	mov eax, 'y' 
	call print_char 
	mov eax, ':' 
	call print_char 
	mov eax, [occurrenceCount + ecx * 4] ;Multiply by 4 since dword is 4 bytes
	call print_int
	mov eax, ' ' ; the hex encoding for space 
	call print_char

	inc ecx


	mov eax, 'z' 
	call print_char 
	mov eax, ':' 
	call print_char 
	mov eax, [occurrenceCount + ecx * 4] ;Multiply by 4 since dword is 4 bytes
	call print_int
	mov eax, ' ' ; the hex encoding for space 
	call print_char

	inc ecx

	call print_nl

	jmp question2


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; FUNCTION: question2																;
; - After finding the frequency of each letter we start exercise 2					;
; - in this case we are using ec as i so we need to set it to 0 					;
; - then we go to the function which initiliazes our 'j'							;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
question2:
	mov ecx, 000h ; point ecx to 0 where ecx is the i in the loop ECX is I
	call print_nl
	jmp second

;im going to use edx for j 
second: 
	mov edx,0 ;j = 0 set j to 0
	inc edx 
	jmp first


first:
    ; we keep incrementing j here 
    ; we need to d something with j first before jumping
    ; add eax, occurrenceCount[edx*4]
    ; cmp eax, [occurrenceCount + ecx * 4]

	mov   ah, [occurrenceCount+ ecx *4]  ; AH = arr_idx[i]
	mov eax, [occurrenceCount + ecx * 4]
	call print_int
	mov   al, [occurrenceCount+edx *4]  ; AL = arr_idx[j]
	mov eax, [occurrenceCount + edx * 4]
	call print_int

	cmp   ah, al       ; if (arr_idx[i] >= arr_idx[j]) then no swap
	jge noSwap

	jl  Swap
    jb first           	;goto first repeat loop 

    inc ecx ;ecx++
    cmp ecx,26         ;if(ecx < 26)

    ; this increments i 

noSwap:
    mov eax, entry3		;print out the first entry
	call print_string
	inc   edx        ; (increase j)
	cmp   edx, 25    ; (compare with bound)
	jbe   first  ; if below or equal, then go to

Swap:
	;mov   [occurrenceCount+ecx], al  ; else swap
	;mov   [occurrenceCount+edx], ah
	mov eax, entry4		;print out the first entry
	call print_string
	inc   edx        ; (increase j)
	cmp   edx, 25    ; (compare with bound)
	jbe first

endProg:
	popa
	mov	eax, 0
	leave
	ret



