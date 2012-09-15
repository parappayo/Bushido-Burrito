
#include "render.h"
#include "texture.h"
#include "sprite.h"

void render_init(int window_width, int window_height)
{
    render_resize(window_width, window_height);
}

void render_sprite(const t_sprite* sprite)
{
    GLfloat u1, v1, u2, v2;
    t_texture* tex = sprite_get_texture(sprite, &u1, &v1, &u2, &v2);
    texture_bind(tex);

    GLfloat left, right, top, bottom;
    left   = sprite->pos_x;
    top    = sprite->pos_y;
    right  = sprite->pos_x + sprite->width;
    bottom = sprite->pos_y + sprite->height;

    glBegin(GL_QUADS);
        glTexCoord2f(u1, v1);  glVertex2f(left,  top);
        glTexCoord2f(u2, v1);  glVertex2f(right, top);
        glTexCoord2f(u2, v2);  glVertex2f(right, bottom);
        glTexCoord2f(u1, v2);  glVertex2f(left,  bottom);
    glEnd();
}

void render_bullets(const t_game_state* gs)
{
    // TODO: optimization - create arrays grouping bullets by type so we can send em as a big batch

    for (unsigned int i = 0; i < MAX_PLAYER_BULLETS; i++) {
        const t_bullet_slot* bullet = gs->player_bullets + i;
        if (bullet->header.is_used) {
            render_sprite(&(bullet->data.sprite));
        }
    }
    for (unsigned int i = 0; i < MAX_ENEMY_BULLETS; i++) {
        const t_bullet_slot* bullet = gs->enemy_bullets + i;
        if (bullet->header.is_used) {
            render_sprite(&(bullet->data.sprite));
        }
    }
}

void render_update(const t_game_state* gs)
{
    glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    glDisable(GL_DEPTH_TEST);
    glEnable(GL_TEXTURE_2D);

    render_bullets(gs);
}

// found some help here:
//   http://basic4gl.wikispaces.com/2D+Drawing+in+OpenGL
//   http://stackoverflow.com/questions/648619/resizing-an-opengl-window-causes-it-to-fall-apart
void render_resize(int width, int height)
{
    double ratio;

    if (height == 0) { height = 1; }
    ratio = width / (double) height;

    //glViewport(0, 0, width, height);

/**/
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrtho(0, width, height, 0, 0, 1);
    glMatrixMode(GL_MODELVIEW);

/*
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluPerspective(FOV, asratio, ZMIN, ZMAX);
    glMatrixMode(GL_MODELVIEW);
/**/
}
