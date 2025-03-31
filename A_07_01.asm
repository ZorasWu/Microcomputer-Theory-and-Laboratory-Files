; [ICP-A07-01-template]
Main:
; The purpose of the main program is to test the subroutine numeralTest.
; Observe the status of LED3~LED0 while running this program.
; If the subroutine is correct, you will see [on off on off] pattern on LED [3 2 1 0].
; That is, [P1.3 P1.2 P1.1 P1.0] = [ 0 1 0 1].
;
; Test '0'
	MOV	A,#'0'
	CALL 	numeralTest	; Output: C = 1
	MOV	P1.0,C  ; Turn off LED0
; Test 'h'
	MOV	A,#'h'
	CALL 	numeralTest	; Output: C = 0
	MOV	P1.1,C  ; Turn on LED1
; Test '8'
	MOV	A,#'8'
	CALL 	numeralTest	; Output: C = 1
	MOV	P1.2,C  ; Turn off LED2
; Test '&'
	MOV	A,#'&'
	CALL 	numeralTest	; Output: C = 0
	MOV	P1.3,C  ; Turn on LED3
	JMP	$



; [ICP-A07-01
; Subroutine name: numeralTest
; Learning object: To learn the encoding of ASCII code
; Function: 
;      This subroutine tests whether the accumulator contains the ASCII code
;      of a numeral letter (i.e., 0, 1, 2, ..., or 9). 
; Input: Acc = the code to be tested.
; Output: C = 1, if '0' =< Acc =< '9' and
;         C = 0, otherwise.
; Note: '0' = 30H, '1' = 31H, ..., '9' = 39H      
;                      
numeralTest:
    CLR C           ; 預設 C = 0
    MOV  B, #39H
    MOV  R1, A      ; 備份 A
    MOV  A, B
    SUBB A, R1      ; 計算 39H - A
    JC   notNumeral ; 如果 A > 39H，則跳出，C 保持 0

    MOV  B, #30H
	MOV A,R1
    SUBB A, B      ; 計算 30H - A
    JC   notNumeral ; 如果 A < 30H，則跳出，C 保持 0

    SETB C          ; 如果 30H <= A <= 39H，則設 C = 1
    RET

notNumeral:
    CLR C           ; 確保 C = 0（雖然開頭已清除，但保險）
    RET

