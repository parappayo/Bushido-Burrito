//------------------------------------------------------------------------------
//  DOS keyboard input test
//
//  Based on keyboard.txt from the FaqSys docs.  I found my copy here:
//    http://www.phatcode.net/articles.php?id=235
//
//  Written for Digital Mars C compiler to be compiled as a DOS 16 bit binary.
//------------------------------------------------------------------------------

#include <dos.h>
#include <stdio.h>

const int keyboard_interrupt = 0x9;

int done = 0;

//------------------------------------------------------------------------------
void __far interrupt keyboard_handler()
{
	unsigned char key_code = inp(0x60);
	outp(0x20, 0x20); // acknowledgement

	printf("key event: %u\n", key_code);

	if (key_code == 1) // Esc key
	{
		done = 1;
	}
}

//------------------------------------------------------------------------------
int main(int argc, char* argv[])
{
	void (__far *interrupt bios_keyboard_handler)();

	bios_keyboard_handler = getvect(keyboard_interrupt);
	setvect(keyboard_interrupt, keyboard_handler);

	printf("press esc to exit\n");

	while (!done)
	{
		// wait for keyboard_handler() to set done
	}

	setvect(keyboard_interrupt, bios_keyboard_handler);
	return 0;
}

