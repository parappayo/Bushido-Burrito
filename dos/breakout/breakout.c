//------------------------------------------------------------------------------
//  breakout.c - DOS adaptation of the Atari arcade game, "Breakout"
//------------------------------------------------------------------------------

#include <stdio.h>

#include "video.h"
#include "input.h"

int main(int argc, char** argv)
{
	init_input();
	set_video_mode(0x13); // VGA 256 color

	while (!is_key_down(KEY_ESC))
	{
		if (is_key_down(KEY_LEFT))
		{
			printf("left.");
		}
		if (is_key_down(KEY_RIGHT))
		{
			printf("right.");
		}
	}

	set_video_mode(0x03); // return to text mode
	fin_input();
	return 0;
}

