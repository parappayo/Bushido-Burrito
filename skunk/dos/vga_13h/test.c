//------------------------------------------------------------------------------
//  DOS graphics test
//
//  Thanks to the following links:
//	 http://gamebub.com/cpp_graphics.php
//	 http://spike.scu.edu.au/~barry/interrupts.html
//
//  Written for Digital Mars C compiler to be compiled as a DOS 16 bit binary.
//------------------------------------------------------------------------------

#include <dos.h>

#define SCREEN_WIDTH  320;
#define SCREEN_HEIGHT 200;
#define MAX_COLOR 256

unsigned char far *vram = (unsigned char far *)0xA0000000L;

//------------------------------------------------------------------------------
void set_video_mode(unsigned char mode)
{
	union REGS in, out;
	in.h.ah = 0x0; // 0 = set video mode
	in.h.al = mode;
	int86(0x10, &in, &out);
}

//------------------------------------------------------------------------------
void set_video_page(unsigned char page)
{
	union REGS in, out;
	in.h.ah = 0x05; // 5 = select active page
	in.h.al = page;
	int86(0x10, &in, &out);
}

//------------------------------------------------------------------------------
void plot_pixel(unsigned int x, unsigned int y, unsigned char color)
{
	vram[((y<<8)+(y<<6))+x] = color;
}

//------------------------------------------------------------------------------
//  why use stdlib when you can roll your own? ;)
//------------------------------------------------------------------------------
int getc(void)
{
	union REGS in, out;
	in.h.ah = 0x08; // 08 = read character input, no echo
	int86(0x21, &in, &out);
	return out.h.al;
}

//------------------------------------------------------------------------------
int main(int argc, char* argv[])
{
	set_video_mode(0x13); // VGA 256 color

	for (unsigned int i = 0; i < 100; i++)
	{
		plot_pixel(i, 5, i % MAX_COLOR);
	}

	getc();

	set_video_mode(0x03); // return to text mode

	return 0;
}

