/*Lab 2 Part 2
* Name:		Brandon Pollack
* Section #:	1524
* TA Name:	Ivan
* Description: mainfunction of part2*/ 

.include "ATxmega128A1Udef.inc"
.include "Delay500.asm"

.org 0x0
	rjmp MAIN

MAIN:
	.org 0x100
	
	ldi R16, 0xFF
	ldi R17, 0
	ldi R19, 1
	
	sts PORTD_DIR, R17
	sts PORTE_DIR, R16 //set the direction of the ports

	sts PORTE_OUT, R19

LOOP:
	lds R16, PORTD_IN
	MOV R17, R16
	ANDI R17, 0b00100000
	ANDI R18, 0b00100000
	CP R17, R18
	BREQ NORESET
	sts PORTE_OUT, R19
	CALL DELAY500  

NORESET:
	lds R16, PORTD_IN
	MOV R17, R16	
	ANDI R16, 0b00100000
	CPI R16, 0b00100000
	BREQ INCPORTE
	//will just continue to shift port e otherwise

 SHIFTPORTE:
 lds R16, PORTE_OUT
 clc
 ROL R16
 BRCC NOCARRY
 ROL R16

 NOCARRY:
 sts PORTE_OUT, R16

 rjmp SPEEDCHECK

 INCPORTE:
 lds R16, PORTE_OUT
 clc
 inc R16
 sts PORTE_OUT, R16
 
SPEEDCHECK:
	mov R18, R17
	ANDI R17, 0b00001000
	CPI R17, 0b00001000
	BRNE HALFSEC
	CALL DELAY500
HALFSEC:
	CALL DELAY500

	rjmp LOOP