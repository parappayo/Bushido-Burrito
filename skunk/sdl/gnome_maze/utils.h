
#ifndef __UTILS_H__
#define __UTILS_H__

#ifdef WIN32
#include <windows.h>
#endif
#include <GL/gl.h>

namespace GnomeMaze {

const float pi_over_180 = 0.0174532925f;

bool FileExists(const char* filename);
GLuint LoadTexture(const char* file);

} // namespace GnomeMaze

#endif // __UTILS_H__
