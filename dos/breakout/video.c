//------------------------------------------------------------------------------
//  video.c - simple DOS VGA graphics routines
//------------------------------------------------------------------------------

#include "video.h"

#include <dos.h>
#include <stdlib.h>

unsigned char far *vram = (unsigned char far *)0xA0000000L;

//unsigned char far *frame_buffer = NULL;

//------------------------------------------------------------------------------
void set_video_mode(unsigned char mode)
{
	/*
	if (frame_buffer != NULL)
	{
		farfree(frame_buffer);
	}
	frame_buffer = farmalloc(SCREEN_WIDTH * SCREEN_HEIGHT);
	video_clear();
	*/

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
	//frame_buffer[((y<<8)+(y<<6))+x] = color;
}

//------------------------------------------------------------------------------
void video_clear(void)
{
	//fmemset(frame_buffer, 0, SCREEN_WIDTH * SCREEN_HEIGHT);

	// stupid way
	// TODO: try doing this 4 bytes at a time with an int
	/*
	for (unsigned int i = 0; i < SCREEN_WIDTH * SCREEN_HEIGHT; i++)
	{
		frame_buffer[i] = COLOR_BLACK;
	}
	*/
}

//------------------------------------------------------------------------------
void video_swap(void)
{
	// wait for vertical retrace
	//while ((inp(INPUT_STATUS_1) & VRETRACE));
	//while (!(inp(INPUT_STATUS_1) & VRETRACE));

	//memcpy(vram, frame_buffer, SCREEN_WIDTH * SCREEN_HEIGHT);

	// stupid way
	/*
	for (unsigned int i = 0; i < SCREEN_WIDTH * SCREEN_HEIGHT; i++)
	{
		vram[i] = frame_buffer[i];
	}
	*/
}

