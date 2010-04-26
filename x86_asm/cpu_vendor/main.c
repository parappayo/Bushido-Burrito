#include <stdio.h>

char* cpu_vendor(void);  // implemented in cpu_vendor.s

int main(void)
{
    printf("%s\n", cpu_vendor());

    return 0;
}

