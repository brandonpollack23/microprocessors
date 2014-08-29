/*
 * Brandon Pollack
 * Ivan
 * 1524
 * A program that uses an input on a port as an interupt
 */ 
 .include "Atxmega128A1udef.inc"
 .include "EBI_INITS.asm"
.org 0
	rjmp main

.org PORTC_INT0_VECT
	rjmp EXT_INT_countup

main:
.org 0x100
	ldi R16, 0x01
	sts PORTC_INTCTRL, R16 ;set this port as a low level interrupt

	ldi R16, 0x04
	sts PORTC_INT0MASK, R16 ;set pin 2 as the interrupt, since it is the only one with full asynch support
	sts PORTC_DIRCLR, R16 ;make certain that pin is an input

	ldi R16, 0x02
	sts PORTC_PIN2CTRL, R16 ;set pin 2 to trigger an interrupt on only a falling edge

	ldi R16, 0x01
	sts PMIC_CTRL, R16 ;turn on low level interrupts

	sei ;turn on interrupts

	TRIPORT_ALE_ONE_INIT ;turn on EBI so I can write to my LEDs
	CS0_INIT ;not really needed but I think my CPLD uses it now so lets turn it on
	ldi R16, 0x0 ;set the init value of our count to 0
	sts IOPORT, R16

loopforever:
	rjmp loopforever

EXT_INT_countup:
    cli
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop

	ldi R17, 0x00
	sts PORTC_INTFLAGS, R17
	inc R16
	sts IOPORT, R16 ;simply increments R16 and writes it out to the IO ports

	ldi R17, 0x00
	sts PORTC_INTFLAGS, R17
	sei
	reti



