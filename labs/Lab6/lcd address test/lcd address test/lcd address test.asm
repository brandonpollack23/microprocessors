/*
 * lcd_address_test.asm
 *
 *  Created: 3/25/2013 4:12:50 PM
 *   Author: Brandon
 */ 

 /*
 * Lab6.asm
 *
 *  Created: 3/21/2013 6:52:29 PM
 *   Author: Brandon
 */ 
  .include "Atxmega128A1udef.inc"
  .include "EBI_INITS.asm"

  .equ NameLocation = 0x1000

  .org 0x0
  rjmp main

  .org NameLocation
	.db "Brandon Pollack", 0


.org 0x100
  main:
  

  STACK_INIT
  TRIPORT_ALE_ONE_INIT
  CS0_INIT
  CS1_INIT
  CS2_INIT

  jumphere:
		ldi R16, 0x01
		ldi XH, high(LCDPORT_COM)
		ldi XL, low(LCDPORT_COM)

		st X, R16

		ldi XH, high(LCDPORT_DAT)
		ldi XL, low(LCDPORT_DAT)
		ldi R16, 'b'

		st X, R16

		rjmp jumphere
		
  OUT_CHAR_LCD: //outs R16 to LCD
		call LCD_BF_WAIT
		ldi XH, high(LCDPORT_DAT)
		ldi XL, low(LCDPORT_DAT)
		st X, R16
		ret

  OUT_STRING_LCD: //put address of string in Z register
		push R16
		
		stringloop:
			lpm R16, Z+

			cpi R16, 0
			breq string_done

			call OUT_CHAR_LCD
			rjmp stringloop

		string_done:
			pop R16
			ret

  LCD_BF_WAIT:
		push R0
		clr R0
		ldi XH, high(LCDPORT_COM)
		ldi XL, low(LCDPORT_COM)

		notready:
		ld R0, X
		sbrc R0, 7
		rjmp notready
		pop R0
		ret

  


