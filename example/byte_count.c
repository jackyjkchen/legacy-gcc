#ifdef _WIN32
#define _CRT_SECURE_NO_WARNINGS
#endif
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static size_t count[256] = { 0 };

static size_t max_count = 0;

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

static void print_number() {
    int i = 0;

    puts("Statistics:");
    for (i = 0; i < 256; ++i) {
#if __STDC_VERSION__ >= 199901L
/* Use C99 standard %zu for size_t */
        printf(" 0x%02X  %zu\n", i, count[i]);
#elif _WIN64
/* Windows LLP64 model, long == 32bit, only long long == 64bit */
        printf(" 0x%02X  %llu\r\n", i, (unsigned __int64)count[i]);
#else
/* Posix LP64 model, unsigned long == wordsize == size_t */
/* Windowsy 32bit platform, unsigned long == size_t == 32bit */
/* WIN/DOS 16bit platform, unsigned long > unsigned int == size_t == 16bit */
        printf(" 0x%02X  %lu\n", i, (unsigned long)count[i]);
#endif
        if (max_count < count[i]) {
            max_count = count[i];
        }
    }
}

static void print_histogram() {
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
        fprintf(stderr, "Usage: ./byte_count <file>\n");
        return -1;
    }

    read_file(argv[1]);
    print_number();
    puts("");
    print_histogram();
}
