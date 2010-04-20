/*
 *  mbrot.c
 *
 *  Simple plotter for the Mandelbrot set.
 *
 *  License: This code is given over to the public domain.
 *
 *  Optional Dependencies:
 *      - libpng
 *      - zlib
 *  To compile without dependencies, remove the define for ENABLE_PNG.
 *
 *  Sample build line (with dependencies):
 *      gcc mbrot.c -O3 -lpng -o mbrot
 *
 *  Sample batch run (will create lots of files):
 *      ./mbrot -0.74964282030785 0.1249235778865 500 2 45
 */

#define ENABLE_PNG

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#ifdef ENABLE_PNG
#include <png.h>
#endif

/* 1080p resolution is 1920x1080 */
#define SCREEN_WIDTH 1920
#define SCREEN_HEIGHT 1080

/* must fit within t_test_count */
#define TEST_ITERATIONS 255

/* ideally this should be a small data type */
typedef unsigned char t_test_count;

/* may run faster if this is changed to float */
typedef double t_float;

/* values used when no settings are given on the command line */
#define DEFAULT_NUM_FRAMES        1
#define DEFAULT_ORIGIN_X          0.0f
#define DEFAULT_ORIGIN_Y          0.0f
#define DEFAULT_ZOOM              500.0f
#define DEFAULT_ZOOM_STEP_FACTOR  2.0f

/* usage notes */
const char* help_str = "\n\
usage: mbrot [x] [y] [zoom] [step] [frames]\n\
\n\
x - origin x coordinate\n\
y - origin y coordinate\n\
zoom - zoom factor\n\
step - factor to increase the zoom by each frame\n\
frames - number of frames to plot\n\
\n\
Output goes into files named frame000001.png, frame000002.png, etc.\n\
The plotter can be compiled to output pbm format files instead, but this is\n\
not recommended since they are much larger than png files.\n\
\n\
All arguments are optional.  It makes sense to either give no arguments,\n\
three arguments, or five arguments.  If fewer than three arguments are given\n\
they are ignored.  Arguments given in excess of five are ignored.\n\
\n\
Sample command lines follow:\n\
\n\
Render a simple plot:\n\
    ./mbrot\n\
\n\
Render a specific plot:\n\
    ./mbrot -0.74964282030785 0.1249235778865 12500\n\
\n\
Render a batch of forty-five frames:\n\
    ./mbrot -0.74964282030785 0.1249235778865 500 2 45\n\
\n\
This software is a hobby project of Jason Estey.\n\
http://bushidoburrito.com/\n\
\n\
";

/*
 * tests if a given point escapes from the mandlebrot set or not;
 * returns number of iterations the test ran for (up to TEST_ITERATIONS).
 * note: given coordinates are in set space, not screen space
 */ 
t_test_count test_point( t_float x, t_float y )
{
    t_test_count i;
    t_float x0, y0, xtemp;

    x0 = x;
    y0 = y;

    for ( i = 0;
          x*x + y*y <= 4 && i < TEST_ITERATIONS;
          ++i ) {

        xtemp = x*x - y*y + x0;
        y = 2*x*y + y0;
        x = xtemp;
    }

    return i;
}

/*
 * plots a whole screen of mandelbrot set points with given coordinates
 */
void plot_screen( t_test_count* pixel_data,
                  t_float origin_x,
                  t_float origin_y,
                  t_float zoom )
{
    unsigned long int x, y;
    for (x = 0; x < SCREEN_WIDTH; ++x) {
        for (y = 0; y < SCREEN_HEIGHT; ++y) {
            pixel_data[y * SCREEN_WIDTH + x] = test_point(
                origin_x + ((t_float) x - (SCREEN_WIDTH/2)) / zoom,
                origin_y + ((t_float) y - (SCREEN_HEIGHT/2)) / zoom);
        }
    }
}

/*
 * wites a black & white pbm image file of the given pixel data plot;
 * pixel shade depends on number of iterations returned from the test
 * function
 */
void write_pbm1_file( const t_test_count* pixel_data, FILE* out_file )
{
    unsigned long int i;
    char output_str[80];

    sprintf(output_str, "P1\n%d %d", SCREEN_WIDTH, SCREEN_HEIGHT);
    fputs(output_str, out_file);

    for (i = 0; i < SCREEN_WIDTH * SCREEN_HEIGHT; i++) {
        if (i % SCREEN_WIDTH == 0) {
            fputs("\n", out_file);
        }
        if (pixel_data[i] == TEST_ITERATIONS) {
            fputs("1 ", out_file);
        } else {
            fputs("0 ", out_file);
        }
    }
}

/*
 * writes a greyscale pbm image file of the given pixel data plot;
 * pixel shade depends on number of iterations returned from the test function
 */
void write_pbm2_file( const t_test_count* pixel_data, FILE* out_file )
{
    unsigned long int i;
    char output_str[80];

    sprintf(output_str, "P2\n%d %d\n%d",
            SCREEN_WIDTH, SCREEN_HEIGHT,
            TEST_ITERATIONS);
    fputs(output_str, out_file);

    for (i = 0; i < SCREEN_WIDTH * SCREEN_HEIGHT; i++) {
        if (i % SCREEN_WIDTH == 0) {
            fputs("\n", out_file);
        }
        sprintf(output_str, "%d ", pixel_data[i]);
        fputs(output_str, out_file);
    }
}

#ifdef ENABLE_PNG
/*
 * initializes a color palette to use for PNG images, can be written to
 * vary depending on the current frame of a batch job
 */
void create_palette( png_color* palette, unsigned int frame )
{
    unsigned int i;
    png_color base;

    /* each frame we mutate the base color a little */
    if (frame == 0) {
        base.red = (int) (frame*0.05) % 255;
        base.green = (int) (frame*0.07) % 255;
        base.blue = 200 + (int) (frame*0.03) % 255;
    }

    for (i = 0; i < 128; i++) {
        float temp = (float) i / 128.0f;
        palette[i].red = (float) base.red * temp;
        palette[i].green = (float) base.green * temp;
        palette[i].blue = (float) base.blue * temp;
    }
    for (i = 128; i < 256; i++) {
        float temp = (float) (i-128) / 128.0f;
        palette[i].red = base.red + (float) (256-base.red) * temp;
        palette[i].green = base.green + (float) (256-base.green) * temp; 
        palette[i].blue = base.blue + (float) (256-base.blue) * temp;
    }
}
#endif // ENABLE_PNG

/*
 * writes a PNG image file of the given pixel data plot; pixel color depends
 * on the number of iterations returned from the test function
 */
#ifdef ENABLE_PNG
void write_png_file( const t_test_count* pixel_data,
                     png_color* palette,
                     FILE* out_file )
{
    png_structp png_ptr;
    png_infop info_ptr;
    unsigned int i;

    png_ptr = png_create_write_struct(
            PNG_LIBPNG_VER_STRING,
            (png_voidp) NULL,
            NULL,
            NULL );
    if (!png_ptr) {
        fprintf(stderr, "could not allocate memory for png struct\n");
        return;
    }
    info_ptr = png_create_info_struct(png_ptr);
    if (!info_ptr) {
        png_destroy_write_struct(&png_ptr, (png_infopp) NULL);
        fprintf(stderr, "could not allocate memory for png info struct\n");
        return;
    }

    if (setjmp(png_jmpbuf(png_ptr))) {
        png_write_destroy(png_ptr);
        png_destroy_write_struct(&png_ptr, &info_ptr);
        fprintf(stderr, "error with png setjmp\n");
        return;
    }

    png_init_io(png_ptr, out_file);

    png_set_PLTE(png_ptr, info_ptr, palette, 256);

    info_ptr->width = SCREEN_WIDTH;
    info_ptr->height = SCREEN_HEIGHT;
    info_ptr->bit_depth = 8;
    info_ptr->color_type = PNG_COLOR_TYPE_PALETTE;
    png_write_info(png_ptr, info_ptr);

    png_bytep row_pointers[SCREEN_HEIGHT];
    for (i = 0; i < SCREEN_HEIGHT; i++) {
        row_pointers[i] = (png_bytep) &(pixel_data[i * SCREEN_WIDTH]);
    }
    png_write_image(png_ptr, row_pointers);
    png_write_end(png_ptr, info_ptr);

    png_destroy_write_struct(&png_ptr, &info_ptr);
}
#endif // ENABLE_PNG

int main(int argc, char* argv[])
{
    int retval = 0;
    unsigned int frame_count, num_frames;
    t_float origin_x, origin_y, zoom, zoom_step_factor;
    t_test_count *pixel_data;
    FILE* out_file;
    char filename[80];
#ifdef ENABLE_PNG
    png_color palette[256];
#endif

    num_frames = DEFAULT_NUM_FRAMES;
    origin_x = DEFAULT_ORIGIN_X;
    origin_y = DEFAULT_ORIGIN_Y;
    zoom = DEFAULT_ZOOM;
    zoom_step_factor = DEFAULT_ZOOM_STEP_FACTOR;

    if (argc == 2) {
        /* naively assume the user wants help */
        printf(help_str);
        exit(0);
    }

    if (argc > 3) {
        origin_x = atof(argv[1]);
        origin_y = atof(argv[2]);
        zoom = atof(argv[3]);
    }
    if (argc > 5) {
        zoom_step_factor = atof(argv[4]);
        num_frames = atoi(argv[5]);
    }

    pixel_data = malloc(sizeof(t_test_count) * SCREEN_WIDTH * SCREEN_HEIGHT);
    if (pixel_data == NULL) {
        fprintf(stderr, "could not allocate enough memory for pixel data\n");
        exit(1);
    }

    for (frame_count = 0; frame_count < num_frames; frame_count++) {
    
        /* for faster rendering, move the palette call out of the loop */
#ifdef ENABLE_PNG
        create_palette(palette, frame_count);
#endif

        plot_screen(pixel_data, origin_x, origin_y, zoom);
        zoom *= zoom_step_factor;

#ifdef ENABLE_PNG
        sprintf(filename, "frame%.6d.png", frame_count);
#else
        sprintf(filename, "frame%.6d.pbm", frame_count);
#endif
        out_file = fopen(filename, "wb");
        if (out_file == NULL) {
            fprintf(stderr, "could not open output file for writing\n");
            retval = 1;
        } else {
#ifdef ENABLE_PNG
            write_png_file(pixel_data, palette, out_file);
#else
            write_pbm2_file(pixel_data, out_file);
#endif
            fclose(out_file);
        }

    }

    free(pixel_data);
    return retval;
}

