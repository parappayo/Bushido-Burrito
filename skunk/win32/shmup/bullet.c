
#include "bullet.h"

#include <string.h>

void bullet_init(t_bullet* bullet)
{
    memset(bullet, 0, sizeof(bullet));

    sprite_init(&bullet->sprite);
    //bullet->sprite.type = SPRITE_BULLET_01;
    bullet->sprite.type = SPRITE_PLANE_01_SPIN;
}

void bullet_update_default(t_bullet* bullet)
{
    if (!bullet->pos_func) {
        bullet->sprite.pos_x += bullet->vel_x;
        bullet->sprite.pos_y += bullet->vel_y;
    } else {
        bullet->pos_func(bullet);
    }

    bullet->frame_count += 1;

    // test animation logic
    bullet->sprite.frame = (int)(bullet->frame_count / 100) % 8;
}

void bullet_update(t_bullet* bullet)
{
    switch (bullet->type)
    {
        case BULLET_DEFAULT:
        default:
            bullet_update_default(bullet);
            break;
    }
}
