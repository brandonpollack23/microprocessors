/* Brandon Pollack
* Ivan
* 1524
* Main program for part 1 keypad and it's subroutine
*/

.include "atxmega128a1udef.inc"
.equ IOPORT = 0x5000

.org 0x00
	rjmp 0x100

.org 0x100
	ldi R16, 0xFF
	out CPU_SPL, R16
	ldi R16, 0x3F
	out CPU_SPH, R16 //init stack pointer

	ldi R16, 0x17
	sts PORTH_DIR, R16 //set port pins as outputs for RE and ALE and WE

	ldi R16, 0x13
	sts PORTH_OUT, R16 //WE and RE is active low so it must be set

	ldi R16, 0xFF
	sts PORTJ_DIR, R16 //set datalines as outputs (manual says so)
	sts PORTK_DIR, R16 //set address lines as outputs

	ldi R16, 0x01
	sts EBI_CTRL, R16 //turn on 3 port SRAM ALE1 EBI

	ldi ZH, HIGH(EBI_CS0_BASEADDR) //all the set up for CS0, since EBI won't work without it
	ldi ZL, LOW(EBI_CS0_BASEADDR)

	ldi R16, ((IOPORT>>8) & 0xF0)
	st Z+, R16

	ldi R16, ((IOPORT>>16) & 0xFF)
	st Z, R16

	ldi R16, 0x11
	sts EBI_CS0_CTRLA, R16

	ldi XH, HIGH(IOPORT)
	ldi XL, LOW(IOPORT)


REPEAT:
	call GETKEYPAD //this will overwrite R18, will not exit until an input is recieved
	st X, R18
	rjmp repeat


GETKEYPAD:
	.org 0x200

	push R16
	push R17

	ldi R18, 0xFF //fill 18 wiht a value that can't get returned.  Notice it does not get pushed onto the stack!!!
	ldi R16, 0x0F
	sts PORTD_DIR, R16 //make sure the lower four bits are outputs and the upper are inputs

	LOOP:
		ldi R16, 0x07
		sts PORTD_OUT, R16 //make the first column low and others high
		NOP
		NOP
		NOP
		NOP
		NOP //have to wait a little while to compensate for bouncing
		lds R17, PORTD_IN // read if there is something not high on portD
		SBRS R17, 7
		ldi R18, 0x10
		SBRS R17, 6
		ldi R18, 0x20
		SBRS R17, 5
		ldi R18,  0x30
		SBRS R17, 4
		ldi R18, 0xA0

		ldi R16, 0x0B
		sts PORTD_OUT, R16
		NOP
		NOP
		NOP
		NOP
		NOP
		lds R17, PORTD_IN
		SBRS R17, 7
		ldi R18, 0x40
		SBRS R17, 6
		ldi R18, 0x50
		SBRS R17, 5
		ldi R18,  0x60
		SBRS R17, 4
		ldi R18, 0xB0

		ldi R16, 0x0D
		sts PORTD_OUT, R16
		NOP
		NOP
		NOP
		NOP
		NOP
		lds R17, PORTD_IN
		SBRS R17, 7
		ldi R18, 0070 
		SBRS R17, 6
		ldi R18, 0x80
		SBRS R17, 5
		ldi R18,  0x90
		SBRS R17, 4
		ldi R18, 0xC0

		ldi R16, 0x0E
		sts PORTD_OUT, R16
		NOP
		NOP
		NOP
		NOP
		NOP
		lds R17, PORTD_IN
		cpi R17, 0xFF
		SBRS R17, 7
		ldi R18, 0xE0
		SBRS R17, 6
		ldi R18, 0x00
		SBRS R17, 5
		ldi R18,  0xF0
		SBRS R17, 4
		ldi R18, 0xD0

		cpi R18, 0xFF
		brne DONE //if r18 didn't change then keep trying to get this stuff		

		jmp loop

	DONE:
		pop r17
		pop r16
		RET


		



