#ifdef _WIN32
#define _CRT_SECURE_NO_WARNINGS
#endif
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifdef _WIN64
static unsigned __int64 max_count = 0;
static unsigned __int64 count[256] = { 0 };
#elif COUNT64
static unsigned long long max_count = 0;
static unsigned long long count[256] = { 0 };
#else
static unsigned long max_count = 0;
static unsigned long count[256] = { 0 };
#endif

static void read_file(const char *filename) {
    unsigned char buf[BUFSIZ] = { 0 };
    FILE *fp = fopen(filename, "rb");

    if (fp == NULL) {
        perror("Open file failed");
        exit(-1);
    }

    while (1) {
        size_t i = 0, rd_len = 0;

        rd_len = fread(buf, 1, BUFSIZ, fp);
        if (rd_len == 0) {
            break;
        }
        for (i = 0; i < rd_len; ++i) {
            count[buf[i]]++;
        }
    }
    fclose(fp);
}

static void print_number(void) {
    int i = 0;

    puts("Statistics:");
    for (i = 0; i < 256; ++i) {
#if _WIN64
/* Windows LLP64 model, long == 32bit, only long long == 64bit */
        printf(" 0x%02X  %llu\r\n", i, (unsigned __int64)(count[i]));
#elif COUNT64
/* Support 64bit count in 32bit platform */
        printf(" 0x%02X  %llu\r\n", i, (unsigned long long)(count[i]));
#else
/* Posix LP64 model, unsigned long == wordsize == size_t */
/* Windowsy 32bit platform, unsigned long == size_t == 32bit */
/* WIN/DOS 16bit platform, unsigned long > unsigned int == size_t == 16bit */
        printf(" 0x%02X  %lu\n", i, (unsigned long)(count[i]));
#endif
        if (max_count < count[i]) {
            max_count = count[i];
        }
    }
}

static void print_histogram(void) {
    int i = 0;

    puts("Histogram:");
    for (i = 0; i < 256; ++i) {
        char syms[80] = { 0 };
        memset(syms, '+', (int)(73 * ((double)count[i] / (double)max_count)));
        printf(" 0x%02X  %s\n", i, syms);
    }
}

int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "Usage: ./byte_cnt <file>\n");
        return -1;
    }

    read_file(argv[1]);
    print_number();
    puts("");
    print_histogram();

    return 0;
}
