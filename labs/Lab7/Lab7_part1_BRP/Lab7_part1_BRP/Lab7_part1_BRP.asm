/*
 * Lab7_part1_BRP.asm
 *
 *  Created: 4/6/2013 4:38:47 PM
 *   Author: Brandon
 */ 


.include "Atxmega128a1udef.inc"

.org 0
rjmp main

.org 0x100
main:
	ldi R16, 0x01
	sts PORTF_DIRSET, R16 //make the pin an output

	ldi R16, 0b00010001 //make this FRQ mode turn on CCA
	sts TCF0_CTRLB, R16

	ldi ZL, low(TCF0_CCA)
	ldi ZH, high(TCF0_CCA) //load Z so we can write our compare value

	ldi R16, 0x38
	st Z+, R16

	ldi R16, 0x02
	st Z, R16 //set the compare A (also the period reg since we are in FRQ mode)

	ldi R16, 0x01
	sts TCF0_CTRLA, R16 //turn on the timer/counter and use 2e6 hz

	done: rjmp done //loop forever a frequency should play



