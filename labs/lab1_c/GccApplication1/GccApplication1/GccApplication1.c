/*
 * GccApplication1.c
 *
 * Created: 3/19/2013 12:27:25 PM
 *  Author: Brandon
 */


#include <avr/io.h>
#include <avr/pgmspace.h>

int main(void)
{
	INIT_PROGMEM;
	uint8_t *answer = 0x2100;
	uint8_t j = 0;
    for (int i = 0; i < 21; i++)
	{
		if (pgm_read_byte(&(x[i])) > 0x41)
		{
			answer[j] = pgm_read_byte(&(x[i]));
			j++;
		}
	}
	while(1)
	{
		asm ("NOP");
	}
	return 0;	
}
