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

// functions declarations
void create_sums_array(long int number_of_days, long int *days, long int *sums);
long int find_solution(long int number_of_days, int number_of_hospitals, long int *days, long int *sums);

// creates an array of sums like this 
// sums[0] = days[0]
// sums[1] = days[0] + days[1]
// sums[2] = days[0] + days[1] + days[2] etc
void create_sums_array(long int number_of_days, long int *days, long int *sums) {

    // create_sums_array declarations
    int i;

    for (i = 0; i < number_of_days; i++) {
        if (i == 0) {
            sums[i] = days[i];
        }
        else {
            sums[i] = sums[i-1] + days[i];
        }
    }
}

// where the magic happens
long int find_solution(long int number_of_days, int number_of_hospitals, long int *days, long int *sums) {
    
    // find_solution declarations
    long int start, end, average;

    // find_solution initializations
    start = 0;
    end = number_of_days - 1;


    while (start <= end) {
        if (start == 0) {
            average = sums[end] / ((end - start + 1) * number_of_hospitals);
        }
        else {
            average = (sums[end] - sums[start - 1]) / ((end - start + 1) * number_of_hospitals);
        }
        if (average > -1) {
            if (days[end] >= days[start]) {
                end--;
            }
            else {
                start++;
            }
        }
        else {
            printf("Start: %li and End: %li\n", start, end);
            return (end - start + 1);
        }
    }
    //if the loop ends, it means there isn't a "good" period
    printf("Start: %li and End: %li\n", start, end);
    return (0);
}

// input reading, memory allocation and function calling
int main(int argc,char *argv[]) {

    // declarations
    FILE *fp;
    int i, ret, number_of_hospitals;
    long int number_of_days, *days, *sums, result;

    // file opening, input reading and memory allocation
    fp = fopen(argv[1], "r");
    if (fp == NULL) {
        printf("Error Reading File\n");
    }

    // read how many are the numbers
    ret = fscanf(fp, "%li", &number_of_days);
    if (ret == 0) {
        printf("No numbers!\n");
    }

    // malloc for N times memory slots
    days = malloc(sizeof(long int) * number_of_days);
    sums = malloc(sizeof(long int) * number_of_days);
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
    memset(days, 0, sizeof(long int) * number_of_days);
    memset(sums, 0, sizeof(long int) * number_of_days);
    // now our arrays contains all zeroes

    ret = fscanf(fp, "%d", &number_of_hospitals);
    if (ret == 0) {
        printf("No hospitals!\n");
    }

    // read numbers and powers
    for (i = 0; i < number_of_days; i++) {
        ret = fscanf(fp, "%li", &days[i]);
    }

    // close input file
    fclose(fp);

    // call find solution function
    create_sums_array(number_of_days, days, sums);
    result = find_solution(number_of_days, number_of_hospitals, days, sums);
    printf("The result is: %li\n\n", result);


    // testing
    printf("Number of days %li\n", number_of_days);
    printf("Number of hospitals %d\n", number_of_hospitals);
    printf("Number of patients getting in or out:\n");
    for (i = 0; i < number_of_days; i++) {
        printf("%li\t", days[i]);
    }
    printf("\n");
    printf("Array of sums:\n");
    for (i = 0; i < number_of_days; i++) {
        printf("%li\t", sums[i]);
    }
    printf("\n");

    // freeing memory
    free(days);
    free(sums);

    return(0);
}