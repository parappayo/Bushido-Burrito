
#include "load_png.h"

#include <malloc.h>

// http://blog.nobel-joergensen.com/2010/11/07/loading-a-png-as-texture-in-opengl-using-libpng/
bool load_png(const char* filename, int* out_width, int* out_height, bool* out_has_alpha, GLubyte** out_data)
{
    FILE* fp = fopen(filename, "rb");
    if (!fp) { return false; }

    png_structp png_ptr = png_create_read_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);
    if (!png_ptr) {
        fclose(fp);
        return false;
    }

    png_infop info_ptr;
    info_ptr = png_create_info_struct(png_ptr);
    if (!info_ptr) {
        png_destroy_read_struct(&png_ptr, png_infopp_NULL, png_infopp_NULL);
        fclose(fp);
        return false;
    }

    // error handler for invalid png data
    if (setjmp(png_jmpbuf(png_ptr))) {
        png_destroy_read_struct(&png_ptr, &info_ptr, png_infopp_NULL);
        fclose(fp);
        return false;
    }

    png_init_io(png_ptr, fp);

    unsigned int sig_read = 0;
    png_set_sig_bytes(png_ptr, sig_read);

    png_read_png(png_ptr, info_ptr, PNG_TRANSFORM_STRIP_16 | PNG_TRANSFORM_PACKING | PNG_TRANSFORM_EXPAND, png_voidp_NULL);

    *out_width = info_ptr->width;
    *out_height = info_ptr->height;

    switch (info_ptr->color_type) {
        case PNG_COLOR_TYPE_RGBA:
            *out_has_alpha = true;
            break;
        case PNG_COLOR_TYPE_RGB:
            *out_has_alpha = false;
            break;
        default:
            // unsupported color type
            png_destroy_read_struct(&png_ptr, &info_ptr, png_infopp_NULL);
            fclose(fp);
            return false;
    }

    unsigned int row_bytes = png_get_rowbytes(png_ptr, info_ptr);
    *out_data = (unsigned char*) malloc(row_bytes * info_ptr->height);

    png_bytepp row_pointers = png_get_rows(png_ptr, info_ptr);

    for (int i = 0; i < info_ptr->height; i++) {
        // png is ordered top to bottom, OpenGL is ordered bottom to top
        memcpy(*out_data+(row_bytes * (info_ptr->height-1-i)), row_pointers[i], row_bytes);
    }

    png_destroy_read_struct(&png_ptr, &info_ptr, png_infopp_NULL);
    fclose(fp);
    return true;
}
