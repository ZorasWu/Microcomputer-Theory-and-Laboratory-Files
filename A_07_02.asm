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
    JNB RI, check_TI  ; 檢查 RI (Receive Interrupt)，如果沒資料就跳過

    MOV A, SBUF       ; 讀取接收的 ASCII 字元
    CALL numeralTest  ; 判斷是否為數字 (結果存在 C)
    JNC ignore        ; 如果 C=0 (不是數字)，就忽略

    MOV SBUF, A       ; 如果是數字，就傳回該字元
    JNB TI, endISR   ; 確保 TI 清除 (若有需要)

check_TI:
    JNB TI, endISR   ; 如果 TI = 0，直接結束
    CLR TI            ; 清除 TI 標誌 (準備好發送新資料)

endISR:
    RETI              ; 返回主程式

ignore:
    CLR RI            ; 清除 RI
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
    MOV P1.0, C
	RET

notNumeral:
    CLR C           ; 確保 C = 0（雖然開頭已清除，但保險）
    RET