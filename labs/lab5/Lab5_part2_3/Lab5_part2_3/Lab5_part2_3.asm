/*
 * Lab5_part2_3.asm
 *
 *  Created: 3/3/2013 3:41:22 PM
 *   Author: Brandon
 *Brandon Pollack
 *Ivan
 *1352
 *UART Port C program to interface with a terminal, now taking input
 */

.include "Atxmega128A1udef.inc"
.include "EBI_INITS.asm"

.equ CR = 0x0D
.equ LF = 0x0A
.equ menulocation = 0x1000
.equ TAB = 0x09
.equ CC = 0x12

.org menulocation
	.db "Brandon's Favourite:",CR,LF,"0:", TAB,"Sport",CR,LF,"1:",TAB,"TV Show",CR,LF,"2:",TAB,"Book",CR,LF,"3:",TAB,"Food",CR,LF,"4:",TAB,"Movie",CR,LF,"5:",TAB,"Display menu",CR,LF,"ESC: exit",CR,LF,0x00

fsport:
	.db "Baseball",CR,LF,0
fTV:
	.db "Star Trek",CR,LF,0
fBook:
	.db "Ender's Game",CR,LF,0
fFood:
	.db "Tonkotsu Ramen",CR,LF,0
fMovie:
	.db "Pulp Fiction",CR,LF,0
exitprint:
	.db "Done!",0



.org 0x0
	rjmp main

main:
.org 0x100

	STACK_INIT

	.equ BSEL = 144
	.equ BSCL = -6

	ldi R16, 0x18				
	sts USARTC0_CTRLB, R16		;this buts a one in RXEN and TXEN, enabling transmission and receive

	ldi R16, 0x03
	sts USARTC0_CTRLC, R16		;No parity, 8 bit data, a single stop bit

	ldi R16, BSEL	
	sts USARTC0_BAUDCTRLA, R16	;setting baud to 9600 HZ involves some calculation from the manual

	ldi R16, ((BSCL << 4) & 0xF0) | ((BSel >> 8) & 0x0F)							
	sts USARTC0_BAUDCTRLB, R16	;set the scale to -2 as per the formula to get 9600 HZ from the Fper and BSCL, upper 4 bits of BSEL stay the same

	; now begins the set up of the PORTC to output and input serial

	ldi R16, 0x08
	sts PORTC_DIR, R16
	sts PORTC_OUT, R16 ; set the direction of the TX line as out and default as 1 as per docs
	
	
	

loop:
	ldi ZL, low(menulocation << 1)
	ldi ZH, high(menulocation << 1) ;string location shifted by one
	call OUT_STRING
recievenewchar:
	call IN_CHAR

	cpi R16, 0x1B
	breq exitroutine
	cpi R16, '0'
	breq sport
	cpi R16, '1'
	breq TVshow
	cpi R16, '2'
	breq book
	cpi R16, '3'
	breq food
	cpi R16, '4'
	breq movie
	cpi R16, '5'
	breq loop
	rjmp recievenewchar
	
exitroutine:
	ldi ZL, low(exitprint << 1)
	ldi ZH, high(exitprint << 1)
	call OUT_STRING
done:
	rjmp done

sport:
	ldi R16, CC
	call OUT_CHAR
	ldi ZL, low(fsport << 1)
	ldi ZH, high(fsport << 1)
	call OUT_STRING
	rjmp loop
TVshow:
	ldi R16, CC
	call OUT_CHAR
	ldi ZL, low(fTV << 1)
	ldi ZH, high(fTV << 1)
	call OUT_STRING
	rjmp loop
book:
	ldi R16, CC
	call OUT_CHAR
	ldi ZL, low(fbook << 1)
	ldi ZH, high(fbook << 1)
	call OUT_STRING
	rjmp loop
food:
	ldi R16, CC
	call OUT_CHAR
	ldi ZL, low(fFood << 1)
	ldi ZH, high(fFood << 1)
	call OUT_STRING
	rjmp loop
movie:
	ldi R16, CC
	call OUT_CHAR
	ldi ZL, low(fmovie << 1)
	ldi ZH, high(fmovie << 1)
	call OUT_STRING
	rjmp loop

IN_CHAR:
	push R17

	isdatarecieved:
		lds R17, USARTC0_STATUS
		sbrs R17, 7
		rjmp isdatarecieved

	lds R16, USARTC0_DATA

	pop R17
	ret

OUT_CHAR:
	push R17 ;save this value

	isdatasent:
		lds R17, USARTC0_STATUS
		sbrs R17, 5 ;poll TXIF in status register, if it is clear we are not done
		rjmp isdatasent
	
	sts USARTC0_DATA, R16

	pop R17

	ret

OUT_STRING:
	push R16 ;I chose to use z so this sub works for program or data memory (remember to shift left if program memory)

	beginwritingstring:
		lpm R16, Z+ ;at the end of this sub, z will point to one address past the end of the string
		cpi R16, 0x0
		breq donewritingstring
		call OUT_CHAR
		rjmp beginwritingstring

	donewritingstring:
		pop R16
		ret
 


