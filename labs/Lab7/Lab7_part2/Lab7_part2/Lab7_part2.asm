/*
 * Lab7_part2.asm
 *
 *  Created: 4/6/2013 5:51:08 PM
 *   Author: Brandon
 */ 

.include "Atxmega128a1udef.inc"
.include "EBI_INITS.asm"
.include "USART_FUNCTIONS.asm"

.org 0
rjmp main

.org USARTC0_RXC_vect
	jmp USARTC0_RXC_ISR
.org RTC_COMP_vect
	jmp RTC_COMP_ISR

.org 0x100
main:
	TRIPORT_ALE_ONE_INIT
	CS0_INIT
	CS1_INIT
	CS2_INIT
	LCD_INIT
	SCI_C_INIT //19200 baud
	ldi R16, 0x10
	sts USARTC0_CTRLA, R16
	STACK_INIT
	

	ldi R16, 0x01
	sts PORTF_DIRSET, R16 //make the pin an output

	ldi R16, 0b00010001 //make this FRQ mode turn on CCA
	sts TCF0_CTRLB, R16

	ldi R16, 0x01
	sts TCF0_CTRLA, R16 //turn on the timer/counter and use 2e6 hz

	ldi R16, (1<<2)
	sts RTC_INTCTRL, R16 //turn on the RTC interupt compare for 500 ms

	ldi ZH, high(RTC_COMP)
	ldi ZL, low(RTC_COMP)
	ldi R16, low(500)
	st Z+, R16
	ldi R16, high(500)
	st Z, R16
	ldi R16, 0xFF
	sts RTC_PER, R16
	sts RTC_PER+1, R16 // make the period FFFF
	ldi R16, 1 | 0b010 << 1
	sts CLK_RTCCTRL, R16

	ldi R16, 1
	sts PMIC_CTRL, R16
	sei
	clr R16

mainloop:
	cpi R16, '1'
	breq b5j
	cpi R16, '2'
	breq c6j
	cpi R16, '3'
	breq c6shj
	cpi R16, '4'
	breq d6j
	cpi R16, '5'
	breq d6shj
	cpi R16, '6'
	breq e6j
	cpi R16, '7'
	breq f6j
	cpi R16, '8'
	breq f6shj
	cpi R16, '9'
	breq g6j
	cpi R16, '0'
	breq G6shj
	cpi R16, 'A'
	breq A6j
	cpi R16, 'B'
	breq a6shj
	cpi R16, 'C'
	breq b6j
	cpi R16, 'D'
	breq c7j
	cpi R16, '*'
	breq ascendingscalej
	cpi R16, '#'
	breq descendingscalej
	rjmp mainloop
b5j:
	call b5
	rjmp mainloop
c6j:
	call c6
	rjmp mainloop
c6shj:
	call c6sh
	rjmp mainloop
d6j:
	call d6
	rjmp mainloop
d6shj:
	call d6sh
	rjmp mainloop
e6j:
	call e6
	rjmp mainloop
f6j:
	call f6
	rjmp mainloop
f6shj:
	call f6sh
	rjmp mainloop
g6j:
	call g6
	rjmp mainloop
G6shj:
	call g6sh
	rjmp mainloop
A6j:
	call A6
	rjmp mainloop
A6shj:
	call A6sh
	rjmp mainloop
B6j:
	call b6
	rjmp mainloop
C7j:
	call C7
	rjmp mainloop

ascendingscalej:
	call ascendingscale
	rjmp mainloop
descendingscalej:
	call descendingescale
	rjmp mainloop


	//check the R16 register for note value, when you have it play it through subroutines, and make scales call those as well
	//make each note subroutine reset and start RTC counting to 500, then when that ends, ISR it to stop, reset its value, and stop the note
	//by writing CCA to 0

// inside of all these, be sure to clear R16
//also be sure to reset the RTC count so the interrupt doesnt trigger early, and when it is done turn off RTC
//then make sure the RTC ISR sets the CCA to 0
b5:
	call CLEAR_LCD
	ldi R17, 1 // a simple flag used in scales, cleared when the RTC compare completes

	ldi ZL, low(b5string<<1)
	ldi ZH, high(b5string<<1) //load the location i am outpitting to lcd

	call OUT_STRING_LCD

	ldi ZH, high(TCF0_CCA)
	ldi ZL, low(TCF0_CCA)
	ldi R16, low(1012)
	st Z+, R16
	ldi R16, high(1012)
	st Z, R16 //this block sets the timer's period to make the freq
	ldi R16, 1
	sts TCF0_CTRLA, R16
	
	ldi ZH, high(RTC_CNT)
	ldi ZL, low(RTC_CNT)
	ldi R16, 0
	st Z+, R16
	st Z, R16
	ldi R16, 1
	sts RTC_CTRL, R16
	call checkifdone
	clr R16
	ret
C6:
	call CLEAR_LCD
	ldi R17, 1 // a simple flag used in scales, cleared when the RTC compare completes

	ldi ZL, low(c6string<<1)
	ldi ZH, high(c6string<<1) //load the location i am outpitting to lcd

	call OUT_STRING_LCD

	ldi ZH, high(TCF0_CCA)
	ldi ZL, low(TCF0_CCA)
	ldi R16, low(956)
	st Z+, R16
	ldi R16, high(956)
	st Z, R16 //this block sets the timer's period to make the freq
	ldi R16, 1
	sts TCF0_CTRLA, R16
	
	ldi ZH, high(RTC_CNT)
	ldi ZL, low(RTC_CNT)
	ldi R16, 0
	st Z+, R16
	st Z, R16
	ldi R16, 1
	sts RTC_CTRL, R16 //turn on the RTC
	call checkifdone
	clr R16
	ret
c6sh:
	call CLEAR_LCD
	ldi R17, 1 // a simple flag used in scales, cleared when the RTC compare completes

	ldi ZL, low(c6shstring<<1)
	ldi ZH, high(c6shstring<<1) //load the location i am outpitting to lcd

	call OUT_STRING_LCD

	ldi ZH, high(TCF0_CCA)
	ldi ZL, low(TCF0_CCA)
	ldi R16, low(902)
	st Z+, R16
	ldi R16, high(902)
	st Z, R16 //this block sets the timer's period to make the freq
	ldi R16, 1
	sts TCF0_CTRLA, R16
	
	ldi ZH, high(RTC_CNT)
	ldi ZL, low(RTC_CNT)
	ldi R16, 0
	st Z+, R16
	st Z, R16
	ldi R16, 1
	sts RTC_CTRL, R16
	call checkifdone
	clr R16
	ret
D6:
	call CLEAR_LCD
	ldi R17, 1 // a simple flag used in scales, cleared when the RTC compare completes

	ldi ZL, low(d6string<<1)
	ldi ZH, high(d6string<<1) //load the location i am outpitting to lcd

	call OUT_STRING_LCD

	ldi ZH, high(TCF0_CCA)
	ldi ZL, low(TCF0_CCA)
	ldi R16, low(851)
	st Z+, R16
	ldi R16, high(851)
	st Z, R16 //this block sets the timer's period to make the freq
	ldi R16, 1
	sts TCF0_CTRLA, R16
	
	ldi ZH, high(RTC_CNT)
	ldi ZL, low(RTC_CNT)
	ldi R16, 0
	st Z+, R16
	st Z, R16
	ldi R16, 1
	sts RTC_CTRL, R16
	call checkifdone
	clr R16
	ret
D6sh:
	call CLEAR_LCD
	ldi R17, 1 // a simple flag used in scales, cleared when the RTC compare completes

	ldi ZL, low(d6shstring<<1)
	ldi ZH, high(d6shstring<<1) //load the location i am outpitting to lcd

	call OUT_STRING_LCD

	ldi ZH, high(TCF0_CCA)
	ldi ZL, low(TCF0_CCA)
	ldi R16, low(804)
	st Z+, R16
	ldi R16, high(804)
	st Z, R16 //this block sets the timer's period to make the freq
	ldi R16, 1
	sts TCF0_CTRLA, R16
	
	ldi ZH, high(RTC_CNT)
	ldi ZL, low(RTC_CNT)
	ldi R16, 0
	st Z+, R16
	st Z, R16
	ldi R16, 1
	sts RTC_CTRL, R16
	call checkifdone
	clr R16
	ret
e6:
	call CLEAR_LCD
	ldi R17, 1 // a simple flag used in scales, cleared when the RTC compare completes

	ldi ZL, low(e6string<<1)
	ldi ZH, high(e6string<<1) //load the location i am outpitting to lcd

	call OUT_STRING_LCD

	ldi ZH, high(TCF0_CCA)
	ldi ZL, low(TCF0_CCA)
	ldi R16, low(758)
	st Z+, R16
	ldi R16, high(758)
	st Z, R16 //this block sets the timer's period to make the freq
	ldi R16, 1
	sts TCF0_CTRLA, R16
	
	ldi ZH, high(RTC_CNT)
	ldi ZL, low(RTC_CNT)
	ldi R16, 0
	st Z+, R16
	st Z, R16
	ldi R16, 1
	sts RTC_CTRL, R16
	call checkifdone
	clr R16
	ret
F6:
	call CLEAR_LCD
	ldi R17, 1 // a simple flag used in scales, cleared when the RTC compare completes

	ldi ZL, low(f6string<<1)
	ldi ZH, high(f6string<<1) //load the location i am outpitting to lcd

	call OUT_STRING_LCD

	ldi ZH, high(TCF0_CCA)
	ldi ZL, low(TCF0_CCA)
	ldi R16, low(716)
	st Z+, R16
	ldi R16, high(716)
	st Z, R16 //this block sets the timer's period to make the freq
	ldi R16, 1
	sts TCF0_CTRLA, R16

	ldi ZH, high(RTC_CNT)
	ldi ZL, low(RTC_CNT)
	ldi R16, 0
	st Z+, R16
	st Z, R16
	ldi R16, 1
	sts RTC_CTRL, R16
	call checkifdone
	clr R16
	ret
F6sh:
	call CLEAR_LCD
	ldi R17, 1 // a simple flag used in scales, cleared when the RTC compare completes

	ldi ZL, low(f6shstring<<1)
	ldi ZH, high(f6shstring<<1) //load the location i am outpitting to lcd

	call OUT_STRING_LCD

	ldi ZH, high(TCF0_CCA)
	ldi ZL, low(TCF0_CCA)
	ldi R16, low(676)
	st Z+, R16
	ldi R16, high(676)
	st Z, R16 //this block sets the timer's period to make the freq
	ldi R16, 1
	sts TCF0_CTRLA, R16
	
	ldi ZH, high(RTC_CNT)
	ldi ZL, low(RTC_CNT)
	ldi R16, 0
	st Z+, R16
	st Z, R16
	ldi R16, 1
	sts RTC_CTRL, R16
	call checkifdone
	clr R16
	ret
G6:
	call CLEAR_LCD
	ldi R17, 1 // a simple flag used in scales, cleared when the RTC compare completes

	ldi ZL, low(g6string<<1)
	ldi ZH, high(g6string<<1) //load the location i am outpitting to lcd

	call OUT_STRING_LCD

	ldi ZH, high(TCF0_CCA)
	ldi ZL, low(TCF0_CCA)
	ldi R16, low(638)
	st Z+, R16
	ldi R16, high(638)
	st Z, R16 //this block sets the timer's period to make the freq
	ldi R16, 1
	sts TCF0_CTRLA, R16
	
	ldi ZH, high(RTC_CNT)
	ldi ZL, low(RTC_CNT)
	ldi R16, 0
	st Z+, R16
	st Z, R16
	ldi R16, 1
	sts RTC_CTRL, R16
	call checkifdone
	clr R16
	ret
G6sh:
	call CLEAR_LCD
	ldi R17, 1 // a simple flag used in scales, cleared when the RTC compare completes

	ldi ZL, low(g6shstring<<1)
	ldi ZH, high(g6shstring<<1) //load the location i am outpitting to lcd

	call OUT_STRING_LCD

	ldi ZH, high(TCF0_CCA)
	ldi ZL, low(TCF0_CCA)
	ldi R16, low(602)
	st Z+, R16
	ldi R16, high(602)
	st Z, R16 //this block sets the timer's period to make the freq
	ldi R16, 1
	sts TCF0_CTRLA, R16
	
	ldi ZH, high(RTC_CNT)
	ldi ZL, low(RTC_CNT)
	ldi R16, 0
	st Z+, R16
	st Z, R16
	ldi R16, 1
	sts RTC_CTRL, R16
	call checkifdone
	clr R16
	ret
A6:
	call CLEAR_LCD
	ldi R17, 1 // a simple flag used in scales, cleared when the RTC compare completes

	ldi ZL, low(a6string<<1)
	ldi ZH, high(a6string<<1) //load the location i am outpitting to lcd

	call OUT_STRING_LCD

	ldi ZH, high(TCF0_CCA)
	ldi ZL, low(TCF0_CCA)
	ldi R16, low(568)
	st Z+, R16
	ldi R16, high(568)
	st Z, R16 //this block sets the timer's period to make the freq
	ldi R16, 1
	sts TCF0_CTRLA, R16
	
	ldi ZH, high(RTC_CNT)
	ldi ZL, low(RTC_CNT)
	ldi R16, 0
	st Z+, R16
	st Z, R16
	ldi R16, 1
	sts RTC_CTRL, R16
	call checkifdone
	clr R16
	ret
A6sh:
	call CLEAR_LCD
	ldi R17, 1 // a simple flag used in scales, cleared when the RTC compare completes

	ldi ZL, low(a6shstring<<1)
	ldi ZH, high(a6shstring<<1) //load the location i am outpitting to lcd

	call OUT_STRING_LCD

	ldi ZH, high(TCF0_CCA)
	ldi ZL, low(TCF0_CCA)
	ldi R16, low(536)
	st Z+, R16
	ldi R16, high(536)
	st Z, R16 //this block sets the timer's period to make the freq
	ldi R16, 1
	sts TCF0_CTRLA, R16
	
	ldi ZH, high(RTC_CNT)
	ldi ZL, low(RTC_CNT)
	ldi R16, 0
	st Z+, R16
	st Z, R16
	ldi R16, 1
	sts RTC_CTRL, R16
	call checkifdone
	clr R16
	ret
B6:
	call CLEAR_LCD
	ldi R17, 1 // a simple flag used in scales, cleared when the RTC compare completes

	ldi ZL, low(b6string<<1)
	ldi ZH, high(b6string<<1) //load the location i am outpitting to lcd

	call OUT_STRING_LCD

	ldi ZH, high(TCF0_CCA)
	ldi ZL, low(TCF0_CCA)
	ldi R16, low(506)
	st Z+, R16
	ldi R16, high(506)
	st Z, R16 //this block sets the timer's period to make the freq

	ldi R16, 1
	sts TCF0_CTRLA, R16
	
	ldi ZH, high(RTC_CNT)
	ldi ZL, low(RTC_CNT)
	ldi R16, 0
	st Z+, R16
	st Z, R16
	ldi R16, 1
	sts RTC_CTRL, R16
	call checkifdone
	clr R16
	ret
C7:
	call CLEAR_LCD
	ldi R17, 1 // a simple flag used in scales, cleared when the RTC compare completes

	ldi ZL, low(c7string<<1)
	ldi ZH, high(c7string<<1) //load the location i am outpitting to lcd

	call OUT_STRING_LCD

	ldi ZH, high(TCF0_CCA)
	ldi ZL, low(TCF0_CCA)
	ldi R16, low(478)
	st Z+, R16
	ldi R16, high(478)
	st Z, R16 //this block sets the timer's period to make the freq

	ldi R16, 1
	sts TCF0_CTRLA, R16
	
	ldi ZH, high(RTC_CNT)
	ldi ZL, low(RTC_CNT)
	ldi R16, 0
	st Z+, R16
	st Z, R16
	ldi R16, 1
	sts RTC_CTRL, R16
	clr R16
	call checkifdone
	ret
D7:
	call CLEAR_LCD
	ldi R17, 1 // a simple flag used in scales, cleared when the RTC compare completes

	ldi ZL, low(d7string<<1)
	ldi ZH, high(d7string<<1) //load the location i am outpitting to lcd

	call OUT_STRING_LCD

	ldi ZH, high(TCF0_CCA)
	ldi ZL, low(TCF0_CCA)
	ldi R16, low(426)
	st Z+, R16
	ldi R16, high(426)
	st Z, R16 //this block sets the timer's period to make the freq

	ldi R16, 1
	sts TCF0_CTRLA, R16
	
	ldi ZH, high(RTC_CNT)
	ldi ZL, low(RTC_CNT)
	ldi R16, 0
	st Z+, R16
	st Z, R16
	ldi R16, 1
	sts RTC_CTRL, R16
	clr R16
	call checkifdone
	ret
ascendingscale:
	call c6
	call d6
	call e6
	call f6
	call g6
	call a6
	call b6
	call c7
	ret
descendingescale:
	call d6
	call d6
	//call d6
	call e6
	call f6
	call g6
	call g6
	call c7
	call d7
	call d7
	call g6
	call e6
	call e6
	//call d6
	call d6
	call d6
	call g6
	call e6
	call e6
	call d6
	call c6
	call d6
	call d6
	call g6
	call e6
	call e6
	ret

USARTC0_RXC_ISR:
	cli
	lds R16, USARTC0_DATA
	sei
	reti

 LCD_BF_WAIT:
	push R16
	push r17
	ldi R16, 0
	ldi R17, 0

	AGAINLCD:
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
	BREQ CARRYLCD

	BACKLCD:
	CPI R17, 0x01
	BRNE AGAINLCD
	BREQ RETURNLCD

	CARRYLCD:
	INC R17
	rjmp BACKLCD

	RETURNLCD: 
		pop r17
		pop r16
		RET


// put all of the table data here so you can print it to LCD
B5STRING:
.db "B5 987.77 HZ", 0
C6STRING:
.db "C6 1046.50 HZ", 0
C6SHSTRING:
.db "C6#/D6b 1108.73 HZ", 0
D6STRING:
.db "D6 1174.66 HZ", 0 
D6SHSTRING:
.db "D6#/E6b 1244.51 HZ", 0
E6STRING:
.db "E6 1318.51 HZ", 0
F6STRING:
.db "F6 1396.91 HZ", 0
F6SHString:
.db "F6#/G6b 1479.98 HZ", 0
G6STRING:
.db "G6 1567.98 HZ", 0
G6SHSTRING:
.db "G6#/A6b 1661.22 HZ", 0
A6STRING:
.db "A6 1760.00 HZ", 0
A6SHSTRING:
.db "A6#/B6b 1864.66 HZ", 0
B6STRING:
.db "B6 1975.53 HZ", 0
C7STRING:
.db "C7 2093.00 HZ", 0
D7STRING:
.db "D7 2349.32 HZ", 0


//LCD out subroutines
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
Clear_LCD:
	push R16
	ldi R16, 1
	ldi XL, low(LCDPORT_COM)
	ldi XH, high(LCDPORT_COM)

	st X, R16
	pop R16
	ret

RTC_COMP_ISR:
	cli
	push R16
	clr R17 //flag register for scales
	ldi R16, 0
	sts RTC_CTRL, R16
	sts RTC_CNT, R16
	sts RTC_CNT+1, R16

	//ldi ZL, low(TCF0_CCA)
	//ldi ZH, high(TCF0_CCA) //load Z so we can write our compare value

	//ldi R16, 0
	//st Z+, R16

	ldi R16, 0
	sts TCF0_CTRLA, R16

	ldi R16, 0
	st Z, R16 // stop the wave

	pop R16
	sei
	reti
checkifdone:
	sbrc R17, 0
	rjmp checkifdone
	ret