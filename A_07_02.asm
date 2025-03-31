; Title: ICP-A07-02 = Transmit a numeral ASCII after receiving it from serial input (at 19200 bps)- template
; Note: When you run this program, set the system clock at 11.059 MHz and baud rate at 19200 bps.
; Note: In this template, the content of the ISR "serialPortISR" and the subroutine "numeralTest" ae empty.
;       You need to program these two parts.
; Note: When this program runs, serial tansmission and receiving can happen simulaneously.
;       Hence, the ISR "serialPortISR" needs to be able to handle the two serial interrupt flags TI and RI.

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
	JMP $   ; do nothing but waiting for interrupt

; ################################
; Please program the ISR "serialPortISR" below.
; --------------------------------
SERIAL_ISR:
    JNB RI, check_TI  ; �ˬd RI (Receive Interrupt)�A�p�G�S��ƴN���L

    MOV A, SBUF       ; Ū�������� ASCII �r��
    CALL numeralTest  ; �P�_�O�_���Ʀr (���G�s�b C)
    JNC ignore        ; �p�G C=0 (���O�Ʀr)�A�N����

    MOV SBUF, A       ; �p�G�O�Ʀr�A�N�Ǧ^�Ӧr��
    JNB TI, endISR   ; �T�O TI �M�� (�Y���ݭn)

check_TI:
    JNB TI, endISR   ; �p�G TI = 0�A��������
    CLR TI            ; �M�� TI �лx (�ǳƦn�o�e�s���)

endISR:
    RETI              ; ��^�D�{��

ignore:
    CLR RI            ; �M�� RI
    RETI


; ################################
; [ICP-A07-01
; Subroutine name: numeralTest
; Learning object: To learn the encoding of ASCII code
; Function: 
;      This subroutine tests whether the accumulator contains the ASCII code
;      of a numeral symbol (i.e., 0, 1, 2, ..., or 9). 
; Input: Acc = the code to be tested.
; Output: C = 1, if '0' <= Acc <= '9' and
;         C = 0, otherwise.
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
    MOV P1.0, C
	RET

notNumeral:
    CLR C           ; �T�O C = 0�]���M�}�Y�w�M���A���O�I�^
    RET