/*
 * Lab3_c.c
 *
 * Created: 3/27/2013 7:52:04 PM
 *  Author: Brandon
 */ 


#include <avr/io.h>
#include <avr/delay.h>
#include "ebi_driver.h"

#define F_CPU 2000000UL

void ebi_init(void);

int main(void)
{
	uint8_t temp;
	
	ebi_init();
	
	uint8_t *ioport;
	ioport = 0x005000;
	
    while(1)
    {
       temp = __far_mem_read(ioport);
		
		for (int i = 0; i < 8; i++)
		{
			temp = ~temp;
			__far_mem_write(ioport, temp);
			//_delay_ms(500);
		}			
    }
}

void ebi_init(void)
{
	EBI_Enable(0,0,0,EBI_IFMODE_3PORT_gc);
	EBI_EnableSRAM(&EBI.CS0,EBI_CS_ASPACE_4KB_gc,0x5000,0);
}
