/* Brandon Pollack
*  HW4
*  SCI Subroutines
*/


.macro SCI_C_INIT

	.equ BSEL = 51
	.equ BSCL = -2

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
.endmacro
/*SPI_C_INIT:
	.macro
	.equ BSEL = 51
	.equ BSCL = -2

	
	ldi R16, 0x18				
	sts USARTC0_CTRLB, R16		;this buts a one in RXEN and TXEN, enabling transmission and receive

	ldi R16, 0b01000011
	sts USARTC0_CTRLC, R16		;No parity, 8 bit data, a single stop bit, synchronous transmission

	ldi R16, BSEL	
	sts USARTC0_BAUDCTRLA, R16	;setting baud to 9600 HZ involves some calculation from the manual

	ldi R16, ((BSCL << 4) & 0xF0) | ((BSel >> 8) & 0x0F)							
	sts USARTC0_BAUDCTRLB, R16	;set the scale to -2 as per the formula to get 9600 HZ from the Fper and BSCL, upper 4 bits of BSEL stay the same

	; now begins the set up of the PORTC to output and input serial

	ldi R16, 0x08
	sts PORTC_DIR, R16
	sts PORTC_OUT, R16 ; set the direction of the TX line as out and default as 1 as per docs
	.endmacro
	*/

OUT_CHAR:
	.org 0x200
	push R17 ;save this value

	isdatasent:
		lds R17, USARTC0_STATUS
		sbrs R17, 6 ;poll TXIF in status register, if it is clear we are not done
		rjmp isdatasent
	
	sts USARTC0_DATA, R16

	pop R17

	ret

OUT_STRING:
	push R16 ;I chose to use z so this sub works for program or data memory (remember to shift left if program memory)

	beginwritingstring:
		ld R16, Z+ ;at the end of this sub, z will point to one address past the end of the string
		breq donewritingstring
		call OUT_CHAR
		rjmp beginwritingstring

	donewritingstring:
		pop R16
		ret

IN_CHAR:
	push R17

	isdatarecieved:
		lds R17, USARTC0_STATUS
		sbrs R17, 7
		rjmp isdatarecieved

	lds R16, USARTC0_DATA

	pop R17
	ret

IN_STRING:  ;be sure to have X point where you want this data to go
	push R16

	beginreadingstring:
		call IN_CHAR ;puts the character in R16
		cpi R16, 0
		breq donereadingstring 
		st X+, R16
		rjmp beginreadingstring

	donereadingstring:
	pop R16
	ret

	
	
	