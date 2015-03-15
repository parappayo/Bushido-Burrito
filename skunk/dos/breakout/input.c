//------------------------------------------------------------------------------
//  input.c - simple DOS input handling
//------------------------------------------------------------------------------

#include "input.h"

#include <dos.h>

const int keyboard_interrupt = 0x9;

void (__far *interrupt bios_keyboard_handler)();

unsigned char key_down[NUM_KEYS];

//------------------------------------------------------------------------------
void __far interrupt keyboard_handler()
{
	unsigned char key_code = inp(0x60);
	outp(0x20, 0x20); // acknowledgement

	if (key_code < NUM_KEYS)
	{
		key_down[key_code] = 1;
	}
	else
	{
		key_code &= 0x7f;  // clear most-significant bit

		if (key_code < NUM_KEYS)
		{
			key_down[key_code] = 0;
		}
	}
}

//------------------------------------------------------------------------------
void init_input(void)
{
	bios_keyboard_handler = getvect(keyboard_interrupt);
	setvect(keyboard_interrupt, keyboard_handler);

	for (int i = 0; i < NUM_KEYS; i++)
	{
		key_down[i] = 0;
	}
}

//------------------------------------------------------------------------------
void fin_input(void)
{
	setvect(keyboard_interrupt, bios_keyboard_handler);
}

//------------------------------------------------------------------------------
unsigned char is_key_down(unsigned char key_code)
{
	if (key_code < NUM_KEYS)
	{
		return key_down[key_code];
	}

	return 0;
}

