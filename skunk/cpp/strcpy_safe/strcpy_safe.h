/*
 *  strcpy_safe is a simple, safer way to strncpy
 *
 *  https://randomascii.wordpress.com/2013/04/03/stop-using-strncpy-already/
 *
 *  - May overrun the buffer: strcpy, sprintf
 *  - Sometimes null-terminates: strncpy, _snprintf, swprintf, wcsncpy, lstrcpy
 *  - Always null-terminates: snprintf, strlcpy
 */

#include <string.h>

template <size_t len>
void strcpy_safe(char (&dest)[len], const char* src)
{
	strncpy(dest, src, len);
	dest[len - 1] = '\0';
}
