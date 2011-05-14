
// system includes
#include <stdlib.h>
#include <assert.h>
#ifdef WIN32
#include <windows.h>  // otherwise gl.h will barf
#endif

// game lib includes
#include <GL/gl.h>
#include <GL/glu.h>
#include <SDL.h>

// SDL includes
#include <vector>
using namespace std;

// local includes
#include "utils.h"
#include "game_world.h"
#include "game_objects.h"

void ResizeWindow(int width, int height)
{
	glViewport(0, 0, (GLsizei)(width), (GLsizei)(height));
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();

	gluPerspective(45.0f, (GLfloat)(width)/(GLfloat)(height), 0.2f, 100.0f);
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
}

void RenderFrame(SDL_Surface* screen, GnomeMaze::GameWorld& world)
{
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	glLoadIdentity();

	world.Render();

	SDL_GL_SwapBuffers();
}

void HandleInputEvents(GnomeMaze::GameWorld& world)
{
    SDL_Event event;
	while ( SDL_PollEvent(&event) ) {
        switch (event.type) {

	        case SDL_QUIT:
		        exit(0);
				break;

			case SDL_KEYDOWN:
				switch (event.key.keysym.sym) {

					case SDLK_ESCAPE:
						exit(0);
						break;

					// player movement
					case SDLK_w:
					case SDLK_UP:
						world.SetPlayerMoveForward(true);
						break;
					case SDLK_a:
					case SDLK_LEFT:
						world.SetPlayerMoveLeft(true);
						break;
					case SDLK_s:
					case SDLK_DOWN:
						world.SetPlayerMoveBack(true);
						break;
					case SDLK_d:
					case SDLK_RIGHT:
						world.SetPlayerMoveRight(true);
						break;
				}
				break;

			case SDL_KEYUP:
				switch (event.key.keysym.sym) {
					// player movement
					case SDLK_w:
					case SDLK_UP:
						world.SetPlayerMoveForward(false);
						break;
					case SDLK_a:
					case SDLK_LEFT:
						world.SetPlayerMoveLeft(false);
						break;
					case SDLK_s:
					case SDLK_DOWN:
						world.SetPlayerMoveBack(false);
						break;
					case SDLK_d:
					case SDLK_RIGHT:
						world.SetPlayerMoveRight(false);
						break;
				}
				break;

			case SDL_VIDEORESIZE:
				ResizeWindow(event.resize.w, event.resize.h);
				break;

			case SDL_MOUSEMOTION:
				world.UpdateMouselook(event.motion.xrel, event.motion.yrel);
				break;
		}
	}
}

int main(int argc, char *argv[])
{
	const int screen_width = 1024;
	const int screen_height = 768;
	const int screen_bpp = 32;
	const int screen_vflags = SDL_HWSURFACE|SDL_OPENGLBLIT;

    if ( SDL_Init(SDL_INIT_AUDIO|SDL_INIT_VIDEO) < 0 ) {
        fprintf(stderr, "unable to init SDL: %s\n", SDL_GetError());
        exit(1);
    }
	atexit(SDL_Quit);

	SDL_Surface *screen;
	screen = SDL_SetVideoMode( screen_width, screen_height, screen_bpp, screen_vflags );
	if ( screen == NULL ) {
		fprintf(stderr, "unable to set video mode: %s\n", SDL_GetError());
		exit(1);
	}
	ResizeWindow( screen_width, screen_height );

	glEnable(GL_DEPTH_TEST);
	glEnable(GL_TEXTURE_2D);
	SDL_ShowCursor(0);
	SDL_WM_GrabInput(SDL_GRAB_ON);

	// world globals
	GnomeMaze::GameWorld world;
	world.Populate(); // populate the game world (testing)

	// main loop
	int last_frame_ticks = SDL_GetTicks();
	while (true) {
		HandleInputEvents(world);

		int frame_ticks = SDL_GetTicks();
		world.Update(frame_ticks - last_frame_ticks);
		last_frame_ticks = frame_ticks;

		RenderFrame(screen, world);
	}

	return 0;
}
