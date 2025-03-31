ORG 0
	JMP main 
ORG 0023H 			  ; serial port interrupt vector
	JMP SERIAL_ISR ; jump to serial port ISR

ORG 0030H ; main program entry point
main:
	MOV TMOD, #20H ; timer 1 in 8-bit auto-reload timer mode
	MOV TH1, #0FDH ; high byte value to generate baud rate of 9600
	mov A, PCON		; |
	setb ACC.7		; |
	mov PCON, A		; | set SMOD in PCON to double baud rate (19200)
	SETB TR1 ; start timer 1
	CLR SM0
	SETB SM1 ; puts serial port into mode 1
	SETB REN ; receiver enable - This bit must be set to enable data receiving.
	SETB ES ; enable serial port interrupts
	SETB EA ; global interrupt enable
;MOV SBUF, #'A'  ; �o�e 'A'
	JMP $   ; do nothing but waiting for interrupt

; ################################

SERIAL_ISR:
    JNB RI, check_TI  ; �p�G RI = 0�A�h���L
    
    MOV R0, SBUF       ; **Ū�����쪺���**
    CLR RI            ; **�M�� RI �������~�򱵦�**
    CALL numeralTest  ; **�P�_�O�_���Ʀr**
    JNC ignore        ; �p�G C = 0�A����

    MOV SBUF, R0       ; **�^�ǼƦr**
    SETB TI           ; **��ʳ]�m TI**

ignore:
    RETI              ; ��^�D�{��

check_TI:
    JNB TI, end_ISR   ; �p�G TI = 0�A�h���� ISR
    CLR TI            ; **�M�� TI**
    
end_ISR:
    RETI              ; �������_

; ################################

numeralTest:
	;ljmp notNumeral
    CLR C           ; �w�] C = 0
	MOV A, #39H
	MOV B, R0
	SUBB A,B    ;   (39H-R0)>=0 ? 0 : 1
    JC   notNumeral ; �p�G A > 3AH�A�h���X�AC �O�� 0

	MOV A, R0
	MOV B, #30H
	SUBB A,B   ;  (R0-30H)>=0 ? 0 : 1
    JC   notNumeral ; �p�G A < 30H�A�h���X�AC �O�� 0

    SETB C          ; �p�G 30H <= A <= 39H�A�h�] C = 1
	RET

notNumeral:
    CLR C           ; �T�O C = 0�]���M�}�Y�w�M���A���O�I�^
    RET
