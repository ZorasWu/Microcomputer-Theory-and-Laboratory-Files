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
    CLR C           ; �w�] C = 0
    MOV  B, #39H
    MOV  R1, A      ; �ƥ� A
    MOV  A, B
    SUBB A, R1      ; �p�� 39H - A
    JC   notNumeral ; �p�G A > 39H�A�h���X�AC �O�� 0

    MOV  B, #30H
	MOV A,R1
    SUBB A, B      ; �p�� 30H - A
    JC   notNumeral ; �p�G A < 30H�A�h���X�AC �O�� 0

    SETB C          ; �p�G 30H <= A <= 39H�A�h�] C = 1
    RET

notNumeral:
    CLR C           ; �T�O C = 0�]���M�}�Y�w�M���A���O�I�^
    RET

