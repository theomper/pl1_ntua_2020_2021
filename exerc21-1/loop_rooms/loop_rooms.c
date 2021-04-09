// FILENAME : loop_rooms.c
// DESCRIPTION : exerc21-1 / pl1-ntua
// AUTHOR : Theo Mper & Alex Tsaf
// COMPILE COMMAND : gcc -std=c99 -Wall -Werror -O3 -o loop_rooms loop_rooms.c
// EXECUTE COMMAND : ./loop_rooms input.file
// EXTERNAL USED CODE :

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Input reading, memory allocation and function calling
int main(int argc,char *argv[]) {

    // Declarations
    FILE *fp;
    int i, j, rows = 0, columns = 0;

    //Unsigned char **grid;
    int ret = 0;
    unsigned char grid[1002][1002];

    // File opening, input reading and memory allocation
    fp = fopen(argv[1], "r");
    if (fp == NULL) {
        printf("Error Reading File\n");
    }

       // Read how many are the rows
    ret = fscanf(fp, "%d", &rows);
    if (ret == 0) {
        printf("No rows!\n");
    }
    printf("Rows: %d\n", rows);

    ret = fscanf(fp, "%d", &columns);
    if (ret == 0) {
        printf("No columns!\n");
    }
    printf("Columns: %d\n", columns);

    fgetc(fp);

    for (i = 0; i < rows; i++) {
        for (j = 0; j < columns; j++) {
            // read grid and insert Qnodes for matter ('+') or anti-matter ('-')
            ret = fscanf(fp, "%c", &grid[i][j]);
        }
        fgetc(fp);
    }

    // Close input file
    fclose(fp);

    for (i = 0; i < rows + 1; i++) {
        for (j = 0; j < columns + 1; j++) {
            printf("%c", grid[i][j]);
        }
        printf("\n");
    }


    return (0);
}