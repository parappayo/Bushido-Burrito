
#include "sprite.h"

#include <string.h>

#include "texture.h"

static t_texture test_tex;

void sprite_system_init(void)
{
    texture_init(&test_tex);
    texture_load_from_disk(&test_tex, "plane01.png");
    texture_move_to_vram(&test_tex);
}

void sprite_init(t_sprite* sprite)
{
    memset(sprite, 0, sizeof(sprite));
}

struct t_texture* sprite_get_texture(const t_sprite* sprite, GLfloat* out_u1, GLfloat* out_v1, GLfloat* out_u2, GLfloat* out_v2)
{
    // defaults
    *out_u1 = 0.0f;
    *out_v1 = 0.0f;
    *out_u2 = 1.0f;
    *out_v2 = 1.0f;

    // TODO: consider sprite->type and sprite->frame

    // for test purposes
    *out_u2 = 1.0f / 8.0f;
    return &test_tex;
}
