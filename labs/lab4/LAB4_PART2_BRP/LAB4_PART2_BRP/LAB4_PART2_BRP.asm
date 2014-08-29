/* Brandon Pollack
* Ivan
* 1524
* Main program for part 2 SRAM 
*/

.include "atxmega128a1udef.inc"
.equ IOPORT = 0x5000
.equ SRAMPORT = 0x370000

.org 0x00
	rjmp 0x100

.org 0x100
	ldi R16, 0xFF
	out CPU_SPL, R16
	ldi R16, 0x3F
	out CPU_SPH, R16 //init stack pointer

	ldi R16, 0b00110111
	sts PORTH_DIR, R16 //set port pins as outputs for RE and ALE and WE CS1 and CS0

	ldi R16, 0b00110011
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

	ldi ZH, HIGH(EBI_CS1_BASEADDR) //set up CS1 for the SRAM
	ldi ZL, LOW(EBI_CS1_BASEADDR)

	ldi R16, ((SRAMPORT>>8) & 0xF0)
	st Z+, R16

	ldi R16, ((SRAMPORT>>16) & 0xFF)
	st Z, R16

	ldi R16, 0b00011101
	sts EBI_CS1_CTRLA, R16

	ldi XH, HIGH(IOPORT)
	ldi XL, LOW(IOPORT)

	ldi R16, 0x37		//RAMP Y for the SRAM
	out CPU_RAMPY, R16
	ldi YH, 0x00
	LDI YL, 0x00


MAIN:
	ldi R16, 0xFF
	ldi R17, 0xFF
	ldi R18, 0x55
	ldi R19, 0x55
LOOP:
	st Y+, R18
	CPI R16, 0
	BREQ NOWR1
	dec R16
	rjmp loop
	NOWR1:
	dec R16
	cpi R17, 0x0F
	breq donewriting
	dec R17
	rjmp loop

donewriting: 
	ldi R16, 0x37
	out CPU_RAMPY, R16
	ldi YL, 0
	ldi YH, 0

	ldi ZH, 0x20
	ldi ZL, 0x00 //just need this last pointer here to point to internal memory to write the bad memory blocks

READLOOP:
	ld R16, Y
	cp R16, R18
	brne somethingwentwrong
	inc YL
	BRBC 1,nocarry //I did not know how to inc Y with carry between the two regs so I did this 
	inc YH

	nocarry:
	in R16, CPU_RAMPY
	cpi YH, 0x80
	breq end
	rjmp readloop

somethingwentwrong:
	st Z+, YL
	st Z+, YH
		
	badloop:
		inc YL
		brbc 1, nocarry2
		inc YH

		nocarry2:
		in R16, CPU_RAMPY
		cpi YH, 0xEF
		breq end
		//st Y, R18
		ld R16, Y
		cp R16, R18
		brne badloop

		breq nocarry3
		//st Y, R19
		ld R16, Y
		cp R16, R19
		brne badloop
		dec YL
		cpi YL, 0xff
		brne nocarry3 //the decrement I handled slighltly differently, I comared YL with FF, if it is then we have to carry
		dec YH

		nocarry3:
		dec YL
		st Z+, YL
		st Z+, YH

		inc YL
		brbc 1, nocarry4
		inc YH

		nocarry4:
		st Y, R18

		rjmp readloop


end: rjmp end
	