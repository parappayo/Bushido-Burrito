
#include "ball.h"
#include "video.h"
#include "paddle.h"

// globals
static int ball_pos_x = 0;
static int ball_pos_y = 0;
static int ball_velocity_x = 1;
static int ball_velocity_y = 1;
static int ball_width = 3;
static int ball_height = 3;

static int ball_min_pos_x = 0;
static int ball_min_pos_y = 0;
static int ball_max_pos_x = SCREEN_WIDTH - 3; // 3 = ball_width
static int ball_max_pos_y = SCREEN_HEIGHT - 3; // 3 = ball_height

//------------------------------------------------------------------------------
void ball_draw_color(int c)
{
	for (int y = ball_pos_y; y < ball_pos_y + ball_height; y++)
	{
		for (int x = ball_pos_x; x < ball_pos_x + ball_width; x++)
		{
			plot_pixel(x, y, c);
		}
	}
}

//------------------------------------------------------------------------------
void ball_clear(void)
{
	ball_draw_color(COLOR_BLACK);
}

//------------------------------------------------------------------------------
void ball_update(void)
{
	char x_collision = 0;
	char y_collision = 0;

	ball_pos_x += ball_velocity_x;
	ball_pos_y += ball_velocity_y;

	blocks_check_collision(ball_pos_x, ball_pos_y, &x_collision, &y_collision);

	// check paddle collision
	int paddle_x, paddle_y, paddle_width;
	paddle_get_pos(&paddle_x, &paddle_y, &paddle_width);

	if (ball_pos_x >= paddle_x &&
		ball_pos_x < paddle_x + paddle_width &&
		ball_pos_y + ball_height - 1 == paddle_y )
	{
		y_collision = 1;
	}

	// check wall collision
	if (ball_pos_x < ball_min_pos_x)
	{
		ball_pos_x = ball_min_pos_x;
		x_collision = 1;
	}
	else if (ball_pos_x > ball_max_pos_x)
	{
		ball_pos_x = ball_max_pos_x;
		x_collision = 1;
	}

	// check ceiling, floor collision
	if (ball_pos_y < ball_min_pos_y)
	{
		ball_pos_y = ball_min_pos_y;
		y_collision = 1;
	}
	else if (ball_pos_y > ball_max_pos_y)
	{
		ball_pos_y = ball_max_pos_y;

		// TODO: player lost a ball here
		y_collision = 1; // placeholder logic
	}

	if (x_collision)
	{
		ball_velocity_x = -ball_velocity_x;
	}
	if (y_collision)
	{
		ball_velocity_y = -ball_velocity_y;
	}
}

//------------------------------------------------------------------------------
void ball_draw(void)
{
	ball_draw_color(COLOR_WHITE);
}

