/*
 * Lab2_c_part1.c
 *
 * Created: 3/27/2013 12:57:47 PM
 *  Author: Brandon
 */ 
#include <avr/io.h>
#include <avr/delay.h>

#define F_CPU 2000000UL
#define halfsecond 500
#define second 1000

uint8_t getPort(PORT_t *port)
{
	return port->IN;
}

void setPort(PORT_t *port, uint8_t out)
{
	port->DIRSET = out;
	port->OUT = out;
}

void delay(uint8_t *switches)
{
	if ((*switches & PIN3_bm) == PIN3_bm)
	{
		_delay_ms(halfsecond);
	}
	else _delay_ms(second);
}

int main(void)
{
	PORT_t *ledport = &PORTE;
	PORT_t *switchport = &PORTD;
	ledport->DIR = 0xFF;
	switchport->DIRCLR = PIN5_bm | PIN3_bm;
	
	volatile uint8_t switches;
	volatile uint8_t temp;
	
	while(1)
	{
		switches = getPort(switchport);
		if ((switches & PIN5_bm) == PIN5_bm)
		{
			temp = ledport->OUT;
			temp++;
			setPort(ledport, temp);
			delay(&switches);
		}
		else
		{
			temp = 1;
			while(!((switches & PIN5_bm) == PIN5_bm))
			{
				setPort(ledport, temp);
				temp <<= 1;
				if (temp == 0) temp = 1;
				delay(switches);
				switches = getPort(switchport);			}
		}
	}     
}