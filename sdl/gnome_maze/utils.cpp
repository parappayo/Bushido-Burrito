
#include "utils.h"

#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
#include <SDL.h>
#include <SDL_image.h>
#include <GL/glu.h>

namespace GnomeMaze {

bool FileExists(const char* filename)
{
	FILE* fp = fopen(filename, "rb");
	if (fp != NULL) {
		fclose(fp);
		return true;
	}
	return false;
}

GLuint LoadTexture(const char* file)
{
	GLuint texture = 0;

	if (!FileExists(file)) {
		return 0;
	}

	SDL_Surface* surface = IMG_Load(file);
	assert(surface);
	if (!surface) { return 0; }

	glPixelStorei(GL_UNPACK_ALIGNMENT,4);
	glGenTextures(1, &texture);
	glBindTexture(GL_TEXTURE_2D, texture);

	SDL_PixelFormat *format = surface->format;
	assert(format);
	if (!format) { return 0; }

	if (format->Amask) {
		gluBuild2DMipmaps(GL_TEXTURE_2D, 4,
			surface->w, surface->h, GL_RGBA,GL_UNSIGNED_BYTE, surface->pixels);
	} else {
		gluBuild2DMipmaps(GL_TEXTURE_2D, 3,
			surface->w, surface->h, GL_RGB, GL_UNSIGNED_BYTE, surface->pixels);
	}

	SDL_FreeSurface(surface);
	return texture;
}

} // namespace GnomeMaze
