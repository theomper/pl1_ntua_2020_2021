// FILENAME : longest.c
// DESCRIPTION : exerc21-1 / pl1-ntua
// AUTHOR : Alex Tsaf & Theo Mper
// COMPILE COMMAND : gcc -std=c99 -Wall -Werror -O3 -o longest longest.c
// EXECUTE COMMAND : ./longest input.file
// EXTERNAL USED CODE : 
// TO-DO :  1) read input
//          2) find solution
//          3) print output

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// input reading, memory allocation and function calling
int main(int argc,char *argv[]) {

    // declarations
    FILE *fp;
    int i, ret, number_of_days, number_of_hospitals, *days, *sums;

    // file opening, input reading and memory allocation
    fp = fopen(argv[1], "r");
    if (fp == NULL) {
        printf("Error Reading File\n");
    }

    // read how many are the numbers
    ret = fscanf(fp, "%d", &number_of_days);
    if (ret == 0) {
        printf("No numbers!\n");
    }

    // malloc for N times memory slots
    days = malloc(sizeof(int) * number_of_days);
    sums = malloc(sizeof(int) * number_of_days);
    if (!days) { /* If N == 0 after the call to malloc, allocation failed for some reason */
        perror("Error allocating memory for N");
        abort();
    }
    if (!sums) { /* If K == 0 after the call to malloc, allocation failed for some reason */
        perror("Error allocating memory for K");
        abort();
    }

    // at this point, we know that N and K points to a valid block of memory.
    // however this memory may contains garbage.
    memset(days, 0, sizeof(int) * number_of_days);
    memset(sums, 0, sizeof(int) * number_of_days);
    // now our arrays contains all zeroes

    ret = fscanf(fp, "%d", &number_of_hospitals);
    if (ret == 0) {
        printf("No hospitals!\n");
    }

    // read numbers and powers
    for (i = 0; i < number_of_days; i++) {
        ret = fscanf(fp, "%d", &days[i]);
    }

    // close input file
    fclose(fp);

    // testing
    printf("Number of days %d\n", number_of_days);
    printf("Number of hospitals %d\n", number_of_hospitals);
    for (i = 0; i < number_of_days; i++) {
        printf("%d ", days[i]);
        // 
    }
    printf("\n");

    // freeing memory
    free(days);
    free(sums);

    return(0);
}

