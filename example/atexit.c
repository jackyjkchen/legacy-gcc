#include <stdlib.h>
#include <stdio.h>

#ifdef __cplusplus 
extern "C" void goodbye(void);
#endif

void goodbye(void)
{
    printf("The function goodbye was called at program termination\n");
}

int main(void) {
    int rc;

    rc = atexit(goodbye);
    if (rc != 0)
        printf("Error in atexit");
    exit(0);
}
