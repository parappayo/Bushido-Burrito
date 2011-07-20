//------------------------------------------------------------------------------
//  blocks.h - logic for the game blocks
//------------------------------------------------------------------------------

#ifndef __BLOCKS_H__
#define __BLOCKS_H__

void blocks_check_collision(int x, int y, int* x_collision, int* y_collision);
void blocks_init(void);
void blocks_draw(void);

#endif // __BLOCKS_H__

