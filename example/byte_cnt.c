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
#if defined(_MSC_VER) || defined(__BORLANDC__) || defined(__WATCOMC__)
static unsigned __int64 max_count = 0;
static unsigned __int64 count[256] = { 0 };
#else
static unsigned long long max_count = 0;
static unsigned long long count[256] = { 0 };
#endif
#else
static unsigned long max_count = 0;
static unsigned long count[256] = { 0 };
#endif
static unsigned char overflow[256] = { 0 };

static void read_file(const char *filename) {
    unsigned char buf[BUFSIZ];
    FILE *fp = fopen(filename, "rb");

    if (fp == NULL) {
        perror("Open file failed");
        exit(-1);
    }

    memset(buf, 0x00, BUFSIZ);
    while (1) {
        size_t i = 0, rd_len = 0;

        rd_len = fread(buf, 1, BUFSIZ, fp);
        if (rd_len == 0) {
            break;
        }
        for (i = 0; i < rd_len; ++i) {
            unsigned char pos = buf[i];

            count[pos]++;
            if (count[pos] == 0) {
                fprintf(stderr, "0x%02X count overflow!\n", pos);
                overflow[pos] = 1;
            }
        }
    }
    fclose(fp);
}

static void print_number(void) {
    int i = 0;

    puts("Statistics:");
    for (i = 0; i < 256; ++i) {
        const char *msg = "";

        if (overflow[i] != 0) {
            msg = " overflow!";
        }
#if _WIN64
/* Windows LLP64 model, long == 32bit, only long long == 64bit */
        printf(" 0x%02X  %llu%s\r\n", i, (unsigned __int64)(count[i]), msg);
#elif COUNT64
/* Support 64bit count in 32bit platform */
#if defined(_MSC_VER) || defined(__BORLANDC__) || defined(__WATCOMC__)
        printf(" 0x%02X  %llu%s\r\n", i, (unsigned __int64)(count[i]), msg);
#elif
        printf(" 0x%02X  %llu%s\n", i, (unsigned long long)(count[i]), msg);
#endif
#else
/* Posix LP64 model, unsigned long == wordsize == size_t */
/* Windowsy 32bit platform, unsigned long == size_t == 32bit */
/* WIN/DOS 16bit platform, unsigned long > unsigned int == size_t == 16bit */
        printf(" 0x%02X  %lu%s\n", i, (unsigned long)(count[i]), msg);
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
        char syms[80];
        int len = (int)(73 * ((double)count[i] / (double)max_count));

        memset(syms, '+', len);
        syms[len] = 0x00;
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