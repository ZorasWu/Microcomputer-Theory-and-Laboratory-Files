; Program name: ICP-A08-01 = motor direction control with simplified instruction sequence

; Description: This ICP performs the same function as Example 10 does.

;                      However, in the subroutine "setDirection", a tedious instruction sequence is simplified.

; Function of "setDirection" subroutine:

;                    This subroutine test whether P2.0 == F0.

;                    If P2.0 =\= F0, change F0 to P2.0 and change the motor rotation direction.

; Summary:

;

;          Direction   SW0     P2.0    F0    P3.1   P3.0

;          ------------   -----      -----    ---    ------   -----

;          CW            Open     1         1       0        1

;          CCW         Close     0         0       1        0

;

;

; Note: These PURPLE instructions can be simplified to about 4  GREEN instructions.

 

 

 

 

 

 

 

 

 

 

 

 

 

 

                                                                                            ; Timer 1 will be used to count the number of rotations.

                  MOV         TMOD, #50H                                ; Put timer 1 in event counting mode.

                  SETB         TR1                                                ; Start timer 1.

 

                                                                                            ; LEDcodes is the label of the 7-segment code table.

                  MOV         DPL, #LOW(LEDcodes)               ; Put the low byte of LEDcodes into DPL.

                  MOV         DPH, #HIGH(LEDcodes)              ; Put the high byte of LEDcodes into DPH.

 

                  CLR          P3.4                                                ; |

                  CLR          P3.3                                                ; | Enable Display 0 (of the 7-segment display).

again:

                  CALL        setDirection                                   ; Set the motor's direction.

                  MOV         A, TL1                         ; Move timer 1 low byte to A.

                  CJNE         A, #10, skip                 ; If the number of revolutions is not 10, skip next instruction.

                  CALL        clearTimer                   ; If the number of revolutions is 10, reset timer 1.

skip:

                  MOVC      A, @A+DPTR             ; Get 7-segment code from code table:

                                                                         ; The index into the table is decided by the value in Acc.

                                                                         ; (Example: The data pointer points to the start of the table

                                                                         ;  - if the motor is in the second revolutions, Acc should contain two,

                                                                         ;    and the second code in the table will be copied to Acc.)

                  MOV         C, F0                            ; Move the current motor direction value to the carry and from there to ACC.7 .

                  MOV         ACC.7, C                     ; (This will ensure Display 0's decimal point will indicate the motor's direction.).

                  MOV         P1, A                            ; | Move the 7-seg code for the number of revolutions and

; | motor direction indicator to Display 0.

                  JMP           again                            ; Do it all again.

 

 

; ==== Subroutine: setDirection ===============================================

setDirection:


;------------- The deleted instruction sequence is replaced with the instruction sequence BELOW ---------------
JB  F0, HI
LJMP J

	HI:
JNB P2.0, D
LJMP finish

	j:
JB P2.0, D
LJMP finish 
;------------- The deleted instruction sequence is replaced with the instruction sequence ABOVE ---------------


notChangeDir:

                  JMP finish                                     ; If they are the same, motor's direction does not need to be chang
D:                                                      

                  CLR P3.0                                       ; |

                  CLR P3.1                                       ; | Stop motor.

 

                  CALL clearTimer                         ; Reset timer 1 (revolution count restarts when motor direction changes).

                  MOV C, P2.0                                 ; Move SW0 value to carry,

                  MOV F0, C                                    ; and then to F0 - this is the new motor direction.

                  MOV P3.0, C                                 ; Move SW0 value (in carry) to motor control bit 1.

                  CPL C                                            ; Invert the carry,

                  MOV P3.1, C                                 ; | and move it to motor control bit 0 (it will therefore have the opposite

                                                                         ; | value to control bit 1 and the motor will start

                                                                         ; | again in the new direction).

finish:

;delete   POP 20H                                                         ; get original value for location 20H from the stack

;delete   POP ACC                                                        ; get original value for A from the stack

              RET                                                  ; Return from subroutine

 

; ========= Subroutine: clearTimer ===================================================

clearTimer:

                  CLR A                                           ; Reset revolution count in A to zero.

                  CLR TR1                                       ; Stop timer 1.

                  MOV TL1, #0                                ; Reset timer 1 low byte to zero.

                  SETB TR1                                     ; Start timer 1.

                  RET                                               ; Return from subroutine.

 

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>  The 7-segment COde Table <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

LEDcodes: ; | This label points to the start address of the 7-segment code table which is

                  ; | stored in program memory using the DB command below.

                  DB 11000000B, 11111001B, 10100100B, 10110000B, 10011001B, 10010010B, 10000010B, 11111000B, 10000000B, 10010000B