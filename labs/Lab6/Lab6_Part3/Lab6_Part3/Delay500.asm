

/*Lab 2 Part 2
* Name:		Brandon Pollack
* Section #:	1524
* TA Name:	Ivan
* Description: This is a subroutine that delays by 500 milliseconds*/

DELAY500:

push R16
push r17
ldi R16, 0
ldi R17, 0

AGAIN:
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
INC R16
CPI R16, 0
BREQ CARRY

BACK:
CPI R17, 0xFF
BRNE AGAIN
BREQ RETURN

CARRY:
INC R17
rjmp BACK

RETURN: 
	pop r17
	pop r16
	RET