/*
 * lab1.asm
 *
 *  Created: 1/19/2013 2:52:02 PM
 *   Author: BRANDON POLLACK
 */ 

	.include "ATxmega128A1Udef.inc"
	.EQU END=0
	.EQU FILTER=0x41

	.org 0xF000 >> 1

Table:		

	.DB 0x34, 0x7E, 7, 4, 0x67, 4, 0x20, 0x49, 0x53, 0x6f, 0x6f, 0x20, 0x64, 0x46, 0x55, 0x5f, 0x4e, 0x6a, 0x6f, 0x62, 0x21, END ;this is my table, at position E00

	
	
	.org 0x0

	rjmp MAIN	

	.DSEG	 ;Assembler directive to tell our processor that this memory location is where the data will be stored

	.org 0x2100 >> 1

answers:	

	.BYTE 30


	.CSEG		;go back to code
	.org 0x200 >> 1

MAIN: 
	ldi ZL,low(Table << 1)
	ldi ZH,high(Table << 1) ;loads z with tabble location
	ldi XL,low(answers << 1) ;loads x with solution location
	ldi XH,high(answers << 1)
	
loop:
	lpm  R16, Z+	;loads R0 with first table value
	
	cpi R16, FILTER ;compares the table value to the filter value
	brlt dontwrite  ;if the table value is less than 41, it skips the next instruction, if not it writes this to 0x2100
	ST X+, R16

dontwrite:			
	cpi R16,END		;compares to end value, if equal to it, program done, if not always jump back to loop
	breq done
	rjmp loop

done:
	rjmp done
	
																																			;BRANDON POLLACK
	