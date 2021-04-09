// FILENAME : longest.c
// DESCRIPTION : exerc21-1 / pl1-ntua
// AUTHOR : Theo Mper & Alex Tsaf
// COMPILE COMMAND : gcc -std=c99 -Wall -Werror -O3 -o longest longest.c
// EXECUTE COMMAND : ./longest input.file
// EXTERNAL USED CODE : https://www.geeksforgeeks.org/longest-subarray-having-average-greater-than-or-equal-to-x/
//                      https://stackoverflow.com/questions/35803677/comparing-two-dimensional-array-for-qsort
//                      https://stackoverflow.com/questions/17638499/using-qsort-to-sort-an-array-of-long-long-int-not-working-for-large-nos/26428052
//                      https://www.geeksforgeeks.org/compute-the-minimum-or-maximum-max-of-two-integers-without-branching/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <limits.h>

// returns only -1, 0 or 1 depensing the comparison
int compare ( const void *pa, const void *pb ) {
    const long int *a = *(const long int **)pa;
    const long int *b = *(const long int **)pb;
    if(a[0] == b[0]) {
        // return a[1] - b[1];
        if ((a[1] - b[1]) < 0) {
            return -1;
        }
        else if ((a[1] - b[1]) > 0) {
            return 1;
        }
        else {
            return a[1] - b[1];
        }
    }
    else {
        // return a[0] - b[0];
        if ((a[0] - b[0]) < 0) {
            return -1;
        }
        else if ((a[0] - b[0]) > 0) {
            return 1;
        }
        else {
            return a[0] - b[0];
        }
    }
}

// Function to find index in preSum vector upto which
// all prefix sum values are less than or equal to val.
int find_ind(long int **presum, int n, int val) {
  
    // Starting and ending index of search space.
    long int l = 0;
    long int h = n - 1;
    long int mid;
  
    // To store required index value.
    long int ans = -1;
  
    // If middle value is less than or equal to
    // val then index can lie in mid+1..n
    // else it lies in 0..mid-1.
    while (l <= h) {
        mid = (l + h) / 2;
        if (presum[mid][0] <= val) {
            ans = mid;
            l = mid + 1;
        }
        else {
            h = mid - 1;
        }
    }
  
    return ans;
}

/*Function to find minimum of x and y*/
long int min(long int x,long int y) {
    return y ^ ((x ^ y) & -(x < y));
}

// Function to find maximum of x and y
long int max(long int x,long int y) {
    return x ^ ((x ^ y) & -(x < y));
}

// Function to find the length of the longest subarray with average >= x
long int longest_subarray(long int number_of_days, int number_of_hospitals, long int *days) {

    // declarations
    long int i, maxlen, sum, *min_indx;

    // Update array by subtracting x from each element.
    for (i = 0; i < number_of_days; i++) {
        days[i] -= number_of_hospitals;
    }

    // Length of Longest subarray.
    maxlen = 0;

    // 2d array to store pair of prefix sum and corresponding ending index value.
    long int **presum = (long int **)malloc(number_of_days * sizeof(long int *));
    if (!presum) { /* If N == 0 after the call to malloc, allocation failed for some reason */
        perror("Error allocating memory for N");
        abort();
    }
    for (i = 0; i < number_of_days; i++) {
        presum[i] = (long int *)malloc(2 * sizeof(long int));
    }

    // To store current value of prefix sum.
    sum = 0;

    // To store minimum index value in range 0..i of preSum vector.
    min_indx = malloc(sizeof(long int) * number_of_days);
    if (!min_indx) { /* If N == 0 after the call to malloc, allocation failed for some reason */
        perror("Error allocating memory for N");
        abort();
    }

    // Insert values in preSum vector.
    for (i = 0; i < number_of_days; i++) {
        sum = sum + days[i];
        presum[i][0] = sum;
        presum[i][1] = i;
    }

    qsort(presum, number_of_days, sizeof presum[0], compare);

    // Update minInd array.
    min_indx[0] = presum[0][1];

    for (i = 1; i < number_of_days; i++) {
        min_indx[i] = min(min_indx[i - 1], presum[i][1]);
    }

    sum = 0;
    for (i = 0; i < number_of_days; i++) {
        sum = sum + days[i];
  
        // If sum is greater than k, then answer
        // is i+1.
        if (sum > number_of_hospitals) {
            maxlen = i + 1;
        }

        // If the sum is less than or equal to k, then
        // find if there is a prefix array having sum
        // that needs to be added to the current sum to
        // make its value greater than k. If yes, then
        // compare the length of updated subarray with
        // maximum length found so far.
        else {
            long int ind = find_ind(presum, number_of_days, sum - number_of_hospitals - 1);
            if (ind != -1 && min_indx[ind] < i) {
                maxlen = max(maxlen, i - min_indx[ind]);
            }
        }
    }

    free(*presum);
  
    return maxlen;
}

// input reading, memory allocation and function calling
int main(int argc,char *argv[]) {

    // declarations
    FILE *fp;
    long int i, ret, number_of_hospitals, number_of_days, *days, result;

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
    if (!days) { /* If N == 0 after the call to malloc, allocation failed for some reason */
        perror("Error allocating memory for N");
        abort();
    }

    // at this point, we know that N and K points to a valid block of memory.
    // however this memory may contains garbage.
    memset(days, 0, sizeof(long int) * number_of_days);
    // now our arrays contains all zeroes

    ret = fscanf(fp, "%li", &number_of_hospitals);
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
    for (i = 0; i < number_of_days; i++) {
        days[i] = -days[i];
    }

    result = longest_subarray(number_of_days, number_of_hospitals, days);
    printf("%li\n", result);

    free(days);

    return(0);
}