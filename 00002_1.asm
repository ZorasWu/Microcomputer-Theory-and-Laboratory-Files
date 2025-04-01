; Title: ICP-A07-02 = Transmit a numeral ASCII after receiving it from serial input (at 19200 bps)- template
; Note: When you run this program, set the system clock at 11.059 MHz and baud rate at 19200 bps.
; Note: In this template, the content of the ISR "serialPortISR" and the subroutine "numeralTest" ae empty.
;       You need to program these two parts.
; Note: When this program runs, serial tansmission and receiving can happen simulaneously.
;       Hence, the ISR "serialPortISR" needs to be able to handle the two serial interrupt flags TI and RI.


ORG 0
	JMP main 
ORG 0023H 			  ; serial port interrupt vector
	JMP serialPortISR ; jump to serial port ISR

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
serialPortISR:
    ; 優先處理 RI（接收中斷）
    JNB RI, check_TI      ; 如果 RI = 0，跳去檢查 TI

    CLR RI                ; 清除接收中斷旗標
    MOV A, SBUF
push Acc
    MOV R0, a      ; 將接收到的資料存入累加器 A
    clr acc.7
    ACALL numeralTest     ; 呼叫 numeralTest 判斷是否為 '0'~'9'
pop acc
    JNC check_TI          ; 如果不是數字，跳去檢查 TI

    ; 是數字，將該字元傳送回去

mov a,r0
    MOV SBUF, a           ; 寫入 SBUF 送出（TI 在硬體自動清除前會設定）

check_TI:
    JNB TI, exit_ISR      ; 如果 TI = 0，就跳去結束
    CLR TI                ; 清除傳送中斷旗標（手動清除）

exit_ISR:
    RETI                  ; 返回中斷



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
	clr C
	mov B, #30H
	subb A, B
	JC notnum
	mov B ,#0AH
	subb A, B
	JNC notnum
	RET
notnum:
	clr c
	RET
