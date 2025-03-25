; This program sends the text abc down the
; 8051 serial port to the external UART at 4800 Baud.
; To generate this baud rate, timer 1 must overflow
; every 13 us with SMOD equal to 1 (this is as close as
; we can get to 4800 baud at a system clock frequency
; of 12 Mz).
; The data is sent with even parity,
; therefore for it to be received correctly
; the external UART must be set to Even Parity

ORG 0000H         ; Reset vector
    SJMP MAIN      ; Jump to main program

ORG 0023H         ; Serial interrupt vector
    LJMP SERIAL_ISR ; Jump to serial interrupt service routine

MAIN:
    CLR SM0        ; |
    SETB SM1       ; | Put serial port in 8-bit UART mode
    MOV A, PCON    ; |
    SETB ACC.7     ; |
    MOV PCON, A    ; | Set SMOD in PCON to double baud rate
    MOV TMOD, #20H ; Put timer 1 in 8-bit auto-reload interval timing mode
    MOV TH1, #243  ; Put -13 in timer 1 high byte (timer will overflow every 13 us)
    MOV TL1, #243  ; Put same value in low byte so when timer is first started it will overflow after 13 us
    SETB TR1       ; Start timer 1
    SETB ES        ; Enable serial interrupt
    SETB EA        ; Enable global interrupts

    MOV 30H, #'a'  ; |
    MOV 31H, #'b'  ; |
    MOV 32H, #'c'  ; | Put data to be sent in RAM, start address 30H
    MOV 33H, #0    ; Null-terminate the data (when the accumulator contains 0, no more data to be sent)
    MOV R0, #30H   ; Put data start address in R0

    MOV A, @R0     ; Load first character into A
    MOV C, P       ; Move parity bit to the carry
    MOV ACC.7, C   ; Move the carry to the accumulator MSB
    MOV SBUF, A    ; Start transmission of first character

IDLE:
    SJMP IDLE      ; Loop indefinitely, waiting for interrupts

SERIAL_ISR:
    CLR TI         ; Clear transmit interrupt flag
    INC R0         ; Move to next byte
    MOV A, @R0     ; Load next byte
    JZ DONE        ; If zero, end transmission
    MOV C, P       ; Move parity bit to the carry
    MOV ACC.7, C   ; Move the carry to the accumulator MSB
    MOV SBUF, A    ; Transmit next byte
    RETI           ; Return from interrupt

DONE:
    RETI           ; Return from interrupt when finished