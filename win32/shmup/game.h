
#ifndef GAME_STATE_H
#define GAME_STATE_H
#pragma once

#include <stdbool.h>

#include "bullet.h"

#define MAX_PLAYER_BULLETS 200
#define MAX_ENEMY_BULLETS 10000

// uses a small-block allocator style scheme
typedef struct t_bullet_slot_header
{
    bool is_used;
    struct t_bullet_slot* next_free;
}
t_bullet_slot_header;

typedef struct t_bullet_slot
{
    t_bullet_slot_header header;
    t_bullet data;
}
t_bullet_slot;

typedef struct t_game_state
{
    // the order of these arrays matters
    t_bullet_slot player_bullets[MAX_PLAYER_BULLETS];
    t_bullet_slot enemy_bullets[MAX_ENEMY_BULLETS];
}
t_game_state;

void game_init   (t_game_state* gs);
void game_fin    (t_game_state* gs);
void game_update (t_game_state* gs);

t_bullet* game_spawn_bullet   (t_game_state* gs, bool is_player_shot);
void      game_despawn_bullet (t_game_state* gs, t_bullet* bullet);

#endif // GAME_STATE_H
