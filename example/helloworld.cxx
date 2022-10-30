#include <stdio.h>

class HelloWorld {
public:
    static void print() {
        printf("hello, world\n");
    }
};

int main() {
    HelloWorld::print();
    return 0;
}
