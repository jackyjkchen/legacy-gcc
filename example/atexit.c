#include <stdlib.h>
#include <stdio.h>

#ifdef __cplusplus              /* the __cplusplus macro is     */
extern "C" void goodbye(void);  /* automatically defined by the  */
#else /* C++/MVS compiler              */
void goodbye(void);
#endif

int main(void) {
    int rc;

    rc = atexit(goodbye);
    if (rc != 0)
        printf("Error in atexit");
    exit(0);
}

void goodbye(void)
   /* This function is called at normal program termination */
{
    printf("The function goodbye was called at program termination\n");
}
