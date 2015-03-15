//------------------------------------------------------------------------------
//  video.c - simple DOS VGA graphics routines
//------------------------------------------------------------------------------

#include "video.h"

#include <dos.h>
#include <stdlib.h>

typedef unsigned char t_pixel;

t_pixel far *vram = (unsigned char far *)0xA0000000L;

t_pixel far *frame_buffer = NULL;

//------------------------------------------------------------------------------
void video_init(void)
{
	if (frame_buffer != NULL)
	{
		farfree(frame_buffer);
	}
	frame_buffer = farmalloc(SCREEN_WIDTH * SCREEN_HEIGHT * sizeof(t_pixel));
	video_clear();
}

//------------------------------------------------------------------------------
void video_fin(void)
{
	farfree(frame_buffer);
}

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
	//vram[((y<<8)+(y<<6))+x] = color;
	frame_buffer[((y<<8)+(y<<6))+x] = color;
}

//------------------------------------------------------------------------------
void video_clear(void)
{
	memset(frame_buffer, 0, SCREEN_WIDTH * SCREEN_HEIGHT * sizeof(t_pixel));
}

//------------------------------------------------------------------------------
void video_swap(void)
{
	// wait for vertical retrace
	//while ((inp(INPUT_STATUS_1) & VRETRACE));
	//while (!(inp(INPUT_STATUS_1) & VRETRACE));

	memmove(vram, frame_buffer, SCREEN_WIDTH * SCREEN_HEIGHT * sizeof(t_pixel));
}

