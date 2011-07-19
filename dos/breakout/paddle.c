//------------------------------------------------------------------------------
//  paddle.c - logic for the player's paddle
//------------------------------------------------------------------------------

#include "paddle.h"
#include "video.h"
#include "input.h"

// globals
static int paddle_pos_x = 50;
static int paddle_pos_y = SCREEN_HEIGHT - 10;
static int paddle_width = 20;

static int paddle_min_pos_x = 0;
static int paddle_max_pos_x = SCREEN_WIDTH - 20; // 20 = paddle_width

//------------------------------------------------------------------------------
void paddle_draw_color(int c)
{
	int x, y;

	y = paddle_pos_y;
	for (x = paddle_pos_x; x < paddle_pos_x + paddle_width; x++)
	{
		plot_pixel(x, y, c);
	}
}

//------------------------------------------------------------------------------
void paddle_clear(void)
{
	paddle_draw_color(COLOR_BLACK);
}

//------------------------------------------------------------------------------
void paddle_move_x(int x)
{
	paddle_pos_x += x;

	if (paddle_pos_x < paddle_min_pos_x)
	{
		paddle_pos_x = paddle_min_pos_x;
	}
	else if (paddle_pos_x > paddle_max_pos_x)
	{
		paddle_pos_x = paddle_max_pos_x;
	}
}

//------------------------------------------------------------------------------
//  per-frame update
//------------------------------------------------------------------------------
void paddle_update(void)
{
	if (is_key_down(KEY_RIGHT))
	{
		paddle_move_x(1);
	}
	else if (is_key_down(KEY_LEFT))
	{
		paddle_move_x(-1);
	}
}

//------------------------------------------------------------------------------
void paddle_draw(void)
{
	paddle_draw_color(COLOR_WHITE);
}

