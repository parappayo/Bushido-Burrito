//------------------------------------------------------------------------------
//  breakout.c - DOS adaptation of the Atari arcade game, "Breakout"
//------------------------------------------------------------------------------

#include "video.h"
#include "input.h"
#include "paddle.h"
#include "ball.h"
#include "blocks.h"

int main(int argc, char** argv)
{
	init_input();
	video_init();
	set_video_mode(0x13); // VGA 256 color

	blocks_init();

	while (!is_key_down(KEY_ESC))
	{
		paddle_clear();
		ball_clear();

		paddle_update();
		ball_update();

		blocks_draw();
		ball_draw();
		paddle_draw();

		video_swap();
	}

	set_video_mode(0x03); // return to text mode
	video_fin();
	fin_input();
	return 0;
}

