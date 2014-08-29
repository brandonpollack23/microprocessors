/*
 * PCMmain.c
 *
 * Created: 4/9/2013 2:49:21 PM
 *  Author: Brandon
 */ 


#include <avr/io.h>
#include <avr/interrupt.h>
#include "kraid.h"

void change_to_32MHZ_clk();
void set_up_PWMgen();

volatile uint16_t position = 0;
volatile uint8_t int_cyc = 4;

int main(void)
{
	change_to_32MHZ_clk();
	set_up_PWMgen();
	PMIC_CTRL = PMIC_LOLVLEN_bm;
	sei();	
    while(1);
}

ISR(TCF0_OVF_vect)
{
	int_cyc--;
	if (int_cyc == 0)
	{
		int_cyc = 4;
		if (position < 25387) position++;
		else
		{
			position = 0;
		}			
		uint16_t temp = pgm_read_byte(&kraid_song[position]);
		TCF0.CCA = temp;
	}		
}

void change_to_32MHZ_clk()
{
	OSC.CTRL |= 0x3;
	while(!(OSC.STATUS & OSC_RC32MRDY_bm));
	CCP = CCP_IOREG_gc;
	CLK.CTRL = CLK_SCLKSEL_RC2M_gc;
}

void set_up_PWMgen()
{
	PORTF.DIRSET |= PIN0_bm;
	TCF0.CTRLB |= TC0_CCAEN_bm | TC_WGMODE_SINGLESLOPE_gc;
	TCF0.INTCTRLA |= TC_OVFINTLVL_LO_gc;
	//TCF0.INTCTRLB |= TC_CCAINTLVL_LO_gc;
	TCF0.CNT = 0;
	TCF0.CCA = 0;
	TCF0.PER = 255;
	TCF0.CTRLA = TC_CLKSEL_DIV4_gc;
}