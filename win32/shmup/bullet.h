
#ifndef BULLET_H
#define BULLET_H
#pragma once

#include <gl/gl.h>

#include "sprite.h"

enum t_bullet_type
{
    BULLET_DEFAULT,
};

struct t_bullet;
typedef void (*bullet_pos_func)(struct t_bullet* bullet);

typedef struct t_bullet
{
    enum t_bullet_type type;
    unsigned int frame_count;
    bullet_pos_func pos_func;

    GLfloat vel_x, vel_y;
    t_sprite sprite;
}
t_bullet;

void bullet_init   (t_bullet* bullet);
void bullet_update (t_bullet* bullet);

#endif // BULLET_H
