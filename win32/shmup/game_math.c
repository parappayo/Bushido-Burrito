
#include "game_math.h"

#include <math.h>  // TODO: make math.h unnecessary

/**
 *  Supposedly very fast approxmiation of sqrt, found here:
 *
 *    http://www.codemaestro.com/reviews/9
 *
 *  Uses Newton's method for approximation of roots, with a
 *  carefully chosen initial guess constant.
 */
float game_sqrt(float x)
{
    float xhalf = 0.5f * x;
    int i = *(int*)&x;
    i = 0x5f375a86 - (i>>1);
    x = *(float*)&i;
    x = x * (1.5f - xhalf*x*x);
    return x;
}

float game_sin(float x)
{
    // TODO: implement optimized version
    return sin(x);
}

float game_cos(float x)
{
    // TODO: implement optimized version
    return cos(x);
}
