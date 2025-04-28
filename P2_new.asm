MAIN:
     CALL  coolDelay
     JMP  $
coolDelay:
     MOV   R0,#18
Check:
     cjne  R0,#0,decR0 
     JMP   goOut
decR0:
     DEC   R0  
     JMP   Check 
goOut:
	NOP
     RET  