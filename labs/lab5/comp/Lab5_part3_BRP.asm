/*
 * Brandon Pollack
 * Ivan
 * 1524
 * A program that uses interrupts to manage UART
 */ 
 .include "Atxmega128A1udef.inc"
 .include "EBI_INITS.asm"

.org 0x0
rjmp main

.org USARTC0_RXC_vect
	rjmp RX_ISR

.org 0x100
main:
	.equ BSEL = 144
	.equ BSCL = -6

	ldi R16, 0x18				
	sts USARTC0_CTRLB, R16		;this buts a one in RXEN and TXEN, enabling transmission and receive

	ldi R16, 0x03
	sts USARTC0_CTRLC, R16		;No parity, 8 bit data, a single stop bit

	ldi R16, BSEL	
	sts USARTC0_BAUDCTRLA, R16	;setting baud to involves some calculation from the manual

	ldi R16, ((BSCL << 4) & 0xF0) | ((BSel >> 8) & 0x0F)							
	sts USARTC0_BAUDCTRLB, R16	;set the scale and last 4 bits of BSEL

	; now begins the set up of the PORTC to output and input serial

	ldi R16, 0x08
	sts PORTC_DIR, R16
	sts PORTC_OUT, R16 ; set the direction of the TX line as out and default as 1 as per docs

	//done with UART setup (except Interrupt drives, whcih I will do after I initilize PMIC)

	ldi R16, 0x01
	sts PMIC_CTRL, R16 //globally enable low level interrupts

	ldi R16, (0x01 << 4)
	sts USARTC0_CTRLA, R16 //set RXINTLVL to a low level interrupt

	sei //globally enable all interrupts

	TRIPORT_ALE_ONE_INIT
	CS0_INIT
	STACK_INIT
	ldi XL, low(IOPORT)
	ldi XH, high(IOPORT)
	ldi R16, 0xFF
	st X, R16

loopforever:
	ldi R16, 0xFF
	st X, R16
	call DELAY500
	ldi R16, 0x00
	st X, R16
	call DELAY500
	rjmp loopforever

RX_ISR:
	push R17
	push R16
	lds R16, USARTC0_DATA
	isdatasent:
		lds R17, USARTC0_STATUS
		sbrs R17, 5 ;poll DATA in status register, if it is clear we are not done
		rjmp isdatasent
	
	sts USARTC0_DATA, R16
	pop R16
	pop R17
	reti

DELAY500:
push R16
push R17

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
	pop R17
	pop R16
	RET

