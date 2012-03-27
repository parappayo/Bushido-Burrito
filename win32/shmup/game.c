
#include "game.h"

#include <string.h>
#include <assert.h>

#include "game_math.h"

static t_bullet_slot* g_next_free_player_bullet_slot = NULL;
static t_bullet_slot* g_next_free_enemy_bullet_slot = NULL;

void game_init(t_game_state* gs)
{
    memset(gs, 0, sizeof(gs));

    for (unsigned int i = 0; i < MAX_PLAYER_BULLETS-1; i++) {
        gs->player_bullets[i].header.next_free = gs->player_bullets + i+1;
    }
    g_next_free_player_bullet_slot = gs->player_bullets;
    for (unsigned int i = 0; i < MAX_ENEMY_BULLETS-1; i++) {
        gs->enemy_bullets[i].header.next_free = gs->enemy_bullets + i+1;
    }
    g_next_free_enemy_bullet_slot = gs->enemy_bullets;

    // START test code
    t_bullet* test_bullets[1000];
    for (int i = 0; i < 1000; i++) {
        t_bullet* bullet = game_spawn_bullet(gs, false);
        bullet->sprite.width = 32.0f;
        bullet->sprite.height = 32.0f;
        bullet->sprite.pos_x = 200.5f;
        bullet->sprite.pos_y = 300.5f;
        bullet->vel_x = game_cos(i) * -0.05f;
        bullet->vel_y = game_sin(i) * -0.05f;
        test_bullets[i] = bullet;
    }
    for (int i = 20; i < 50; i++)
    {
        // is it okay?
        game_despawn_bullet(gs, test_bullets[i]);
    }
    for (int i = 0; i < 1000; i++)
    {
        t_bullet* bullet = game_spawn_bullet(gs, false);
        bullet->sprite.width = 32.0f;
        bullet->sprite.height = 32.0f;
        bullet->sprite.pos_x = 200.5f;
        bullet->sprite.pos_y = 300.5f;
        bullet->vel_x = game_cos(i) * -0.02f;
        bullet->vel_y = game_sin(i) * -0.02f;
        test_bullets[i] = bullet;
    }
    // END test code
}

void game_fin(t_game_state* gs)
{
}

void game_update(t_game_state* gs)
{
    for (unsigned int i = 0; i < MAX_PLAYER_BULLETS; i++) {
        t_bullet_slot* bullet = gs->player_bullets + i;
        if (bullet->header.is_used) {
            bullet_update(&(bullet->data));
        }
    }
    for (unsigned int i = 0; i < MAX_ENEMY_BULLETS; i++) {
        t_bullet_slot* bullet = gs->enemy_bullets + i;
        if (bullet->header.is_used) {
            bullet_update(&(bullet->data));
        }
    }
}

t_bullet* game_spawn_bullet(t_game_state* gs, bool is_player_shot)
{
    t_bullet_slot* slot = NULL;

    if (is_player_shot) {
        slot = g_next_free_player_bullet_slot;
    } else {
        slot = g_next_free_enemy_bullet_slot;
    }

    if (!slot) { return NULL; }

    if (is_player_shot) {
        g_next_free_player_bullet_slot = slot->header.next_free;
    } else {
        g_next_free_enemy_bullet_slot = slot->header.next_free;
    }

    slot->header.is_used = true;
    t_bullet* retval = &slot->data;
    bullet_init(retval);
    return retval;
}

void game_despawn_bullet(t_game_state* gs, t_bullet* bullet)
{
    // check that what we're given is a pointer to something that has a slot
    assert((void*)bullet > (void*)&gs->player_bullets);
    assert((void*)&gs->enemy_bullets > (void*)&gs->player_bullets);
    assert((void*)bullet < (void*)&gs->enemy_bullets + MAX_ENEMY_BULLETS);

    // assumes the slot header is in memory right before slot data
    t_bullet_slot* slot = (t_bullet_slot*)( ((unsigned char*)bullet) - sizeof(t_bullet_slot_header));
    slot->header.is_used = false;

    bool is_player_shot = (void*)bullet < (void*)&gs->enemy_bullets;
    if (is_player_shot) {
        slot->header.next_free = g_next_free_player_bullet_slot;
        g_next_free_player_bullet_slot = slot;
    } else {
        slot->header.next_free = g_next_free_enemy_bullet_slot;
        g_next_free_enemy_bullet_slot = slot;
    }
}
