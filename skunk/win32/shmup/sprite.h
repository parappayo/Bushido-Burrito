
#ifndef SPRITE_H
#define SPRITE_H
#pragma once

#include <gl/gl.h>

// forward decl
struct t_texture;

enum t_sprite_type
{
    SPRITE_DEFAULT,
    SPRITE_BULLET_01,
    SPRITE_PLANE_01_SPIN,
};

/**
 *  Contains all of the info that render.c needs to draw a textured quad.
 */
typedef struct t_sprite
{
    enum t_sprite_type type;
    unsigned int frame;
    GLfloat pos_x, pos_y, width, height;
}
t_sprite;

void sprite_system_init (void);
void sprite_init        (t_sprite* sprite);

/**
 *  Out params (u1, v1), (u2, v2) are texture coords.
 */
struct t_texture* sprite_get_texture (const t_sprite* sprite, GLfloat* out_u1, GLfloat* out_v1, GLfloat *out_u2, GLfloat* out_v2);

#endif // SPRITE_H
