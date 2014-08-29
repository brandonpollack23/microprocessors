/* A collection of inits for the EBI and stack init at the bottom */
.set IOPORT = 0x5000
.set SRAMPORT = 0x370000


.macro TRIPORT_ALE_ONE_INIT
	

	ldi R16, 0b00110111
	sts PORTH_DIR, R16 //set port pins as outputs for RE and ALE and WE CS1 and CS0

	ldi R16, 0b00110011
	sts PORTH_OUTSET, R16 //WE and RE and CS pins are active low so it must be set

	ldi R16, 0xFF
	sts PORTJ_DIR, R16 //set datalines as outputs (manual says so)
	sts PORTK_DIR, R16 //set address lines as outputs

	ldi R16, 0x01
	sts EBI_CTRL, R16 //turn on 3 port SRAM ALE1 EBI
.endmacro


.macro CS0_INIT

	ldi ZH, HIGH(EBI_CS0_BASEADDR) //all the set up for CS0, since EBI won't work without it
	ldi ZL, LOW(EBI_CS0_BASEADDR)

	ldi R16, ((IOPORT>>8) & 0xF0)
	st Z+, R16

	ldi R16, ((IOPORT>>16) & 0xFF)
	st Z, R16

	ldi R16, 0x11
	sts EBI_CS0_CTRLA, R16
.endmacro

.macro CS1_INIT
	.equ SRAMPORT = 370000

	ldi ZH, HIGH(EBI_CS1_BASEADDR) //set up CS1 for the SRAM
	ldi ZL, LOW(EBI_CS1_BASEADDR)

	ldi R16, ((SRAMPORT>>8) & 0xF0)
	st Z+, R16

	ldi R16, ((SRAMPORT>>16) & 0xFF)
	st Z, R16

	ldi R16, 0b00011101
	sts EBI_CS1_CTRLA, R16
.endmacro
	

.macro STACK_INIT
	ldi R16, 0xFF
	out CPU_SPL, R16
	ldi R16, 0x3F
	out CPU_SPH, R16 //init stack pointer
.endmacro