MAIN:
    MOV DPTR, #competitors ; DPTR points to competitors
    CLR A                  ; Clear A
    MOVC A, @A+DPTR         ; Load the first number into A
    MOV B, A                ; Assume first number is the max
    MOV R0, #15             ; 15 more numbers to check

NEXT_NUMBER:
    INC DPTR                ; Move to next competitor
    CLR A
    MOVC A, @A+DPTR         ; Load next number into A

    ; Compare signed A with B

    ; Save current A and B
    PUSH ACC                ; Save A
    MOV A, B                ; Load B into A
    PUSH ACC                ; Save B

    ; Check signs
    POP ACC                 ; Restore B
    JNB ACC.7, B_POSITIVE   ; If B positive (bit 7 = 0), jump
    ; B is negative
    POP ACC                 ; Restore A
    JNB ACC.7, A_POSITIVE   ; If A positive, A > B
    ; Both negative
    ; Compare normally
    CJNE A, B, CHECK_CY
    SJMP DONE_COMPARE

A_POSITIVE:
    ; A positive, B negative ¡÷ A > B
    MOV B, A
    SJMP DONE_COMPARE

B_POSITIVE:
    POP ACC                 ; Restore A
    JB ACC.7, B_LARGER      ; If A negative, B > A

    ; Both positive
    CJNE A, B, CHECK_CY
    SJMP DONE_COMPARE

CHECK_CY:
    JC B_LARGER             ; If Carry set, B > A
    ; Else A > B
    MOV B, A

DONE_COMPARE:
    DJNZ R0, NEXT_NUMBER    ; Decrement R0, loop if not 0
    MOV P1, #1H
    ; Done

JMP $                      ; Halt here

B_LARGER:
    ; Do nothing, keep current B
    SJMP DONE_COMPARE

JMP  $

competitors:
DB 27H,0A7H,9AH,64H,3BH,71H,89H,0C5H
DB 4BH,5BH,82H,0DEH,9DH,7AH,6FH,0FEH