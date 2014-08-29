/*Lab 2 Part 1
* Name:		Brandon Pollack
* Section #:	1524
* TA Name:	Ivan
* Description: Just reads port d and writes that to port e*/
.include "ATxmega128A1Udef.inc"

.ORG 0x0
	rjmp MAIN

MAIN: 
.ORG 0x100
	ldi R16, 0x00
	ldi R17, 0xff

	sts PORTD_DIR, R16
	sts PORTE_DIR, R17

LOOP:
	lds R16, PORTD_IN
	sts PORTE_OUT, R16
	rjmp LOOP



	

	lds R17, PORTD_IN



	

