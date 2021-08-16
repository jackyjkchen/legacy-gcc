#include <math.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>

#if defined(_WIN32)
#include <windows.h>
#include <conio.h>
#else
#include <termios.h>
#endif

static uint32_t unif_random(uint32_t n) {
    static int32_t seeded = 0;

    if(!seeded) {
        srand(time(NULL));
        seeded = 1;
    }

    return rand() % n;
}

#if defined(_WIN32)
void clear_screen()
{
  HANDLE                     hStdOut;
  CONSOLE_SCREEN_BUFFER_INFO csbi;
  DWORD                      count;
  DWORD                      cellCount;
  COORD                      homeCoords = { 0, 0 };

  hStdOut = GetStdHandle( STD_OUTPUT_HANDLE );
  if (hStdOut == INVALID_HANDLE_VALUE) return;

  /* Get the number of cells in the current buffer */
  if (!GetConsoleScreenBufferInfo( hStdOut, &csbi )) return;
  cellCount = csbi.dwSize.X *csbi.dwSize.Y;

  /* Fill the entire buffer with spaces */
  if (!FillConsoleOutputCharacter(
    hStdOut,
    (TCHAR) ' ',
    cellCount,
    homeCoords,
    &count
    )) return;

  /* Fill the entire buffer with the current colors and attributes */
  if (!FillConsoleOutputAttribute(
    hStdOut,
    csbi.wAttributes,
    cellCount,
    homeCoords,
    &count
    )) return;

  /* Move the cursor home */
  SetConsoleCursorPosition( hStdOut, homeCoords );
}
#else
#define clear_screen()  printf("\033[2J\033[H");
#endif

struct term_state
{
#ifndef _WIN32
    struct termios oldt, newt;
#endif
};

void term_init(struct term_state *s)
{
#ifndef _WIN32
    tcgetattr(STDIN_FILENO, &s->oldt);
    s->newt = s->oldt;
    s->newt.c_lflag &= ~(ICANON | ECHO);
    tcsetattr(STDIN_FILENO, TCSANOW, &s->newt);
#endif
}

void term_clear(struct term_state *s)
{
#ifndef _WIN32
    tcsetattr(STDIN_FILENO, TCSANOW, &s->oldt);
#endif
}

int get_ch()
{
#if defined(_WIN32)
    return _getch();
#else
    return getchar();
#endif
}

#ifndef MiN
#define MIN(a,b) (((a)<(b))?(a):(b))
#endif

typedef uint64_t board_t;
typedef uint16_t row_t;

static const board_t ROW_MASK = 0xFFFFULL;
static const board_t COL_MASK = 0x000F000F000F000FULL;

typedef int32_t (*get_move_func_t)(board_t);

static inline board_t unpack_col(row_t row) {
    board_t tmp = row;
    return (tmp | (tmp << 12ULL) | (tmp << 24ULL) | (tmp << 36ULL)) & COL_MASK;
}

static inline row_t reverse_row(row_t row) {
    return (row >> 12) | ((row >> 4) & 0x00F0)  | ((row << 4) & 0x0F00) | (row << 12);
}

static void print_board(board_t board) {
    int i,j;
    printf("-----------------------------\n");
    for(i=0; i<4; i++) {
        for(j=0; j<4; j++) {
            uint8_t powerVal = (board) & 0xf;
            printf("|%6u", (powerVal == 0) ? 0 : 1 << powerVal);
            board >>= 4;
        }
        printf("|\n");
    }
    printf("-----------------------------\n");
}

/* Transpose rows/columns in a board:
   0123       048c
   4567  -->  159d
   89ab       26ae
   cdef       37bf
*/
static board_t transpose(board_t x)
{
    board_t a1 = x & 0xF0F00F0FF0F00F0FULL;
    board_t a2 = x & 0x0000F0F00000F0F0ULL;
    board_t a3 = x & 0x0F0F00000F0F0000ULL;
    board_t a = a1 | (a2 << 12) | (a3 >> 12);
    board_t b1 = a & 0xFF00FF0000FF00FFULL;
    board_t b2 = a & 0x00FF00FF00000000ULL;
    board_t b3 = a & 0x00000000FF00FF00ULL;
    return b1 | (b2 >> 24) | (b3 << 24);
}

static int count_empty(board_t x)
{
    x |= (x >> 2) & 0x3333333333333333ULL;
    x |= (x >> 1);
    x = ~x & 0x1111111111111111ULL;
    x += x >> 32;
    x += x >> 16;
    x += x >>  8;
    x += x >>  4;
    return x & 0xf;
}

/* We can perform state lookups one row at a time by using arrays with 65536 entries. */

/* Move tables. Each row or compressed column is mapped to (oldrow^newrow) assuming row/col 0.
 *
 * Thus, the value is 0 if there is no move, and otherwise equals a value that can easily be
 * xor'ed into the current board state to update the board. */
static row_t *row_left_table = 0;
static row_t *row_right_table = 0;
static board_t *col_up_table = 0;
static board_t *col_down_table = 0;
static uint32_t *score_table = 0;
#define TABLESIZE 65536

void init_tables() {
    uint32_t row = 0, rev_row = 0;
    row_t result = 0, rev_result = 0;

    row_left_table = (row_t *)malloc(TABLESIZE * sizeof(row_t));
    row_right_table = (row_t *)malloc(TABLESIZE * sizeof(row_t));
    col_up_table = (board_t *)malloc(TABLESIZE * sizeof(board_t));
    col_down_table = (board_t *)malloc(TABLESIZE * sizeof(board_t));
    score_table = (uint32_t *)malloc(TABLESIZE * sizeof(uint32_t));
    if (!row_left_table || !row_right_table || !col_up_table || !col_down_table || !score_table) {
        printf("No enough memory!");
        exit(-1);
    }
    memset(row_left_table, 0x00, TABLESIZE * sizeof(row_t));
    memset(row_right_table, 0x00, TABLESIZE * sizeof(row_t));
    memset(col_up_table, 0x00, TABLESIZE * sizeof(board_t));
    memset(col_down_table, 0x00, TABLESIZE * sizeof(board_t));
    memset(score_table, 0x00, TABLESIZE * sizeof(uint32_t));

    for (row = 0; row < 65536; ++row) {
        uint32_t line[4] = {
                (row >>  0) & 0xf,
                (row >>  4) & 0xf,
                (row >>  8) & 0xf,
                (row >> 12) & 0xf
        };

        int32_t score = 0;
        int i = 0;

        for (i = 0; i < 4; ++i) {
            int32_t rank = line[i];
            if (rank >= 2) {
                score += (rank - 1) * (1 << rank);
            }
        }
        score_table[row] = score;

        for (i = 0; i < 3; ++i) {
            int j;
            for (j = i + 1; j < 4; ++j) {
                if (line[j] != 0) break;
            }
            if (j == 4) break;

            if (line[i] == 0) {
                line[i] = line[j];
                line[j] = 0;
                i--;
            } else if (line[i] == line[j]) {
                if(line[i] != 0xf) {
                    /* Pretend that 32768 + 32768 = 32768 (representational limit). */
                    line[i]++;
                }
                line[j] = 0;
            }
        }

        result = (line[0] <<  0) |
                       (line[1] <<  4) |
                       (line[2] <<  8) |
                       (line[3] << 12);
        rev_result = reverse_row(result);
        rev_row = reverse_row(row);

        row_left_table [    row] =                row  ^                result;
        row_right_table[rev_row] =            rev_row  ^            rev_result;
        col_up_table   [    row] = unpack_col(    row) ^ unpack_col(    result);
        col_down_table [rev_row] = unpack_col(rev_row) ^ unpack_col(rev_result);
    }
}

void free_tables() {
    free(row_left_table);
    free(row_right_table);
    free(col_up_table);
    free(col_down_table);
    free(score_table);
}

static board_t execute_move_col(board_t board, board_t *table) {
    board_t ret = board;
    board_t t = transpose(board);
    ret ^= table[(t >>  0) & ROW_MASK] <<  0;
    ret ^= table[(t >> 16) & ROW_MASK] <<  4;
    ret ^= table[(t >> 32) & ROW_MASK] <<  8;
    ret ^= table[(t >> 48) & ROW_MASK] << 12;
    return ret;
}


static board_t execute_move_row(board_t board, row_t *table) {
    board_t ret = board;
    ret ^= (board_t)(table[(board >>  0) & ROW_MASK]) <<  0;
    ret ^= (board_t)(table[(board >> 16) & ROW_MASK]) << 16;
    ret ^= (board_t)(table[(board >> 32) & ROW_MASK]) << 32;
    ret ^= (board_t)(table[(board >> 48) & ROW_MASK]) << 48;
    return ret;
}

/* Execute a move. */
static board_t execute_move(int32_t move, board_t board) {
    switch(move) {
    case 0:
        return execute_move_col(board, col_up_table);
    case 1:
        return execute_move_col(board, col_down_table);
    case 2:
        return execute_move_row(board, row_left_table);
    case 3:
        return execute_move_row(board, row_right_table);
    default:
        return ~0ULL;
    }
}

static uint32_t score_helper(board_t board, const uint32_t* table) {
    return table[(board >>  0) & ROW_MASK] +
           table[(board >> 16) & ROW_MASK] +
           table[(board >> 32) & ROW_MASK] +
           table[(board >> 48) & ROW_MASK];
}

static uint32_t score_board(board_t board) {
    return score_helper(board, score_table);
}

int32_t ask_for_move(board_t board) {
    print_board(board);

    while(1) {
        char movechar;
        const char *allmoves = "wsadkjhl";

        movechar = get_ch();

        if (movechar == 'q') {
            return -1;
        }
        if(!strchr(allmoves, movechar)) {
            continue;
        }

        return (strchr(allmoves, movechar) - allmoves) % 4;
    }
}

static board_t draw_tile() {
    return (unif_random(10) < 9) ? 1 : 2;
}

static board_t insert_tile_rand(board_t board, board_t tile) {
    int index = unif_random(count_empty(board));
    board_t tmp = board;
    while (1) {
        while ((tmp & 0xf) != 0) {
            tmp >>= 4;
            tile <<= 4;
        }
        if (index == 0) break;
        --index;
        tmp >>= 4;
        tile <<= 4;
    }
    return board | tile;
}

static board_t initial_board() {
    board_t board = draw_tile() << (4 * unif_random(16));
    return insert_tile_rand(board, draw_tile());
}

void play_game(get_move_func_t get_move) {
    board_t board = initial_board();
    int32_t moveno = 0;
    int32_t scorepenalty = 0;
    uint32_t last_score = 0, current_score = 0;
    struct term_state s;

    term_init(&s);

    while(1) {
        int32_t move;
        board_t newboard, tile;

        clear_screen();
        for(move = 0; move < 4; move++) {
            if(execute_move(move, board) != board)
                break;
        }
        if(move == 4)
            break;

        current_score = score_board(board) - scorepenalty;
        printf("\nMove #%d, current score=%u(+%u)\n", ++moveno, current_score, current_score - last_score);
        last_score = current_score;

        move = get_move(board);
        if(move < 0)
            break;

        newboard = execute_move(move, board);
        if(newboard == board) {
            moveno--;
            continue;
        }

        tile = draw_tile();
        if (tile == 2) scorepenalty += 4;
        board = insert_tile_rand(newboard, tile);
    }

    print_board(board);
    printf("\nGame over. Your score is %u.\n", current_score);
    term_clear(&s);
}

int main(int argc, char **argv) {
    init_tables();
    play_game(ask_for_move);
    free_tables();
    return 0;
}

