//------------------------------------------------------------------------------
//  video.c - simple DOS VGA graphics routines
//------------------------------------------------------------------------------

#include "video.h"

#include <dos.h>

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

