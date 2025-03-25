ORG 0000H
    LJMP start

ORG 0003H
    LJMP toggleF0_ISR

start:
    MOV A, #11111110B
    CLR F0

    SETB EX0
    SETB IT0
    SETB EA 

show:
    MOV P1, A
    JB  F0, right
    
left:
    RL A 
    SJMP show

right:
    RR A
    SJMP showIt

toggleF0_ISR:
    CPL F0
    RETI