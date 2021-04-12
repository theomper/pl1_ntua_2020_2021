// FILENAME : loop_rooms.c
// DESCRIPTION : exerc21-1 / pl1-ntua
// AUTHOR : Theo Mper & Alex Tsaf
// COMPILE COMMAND : gcc -std=c99 -Wall -Werror -O3 -o loop_rooms loop_rooms.c
// EXECUTE COMMAND : ./loop_rooms input.file
// EXTERNAL USED CODE : -

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

unsigned char rooms[1002][1002];
int visited[1002][1002], fairness[1002][1002];

int fairbox(int ix, int jx, int rows, int columns) {

    if (visited[ix][jx] == 1 && fairness[ix][jx] == -1) {
        fairness[ix][jx] = 0;
        return 0;
    }
      if (fairness[ix][jx] != -1) {
        return fairness[ix][jx];
    }

    if (((ix == 1) && rooms[ix][jx] == 'U') 
        || ((ix == rows) && rooms[ix][jx] == 'D') 
        || ((jx == 1) && rooms[ix][jx] == 'L') 
        || ((jx == columns) && rooms[ix][jx] == 'R')) {
        visited[ix][jx] = 1;
        fairness[ix][jx] = 1;
        return 1;
    }
  
    switch (rooms[ix][jx]) {
        case 'U':visited[ix][jx] = 1;
        	fairness[ix][jx] = fairbox(ix - 1, jx, rows, columns);
                    return fairness[ix - 1][jx];
                    break;
        case 'D':  visited[ix][jx] = 1;
        	 fairness[ix][jx] = fairbox(ix + 1, jx, rows, columns);
                    return fairness[ix + 1][jx];
                    break;
        case 'L':   visited[ix][jx] = 1;
        	fairness[ix][jx] = fairbox(ix, jx - 1, rows, columns);
                    return fairness[ix][jx - 1];
                    break;
        case 'R':   visited[ix][jx] = 1;
		     fairness[ix][jx] = fairbox(ix, jx + 1, rows, columns);
                    return fairness[ix][jx + 1];
                    break;
        default: break;
    }

    return fairness[ix][jx];
}

// Input reading, memory allocation and function calling
int main(int argc,char *argv[]) {

    // Declarations
    FILE *fp;
    int i, j, rows = 0, columns = 0;

    //Unsigned char **rooms;
    int ret = 0;
    // unsigned char rooms[1000][1000], visited[1000][1000], fairness[1000][1000];

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

    ret = fscanf(fp, "%d", &columns);
    if (ret == 0) {
        printf("No columns!\n");
    }

    char c;
    ret=fscanf(fp,"%c",&c);

    for (i = 0; i <= rows + 1; i++) {
        for (j = 0; j <= columns + 1; j++) {
            if (i == 0 || j == 0 || i == rows + 1 || j == columns + 1) {
                rooms[i][j] = 'X';
            }
        }
    }

    for (i = 1; i < rows + 1; i++) {
        for (j = 1; j < columns + 1; j++) {
            ret = fscanf(fp, "%c", &rooms[i][j]);
            visited[i][j] = 0;
            fairness[i][j] = -1;
        }
        fgetc(fp);
    }

    // Close input file
    fclose(fp);

    //for (i = 0; i < rows + 2; i++) {
    //    for (j = 0; j < columns + 2; j++) {
    //       printf("%c", rooms[i][j]);
    //    }
    //    printf("\n");
   // }

    // Find fairbox
     for (i = 1; i < rows + 1; i++) {
        for (j = 1; j < columns + 1; j++) {
            fairbox(i, j, rows, columns);
        }
    }

    int counter = 0;
    // Counting the unfair rooms
    for (i = 1; i < rows + 1; i++) {
        for (j = 1; j < columns + 1; j++) {
            if(fairness[i][j]==0) counter++;
        }
    }
    printf("%d\n", counter);
    // for (i = 1; i < rows; i++) {
    //         printf("%d%d %c",i,j, rooms[i][j]);
    //         }
    //   printf("\n");
    // }
    // for (i = 0; i < rows; i++) {
    //     for (j = 0; j < columns; j++) {
    //         printf("%d", visited[i][j]);
    //     }
    //     printf("\n");
    // }
    // for (i = 1; i < rows+1; i++) {
    //     for (j = 1; j < columns+1; j++) {
    //         printf("%d", fairness[i][j]);
    //     }
    //     printf("\n");
    // }

    return (0);
}
