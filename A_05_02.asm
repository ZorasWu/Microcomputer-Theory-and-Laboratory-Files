Initialization:
	mov	R1,#30H	; The starting address for storing the pressed key numbers
start:
	MOV R0, #0		; clear R0 - the first key is key0
	clr	F0
	; scan row0
	SETB P0.3		; set row3
	CLR P0.0		; clear row0
	CALL colScan	; call column-scan subroutine
	JB F0, finish	; | if F0 is set, jump to end of program 
				; | (because the pressed key was found and its number is in  R0)

	; scan row1
	SETB P0.0		; set row0
	CLR P0.1		; clear row1
	CALL colScan		; call column-scan subroutine
	JB F0, finish		; | if F0 is set, jump to end of program 
				; | (because the pressed key was found and its number is in  R0)

	; scan row2
	SETB P0.1		; set row1
	CLR P0.2		; clear row2
	CALL colScan		; call column-scan subroutine
	JB F0, finish		; | if F0 is set, jump to end of program 
				; | (because the pressed key was found and its number is in  R0)

	; scan row3
	SETB P0.2		; set row2
	CLR P0.3		; clear row3
	CALL colScan		; call column-scan subroutine
	JB F0, finish		; | if F0 is set, jump to end of program 
				; | (because the pressed key was found and its number is in  R0)


	JMP start		; | go back to scan row 0
				; | (this is why row3 is set at the start of the program
				; | - when the program jumps back to start, row3 has just been scanned)

finish:

    mov	@R1,AR0   		; Note: "MOV @R1,R0" is not allowed.
 					; Note: "MOV @R1,0H" is the same as "MOV @R1,AR0".
	JNB P0.4, finish
	JNB P0.5, finish
	JNB P0.6, finish
	inc	R1
	JMP  start
	
      ;Note: The "finish:" section in edSim51 Program 7 only contains the instruction "JMP  $".

; column-scan subroutine
colScan:
	JNB P0.4, gotKey	; if col0 is cleared - key found
	INC R0			; otherwise move to next key
	JNB P0.5, gotKey	; if col1 is cleared - key found
	INC R0			; otherwise move to next key
	JNB P0.6, gotKey	; if col2 is cleared - key found
	INC R0			; otherwise move to next key
	RET			; return from subroutine - key not found
gotKey:
	SETB F0			; key found - set F0
	RET			; and return from subroutine