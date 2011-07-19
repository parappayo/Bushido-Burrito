//------------------------------------------------------------------------------
//  input.h - simple DOS input handling
//------------------------------------------------------------------------------

#ifndef __INPUT_H__
#define __INPUT_H__

#define NUM_KEYS 128

void init_input(void);
void fin_input(void);
unsigned char is_key_down(unsigned char key_code);

// common key codes
#define KEY_ESC			1
#define KEY_ENTER		28
#define KEY_UP			71
#define KEY_LEFT		75
#define KEY_RIGHT		77
#define KEY_DOWN		80

#endif // __INPUT_H__

