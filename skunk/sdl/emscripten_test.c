
//
//  This demo shows building WebGL and binary versions from same source.
//
//  Binary Version
//
//  Build with
//    gcc emscripten_test.c -lSDL -lSDL_image -I/usr/include/SDL
//
//  WebGL Version
//
//  Build with
//    emcc emscripten_test.c -o emscripten_test.html --preload-file ./happyhappy.jpg -s STB_IMAGE=1
//  Serve with
//    c:\Python27\python.exe -m SimpleHTTPServer
//

#include <stdio.h>

#include <SDL/SDL.h>
#include <SDL/SDL_image.h>

#ifdef __EMSCRIPTEN__
#include <emscripten.h>
#endif

typedef struct Game
{
  SDL_Surface* screen;

  SDL_Surface* sprite;
  SDL_Rect source;
  SDL_Rect destination;

  void (*update)();

} Game;

void update(void* game_ptr)
{
  Game* game = (Game*) game_ptr;

  if (SDL_BlitScaled(game->sprite, &(game->source), game->screen, &(game->destination)))
  {
    printf("BlitSurface error: %s\n", SDL_GetError());
  }

  SDL_Flip(game->screen); 
}

int main(int argc, char** argv) {

  Game game;
  game.update = update;

  SDL_Init(SDL_INIT_VIDEO);
  game.screen = SDL_SetVideoMode(640, 480, 32, SDL_SWSURFACE);

  game.sprite = IMG_Load("happyhappy.jpg");

  game.source.x = 0;
  game.source.y = 0;
  game.source.w = 960;
  game.source.h = 720;

  game.destination.x = 0;
  game.destination.y = 0;
  game.destination.w = 640;
  game.destination.h = 480;

#ifdef __EMSCRIPTEN__
  const int fps = 0;
  emscripten_set_main_loop_arg(update, &game, fps, 1);
#else
  while (1) {
    update(&game);
//    SDL_Delay(time_to_next_frame());
  }
#endif

  SDL_FreeSurface(game.sprite);
  SDL_Quit();
  return 0;
}
