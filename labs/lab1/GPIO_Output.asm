/*
 * GPIO_Output.asm
 *
 *  Created: 1/16/2013 6:12:40 PM
 *   Author: Colin Watson, Dr. Schwartz
 
 This program will show how to initialize a GPIO port on the Atmel 
 (Port Q for this example) and demonstrate various ways to write to 
 a GPIO port.
 *****/

;Definitions for all the registers in the processor. ALWAYS REQUIRED.
;View the contents of this file in the Processor "Solution Explorer" 
;   window under "Dependencies"
.include "ATxmega128A1Udef.inc"

.ORG 0x0000					;Code starts running from address 0x0000.
	rjmp MAIN				;Relative jump to start of program.

.ORG 0x0100					;Start program at 0x0100 so we don't overwrite 
							;  vectors that are at 0x0000-0x00FD 
MAIN:
	ldi R16, 0xF			;load a four bit value(PORTQ is only four bits)
	sts PORTQ_DIR, R16		;set all the GPIO's in the four bit PORTQ as outputs

	ldi R16, 0xA			;values we will use to change the state of 
							;  the PORTQ GPIO's
	ldi R17, 0xF

	;The following code shows different ways to write to the GPIO pins.
	;   Each has a different advantage.

	sts PORTQ_OUT, R16		;send the value in R16 to the PORTQ pins
	sts PORTQ_OUTSET, R17	;each R17 bit that is 1 will set corresponding PORTQ pin
	sts PORTQ_OUTCLR, R16	;each R16 bit that is 1 will clear corresponding PORTQ pin

LOOP:
	sts PORTQ_OUTTGL, R16			;toggle the state of all the pins in PORTQ	
	rjmp LOOP						;repeat forever!



