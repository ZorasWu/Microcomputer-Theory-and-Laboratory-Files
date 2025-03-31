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
;MOV SBUF, #'A'  ; 發送 'A'
	JMP $   ; do nothing but waiting for interrupt

; ################################

SERIAL_ISR:
    JNB RI, check_TI  ; 如果 RI = 0，則跳過
    
    MOV R0, SBUF       ; **讀取收到的資料**
    CLR RI            ; **清除 RI 讓它能繼續接收**
    CALL numeralTest  ; **判斷是否為數字**
    JNC ignore        ; 如果 C = 0，忽略

    MOV SBUF, R0       ; **回傳數字**
    SETB TI           ; **手動設置 TI**

ignore:
    RETI              ; 返回主程式

check_TI:
    JNB TI, end_ISR   ; 如果 TI = 0，則結束 ISR
    CLR TI            ; **清除 TI**
    
end_ISR:
    RETI              ; 結束中斷

; ################################

numeralTest:
	;ljmp notNumeral
    CLR C           ; 預設 C = 0
	MOV A, #39H
	MOV B, R0
	SUBB A,B    ;   (39H-R0)>=0 ? 0 : 1
    JC   notNumeral ; 如果 A > 3AH，則跳出，C 保持 0

	MOV A, R0
	MOV B, #30H
	SUBB A,B   ;  (R0-30H)>=0 ? 0 : 1
    JC   notNumeral ; 如果 A < 30H，則跳出，C 保持 0

    SETB C          ; 如果 30H <= A <= 39H，則設 C = 1
	RET

notNumeral:
    CLR C           ; 確保 C = 0（雖然開頭已清除，但保險）
    RET
