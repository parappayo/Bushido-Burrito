
#ifndef LOAD_PNG_H
#define LOAD_PNG_H
#pragma once

#include <stdbool.h>
#include <png.h>
#include <gl/gl.h>

bool load_png(const char* filename, int* out_width, int* out_height, bool* out_has_alpha, GLubyte** out_data);

#endif // LOAD_PNG_H
