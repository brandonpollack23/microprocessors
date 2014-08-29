/*
 *Brandon Pollack
 *Ivan
 *1352
 *UART Port C program to interface with a terminal
 */

.include "Atxmega128A1udef.inc"
.include "EBI_INITS.asm"

.equ CR = 0x0D
.equ LF = 0x0A
.equ stringlocation = 0x1000

.org stringlocation
	.DB "My name is Brandon Pollack, my favourite movie is Pulp Fiction, my favourite class is EEL4744, my favourite TV show is Star Trek.", CR, LF, "Instructor: Dr. Eric M. Schwartz, TA: IVAN", CR, LF, 0x00


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
	
	
	ldi ZL, low(stringlocation << 1)
	ldi ZH, high(stringlocation << 1) ;string location shifted by one

	call OUT_STRING

done: rjmp done



OUT_CHAR:
	.org 0x200
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