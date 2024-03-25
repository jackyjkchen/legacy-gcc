#include <stddef.h>
#include <stdio.h>

class Foo {
public:
    Foo() : m_str(NULL) {
        printf("ctors\n");
    }
    Foo(const char* const str) : m_str(str) {
        printf("%s: ctors\n", m_str);
    }
    ~Foo() {
		if (m_str) {
	        printf("%s: dtors\n", m_str);
		} else {
	        printf("dtors\n");
		}
    }
private:
    const char* const m_str;
};

Foo g_foo("g_foo");

static Foo s_foo("s_foo");

int main() {
	static Foo foo;
}
