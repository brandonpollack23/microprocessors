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
		ldi XH, high(LCDPORT_COM)
		ldi XL, low(LCDPORT_COM)

		call LCD_BF_WAIT

		ldi R16, 0b00111000 // two lines, bigger font, 8 bits
		st X, R16

		call LCD_BF_WAIT

		ldi R16, 0b00001111 // display on cursor on curor blink
		st X, R16

		call LCD_BF_WAIT
		
		ldi R16, 0b00000001 // clear disp
		st X, R16

		call LCD_BF_WAIT
		
		ldi R16, 0b00000011 // cursor home
		st X, R16
  
  ldi ZH, high(NameLocation << 1)
  ldi ZL, low(NameLocation << 1)

  call OUT_STRING_LCD
  

  done:
	rjmp done;

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
		/*push R0
		clr R0
		ldi XH, high(LCDPORT_COM)
		ldi XL, low(LCDPORT_COM)

		notready:
		ld R0, X
		sbrc R0, 7
		rjmp notready
		pop R0
		ret*/
		push R16
push r17
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
CPI R17, 0x01
BRNE AGAIN
BREQ RETURN

CARRY:
INC R17
rjmp BACK

RETURN: 
	pop r17
	pop r16
	RET

  

