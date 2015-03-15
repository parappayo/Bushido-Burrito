

#ifndef TEXTURE_H
#define TEXTURE_H
#pragma once

#include <gl/gl.h>

#include "load_png.h"

typedef struct t_texture
{
    GLsizei width, height;
    GLint format;
    GLuint id;
    GLubyte* data;
}
t_texture;

void texture_init (t_texture* tex);
void texture_fin  (t_texture* tex);

void texture_bind           (const t_texture* tex);
bool texture_load_from_disk (t_texture* tex, const char* filename);
void texture_move_to_vram   (t_texture* tex);

#endif // TEXTURE_H
