	mov R1,#01111111B
start:
	mov P1,R1
	mov A,R1
	RR A
	mov R1,A
	jmp start
