start:
	setb P3.3;8
	setb P3.4
	mov P1, #10000000B

	mov P1, #11111111B

	clr P3.3;9
	mov P1, #10010000B

	mov P1, #11111111B

	clr P3.4;a
	setb P3.3
	mov P1, #10001000B

	mov P1, #11111111B

	clr P3.3;b
	mov P1, #10000011B

	mov P1, #11111111B
	;c
	mov P1, #11000110B

	mov P1, #11111111B

	setb P3.3;d
	mov P1, #10100001B

	mov P1, #11111111B

	clr P3.3;e
	setb P3.4
	mov P1, #10000110B

	mov P1, #11111111B

	setb P3.3;f
	mov P1, #10001110B

	mov P1, #11111111B

	jmp start
	

	