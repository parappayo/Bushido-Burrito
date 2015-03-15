
#include "sprite.h"

#include <string.h>

#include "texture.h"

static t_texture default_tex;
static t_texture plane01_tex;

void sprite_system_init(void)
{
    // TODO: make default tex something more recognizable
    texture_init(&default_tex);
    texture_load_from_disk(&default_tex, "plane01.png");
    texture_move_to_vram(&default_tex);

    texture_init(&plane01_tex);
    texture_load_from_disk(&plane01_tex, "plane01.png");
    texture_move_to_vram(&plane01_tex);
}

void sprite_init(t_sprite* sprite)
{
    memset(sprite, 0, sizeof(sprite));
}

/**
 * This is called from the render system to determine what the sprite's
 * texture for the current frame is.
 */
struct t_texture* sprite_get_texture(
        const t_sprite* sprite,
        GLfloat* out_u1,
        GLfloat* out_v1,
        GLfloat* out_u2,
        GLfloat* out_v2)
{
    t_texture* retval = &default_tex;

    switch (sprite->type)
    {
        case SPRITE_BULLET_01:
        {
            retval = &plane01_tex;
            *out_u1 = 0.0f;
            *out_v1 = 0.0f;
            *out_u2 = 1.0f / 8.0f;
            *out_v2 = 1.0f;
        }
        break;

        // testing animation logic
        case SPRITE_PLANE_01_SPIN:
        {
            retval = &plane01_tex;
            *out_u1 = (float)(sprite->frame % 8) * 1.0f / 8.0f;
            *out_v1 = 0.0f;
            *out_u2 = (float)(sprite->frame % 8 + 1) * 1.0f / 8.0f;
            *out_v2 = 1.0f;
        }
        break;

        default:
        {
            *out_u1 = 0.0f;
            *out_v1 = 0.0f;
            *out_u2 = 1.0f;
            *out_v2 = 1.0f;
        }
        break;
    }

    // for test purposes
    return retval;
}
