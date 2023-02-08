#include <stdio.h>

static const char* attr_type[] = {
    "普", "格", "飞", "毒", "地", "岩", "虫", "鬼", "钢", "火", "水", "草", "电", "超", "冰", "龙", "恶", "仙",
};

#define ATTR_NUM (sizeof(attr_type) / sizeof(const char*))

#define ZERO    0
#define ONE     1
#define TWO     2
#define FOUR    4
#define HALF    3
#define QUARTER 9

static const unsigned char attr_table[] = {
/*       普    格    飞    毒    地    岩    虫    鬼    钢    火    水    草    电    超    冰    龙    恶    仙 */
/*普*/  ONE,  ONE,  ONE,  ONE,  ONE, HALF,  ONE, ZERO, HALF,  ONE,  ONE,  ONE,  ONE,  ONE,  ONE,  ONE,  ONE,  ONE,
/*格*/  TWO,  ONE, HALF, HALF,  ONE,  TWO, HALF, ZERO,  TWO,  ONE,  ONE,  ONE,  ONE, HALF,  TWO,  ONE,  TWO, HALF,
/*飞*/  ONE,  TWO,  ONE,  ONE,  ONE, HALF,  TWO,  ONE, HALF,  ONE,  ONE,  TWO, HALF,  ONE,  ONE,  ONE,  ONE,  ONE, 
/*毒*/  ONE,  ONE,  ONE, HALF, HALF, HALF,  ONE, HALF, ZERO,  ONE,  ONE,  TWO,  ONE,  ONE,  ONE,  ONE,  ONE,  TWO, 
/*地*/  ONE,  ONE, ZERO,  TWO,  ONE,  TWO, HALF,  ONE,  TWO,  TWO,  ONE, HALF,  TWO,  ONE,  ONE,  ONE,  ONE,  ONE, 
/*岩*/  ONE, HALF,  TWO,  ONE, HALF,  ONE,  TWO,  ONE, HALF,  TWO,  ONE,  ONE,  ONE,  ONE,  TWO,  ONE,  ONE,  ONE, 
/*虫*/  ONE, HALF, HALF, HALF,  ONE,  ONE,  ONE, HALF, HALF, HALF,  ONE,  TWO,  ONE,  TWO,  ONE,  ONE,  TWO, HALF, 
/*鬼*/ ZERO,  ONE,  ONE,  ONE,  ONE,  ONE,  ONE,  TWO,  ONE,  ONE,  ONE,  ONE,  ONE,  TWO,  ONE,  ONE, HALF,  ONE, 
/*钢*/  ONE,  ONE,  ONE,  ONE,  ONE,  TWO,  ONE,  ONE, HALF, HALF, HALF,  ONE, HALF,  ONE,  TWO,  ONE,  ONE,  TWO, 
/*火*/  ONE,  ONE,  ONE,  ONE,  ONE, HALF,  TWO,  ONE,  TWO, HALF, HALF,  TWO,  ONE,  ONE,  TWO, HALF,  ONE,  ONE, 
/*水*/  ONE,  ONE,  ONE,  ONE,  TWO,  TWO,  ONE,  ONE,  ONE,  TWO, HALF, HALF,  ONE,  ONE,  ONE, HALF,  ONE,  ONE, 
/*草*/  ONE,  ONE, HALF, HALF,  TWO,  TWO, HALF,  ONE, HALF, HALF,  TWO, HALF,  ONE,  ONE,  ONE, HALF,  ONE,  ONE, 
/*电*/  ONE,  ONE,  TWO,  ONE, ZERO,  ONE,  ONE,  ONE,  ONE,  ONE,  TWO, HALF, HALF,  ONE,  ONE, HALF,  ONE,  ONE, 
/*超*/  ONE,  TWO,  ONE,  TWO,  ONE,  ONE,  ONE,  ONE, HALF,  ONE,  ONE,  ONE,  ONE, HALF,  ONE,  ONE, ZERO,  ONE, 
/*冰*/  ONE,  ONE,  TWO,  ONE,  TWO,  ONE,  ONE,  ONE, HALF, HALF, HALF,  TWO,  ONE,  ONE, HALF,  TWO,  ONE,  ONE, 
/*龙*/  ONE,  ONE,  ONE,  ONE,  ONE,  ONE,  ONE,  ONE, HALF,  ONE,  ONE,  ONE,  ONE,  ONE,  ONE,  TWO,  ONE, ZERO, 
/*恶*/  ONE, HALF,  ONE,  ONE,  ONE,  ONE,  ONE,  TWO,  ONE,  ONE,  ONE,  ONE,  ONE,  TWO,  ONE,  ONE, HALF, HALF, 
/*仙*/  ONE,  TWO,  ONE, HALF,  ONE,  ONE,  ONE,  ONE, HALF, HALF,  ONE,  ONE,  ONE,  ONE,  ONE,  TWO,  TWO,  ONE, 
};

static const char* value_string(unsigned char v) {
    if(v == FOUR) {
        return "4x";
    } else if (v == TWO) {
        return "2x";
    } else if (v == ONE || v == TWO * HALF) {
        return "1x";
    } else if (v == HALF) {
        return "1/2x";
    } else if (v == QUARTER) {
        return "1/4x";
    } else if (v == ZERO) {
        return "0x";
    } else {
        return "";
    }
}

static void print_table_header() {
	unsigned int i = 0;
    printf("| 守\\攻 |");
    for (i=0; i<ATTR_NUM; ++i) {
        printf(" %5s |", attr_type[i]);
    }
    printf("\n");
}

static void print_single_attr(unsigned int x) {
	unsigned int i = 0;
	printf("| %s    |", attr_type[x]);
    for (i=0; i<ATTR_NUM; ++i) {
        printf(" %4s |", value_string(attr_table[ATTR_NUM * i + x]));
    }
	printf("\n");
}

static void print_double_attr(unsigned int x, unsigned int y) {
	unsigned int i = 0;
	unsigned char r[ATTR_NUM] = {0};
    if (x == y) {
        return;
    }
	printf("| %s+%s |", attr_type[x], attr_type[y]);
	for(i=0; i<ATTR_NUM; ++i) {
		r[i] = attr_table[ATTR_NUM * i + x] * attr_table[ATTR_NUM * i + y];
	}
	for(i=0; i<ATTR_NUM; ++i) {
		printf(" %4s |", value_string(r[i]));
	}
	printf("\n");
}

static void print_attr_table() {
    unsigned int i = 0, j = 0;
    print_table_header();
    for (i=0; i<ATTR_NUM; ++i) {
        print_single_attr(i);
        for(j=0; j<ATTR_NUM; ++j) {
            print_double_attr(i, j);
        }
    }
}

int main(int argc, char *argv[]) {
    print_attr_table();
    return 0;
}
