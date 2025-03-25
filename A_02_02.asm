	mov R1, #01111111B
	mov R2, #11111110B
start:
	mov A, R1
	anl A, R2
	mov P1,A
	mov A, R1
	RR A
	mov R1,A
	mov A, R2
	RL A
	mov R2,A
	jmp start
