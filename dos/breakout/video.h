//------------------------------------------------------------------------------
//  video.h - simple DOS VGA graphics routines
//------------------------------------------------------------------------------

#ifndef __VIDEO_H__
#define __VIDEO_H__

#define SCREEN_WIDTH  320;
#define SCREEN_HEIGHT 200;
#define MAX_COLOR 256

void set_video_mode(unsigned char mode);
void set_video_page(unsigned char page);
void plot_pixel(unsigned int x, unsigned int y, unsigned char color);

#endif // __VIDEO_H__

