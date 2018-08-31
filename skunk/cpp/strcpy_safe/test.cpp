
#include <assert.h>
#include <string.h>

#include "strcpy_safe.h"

int main(void)
{
	const char* test_str = "short test data";
	const char* long_test_str = "quite a bit longer test data, nah nah nah nah nah nah nah";
	char test_buffer[20];

	strcpy_safe(test_buffer, test_str);
	assert(strlen(test_buffer) == strlen(test_str));

	strcpy_safe(test_buffer, long_test_str);
	assert(test_buffer[sizeof(test_buffer)-1] == '\0');
}
