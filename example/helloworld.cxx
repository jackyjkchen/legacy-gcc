#include <stdio.h>

class HelloWorld {
public:
    static print() {
        printf("hello, world\n");
    }
};

int main()
{
    HelloWorld::print();
    return 0;
}
