
#ifndef RENDER_H
#define RENDER_H
#pragma once

#include <gl/gl.h>

#include "game.h"

void render_init   (int window_width, int window_height);
void render_update (const t_game_state* gs);
void render_resize (int width, int height);

#endif // RENDER_H
