
#include "texture.h"

#include <malloc.h>

void texture_init(t_texture* tex)
{
    memset(tex, 0, sizeof(tex));
}

void texture_fin(t_texture* tex)
{
    if (tex->data) {
        free(tex->data);
        tex->data = NULL;
    }

    if (tex->id) {
        glDeleteTextures(1, &(tex->id));
        tex->id = 0;
    }
}

void texture_bind(const t_texture* tex)
{
    glBindTexture(GL_TEXTURE_2D, tex->id);
}

bool texture_load_from_disk(t_texture* tex, const char* filename)
{
    bool has_alpha, retval;
    retval = load_png(filename, &(tex->width), &(tex->height), &has_alpha, &(tex->data));

    if (!retval) {
        return false;
    }

    if (has_alpha) {
        tex->format = GL_RGBA;
    } else {
        tex->format = GL_RGB;
    }

    return true;
}

void texture_move_to_vram(t_texture* tex)
{
    glGenTextures(1, &(tex->id));
    glBindTexture(GL_TEXTURE_2D, tex->id);

    glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri (GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    glTexParameteri (GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri (GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_DECAL); //GL_MODULATE);

    glTexImage2D(GL_TEXTURE_2D, 0, tex->format, tex->width, tex->height, 0, tex->format, GL_UNSIGNED_BYTE, tex->data);

    free(tex->data);
    tex->data = NULL;
}
