#include <stdio.h>

class Foo {
public:
    Foo() {
        printf("ctors\n");
    }
    ~Foo() {
        printf("dtors\n");
    }
};

int main() {
    static Foo foo;
}
