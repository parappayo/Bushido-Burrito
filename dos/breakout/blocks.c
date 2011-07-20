
#include "blocks.h"
#include "video.h"

#define NUM_BLOCKS_X	14
#define NUM_BLOCKS_Y	10

#define BLOCK_STATE_INIT		0
#define BLOCK_STATE_DRAW_ME		1
#define BLOCK_STATE_CLEAR_ME	2
#define BLOCK_STATE_DRAWN		3
#define BLOCK_STATE_CLEAR		4

// globals
static int block_field_x = 20;
static int block_field_y = 10;
static int block_height = 10;
static int block_width = 20;

static char blocks_changed = 1;
static char block_state[NUM_BLOCKS_X * NUM_BLOCKS_Y];

//------------------------------------------------------------------------------
void blocks_check_collision(int x, int y, int* x_collision, int* y_collision)
{
	// TODO: bug - need to take ball size into account

	int block_y = (y - block_field_y) / block_height;
	if (block_y < 0 || block_y >= NUM_BLOCKS_Y)
	{
		return;
	}

	int block_x = (x - block_field_x) / block_width;
	if (block_x < 0 || block_x >= NUM_BLOCKS_X)
	{
		return;
	}

	int i = block_y * NUM_BLOCKS_X + block_x;
	char state = block_state[i];

	if (state == BLOCK_STATE_DRAWN)
	{
		int block_inner_x = x - (block_x * block_width + block_field_x);
		int block_inner_y = y - (block_y * block_height + block_field_y);

		if (block_inner_x < 2) { *x_collision = 1; }
		if (block_inner_x >= block_width - 2) { *x_collision = 1; }
		if (block_inner_y < 2) { *y_collision = 1; }
		if (block_inner_y >= block_height - 2) { *y_collision = 1; }

		block_state[i] = BLOCK_STATE_CLEAR_ME;
		blocks_changed = 1;
	}
}

//------------------------------------------------------------------------------
//  args are in block grid space, NOT pixels
//------------------------------------------------------------------------------
void draw_block(int block_x, int block_y, int start_color, int end_color)
{
	int color_step = (end_color - start_color) / block_height;
	int c = start_color;

	int start_x = block_x * block_width + block_field_x;
	int end_x = start_x + block_width;

	int start_y = block_y * block_height + block_field_y;
	int end_y = start_y + block_height;

	for (int y = start_y; y < end_y; y++)
	{
		for (int x = start_x+1; x < end_x-1; x++)
		{
			plot_pixel(x, y, c);
		}

		// for some flair, vertical borders
		plot_pixel(start_x, y, start_color);
		plot_pixel(end_x-1, y, end_color);

		c += color_step;
	}
}

//------------------------------------------------------------------------------
void blocks_init(void)
{
	for (int i = 0; i < NUM_BLOCKS_X * NUM_BLOCKS_Y; i++)
	{
		block_state[i] = BLOCK_STATE_INIT;
	}
}

//------------------------------------------------------------------------------
void blocks_draw(void)
{
	if (!blocks_changed) { return; }
	blocks_changed = 0;

	for (int i = 0; i < NUM_BLOCKS_X * NUM_BLOCKS_Y; i++)
	{
		switch(block_state[i])
		{
			case BLOCK_STATE_INIT:
			case BLOCK_STATE_DRAW_ME:
				{
					draw_block(i % NUM_BLOCKS_X, i / NUM_BLOCKS_X, 30, 20);
					block_state[i] = BLOCK_STATE_DRAWN;
				}
				break;

			case BLOCK_STATE_CLEAR_ME:
				{
					draw_block(i % NUM_BLOCKS_X, i / NUM_BLOCKS_X, COLOR_BLACK, COLOR_BLACK);
					block_state[i] = BLOCK_STATE_CLEAR;
				}
				break;

			case BLOCK_STATE_DRAWN:
			case BLOCK_STATE_CLEAR:
			default:
				{
					// do nothing
				}
				break;
		}
	}
}

