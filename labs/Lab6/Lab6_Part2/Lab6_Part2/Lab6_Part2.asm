/*
 * Lab6_Part2.asm
 *
 *  Created: 3/24/2013 4:40:51 PM
 *   Author: Brandon
 */ 

.include "Atxmega128A1udef.inc"
.include "EBI_INITS.asm"

.equ LUT = 0x1000

.org 0x0
	rjmp main

.org LUT
.db "0.00	0.04	0.08	0.12	0.16	0.20	0.24	0.28	0.31	0.35	0.39	0.43	0.47	0.51	0.55	0.59	0.63	0.67	0.71	0.75	0.79	0.83	0.87	0.91	0.94	0.98	1.02	1.06	1.10	1.14	1.18	1.22	1.26	1.30	1.34	1.38	1.42	1.46	1.50	1.54	1.57	1.61	1.65	1.69	1.73	1.77	1.81	1.85	1.89	1.93	1.97	2.01	2.05	2.09	2.13	2.17	2.20	2.24	2.28	2.32	2.36	2.40	2.44	2.48	2.52	2.56	2.60	2.64	2.68	2.72	2.76	2.80	2.83	2.87	2.91	2.95	2.99	3.03	3.07	3.11	3.15	3.19	3.23	3.27	3.31	3.35	3.39	3.43	3.46	3.50	3.54	3.58	3.62	3.66	3.70	3.74	3.78	3.82	3.86	3.90	3.94	3.98	4.02	4.06	4.09	4.13	4.17	4.21	4.25	4.29	4.33	4.37	4.41	4.45	4.49	4.53	4.57	4.61	4.65	4.69	4.72	4.76	4.80	4.84	4.88	4.92	4.96	5.00"

.org 0x100
main:


STACK_INIT
TRIPORT_ALE_ONE_INIT
CS0_INIT
CS1_INIT
CS2_INIT

ADC_8bit_INIT
ADC_CH0_INIT

LCD_INIT

ldi R17, 5 //this is the size of each text from the table
loopforever:
	ldi ZL, low(LUT<<1)
	ldi ZH, high(LUT<<1)
	
	lds R16, ADCA_CH0_RES
	mov R20, R16 //R20 will be used to change hex to ASCII

	MUL R16, R17

	mov ZL, R0
	ADD ZH, R1
	
	lpm R16, Z+
	call OUT_CHAR_LCD
	lpm R16, Z+
	call OUT_CHAR_LCD
	lpm R16, Z+
	call OUT_CHAR_LCD
	lpm R16, Z+
	call OUT_CHAR_LCD //calls the X.XX value

	ldi R16, 'V'
	call OUT_CHAR_LCD

	ldi R16, ' '
	call OUT_CHAR_LCD // puts the space between this and hex

	ldi R16, '('
	call OUT_CHAR_LCD //parenthases around hex

	ldi R16, '0'
	call OUT_CHAR_LCD

	ldi R16, 'x'
	call OUT_CHAR_LCD

	call OUT_HEX

	ldi R16, ')'
	call OUT_CHAR_LCD

	ldi XL, low(LCDPORT_COM)
	ldi XH, high(LCDPORT_COM)

	call LCD_BF_WAIT

	ldi R16, 0x02
	st X, R16

	rjmp loopforever

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

	OUT_HEX:
	mov R21, R20
	cbr R21, 0b00001111
	lsr R21
	lsr R21
	lsr R21
	lsr R21

	cpi R21, 10
	brsh Letter

	ldi R22, 0x30
	ADD R21, R22
	mov R16, R21
	call OUT_CHAR_LCD

	continue:
	cbr R20, 0b11110000
	cpi R20, 10
	brsh Letter20

	ldi R22, 0x30
	ADD R20, R22
	mov R16, R20
	call OUT_CHAR_LCD
	ret

	Letter:
	ldi R22, 0x37
	ADD R21, R22
	mov R16, R21
	call OUT_CHAR_LCD
	rjmp continue

	Letter20:
	ldi R22, 0x37
	ADD R20, R22
	mov R16, R20
	call OUT_CHAR_LCD
	ret

	




