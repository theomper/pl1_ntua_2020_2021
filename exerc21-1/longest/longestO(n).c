// FILENAME : longest.c
// DESCRIPTION : exerc21-1 / pl1-ntua
// AUTHOR : Alex Tsaf & Theo Mper
// COMPILE COMMAND : gcc -std=c99 -Wall -Werror -O3 -o longest longest.c
// EXECUTE COMMAND : ./longest input.file
// EXTERNAL USED CODE : https://www.geeksforgeeks.org/longest-subarray-having-average-greater-than-or-equal-to-x-set-2/
//                      https://www.geeksforgeeks.org/compute-the-minimum-or-maximum-max-of-two-integers-without-branching/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <limits.h>

/*Function to find minimum of x and y*/
long int min(long int x,long int y) {
    return y ^ ((x ^ y) & -(x < y));
}

/*Function to find maximum of x and y*/
long int max(long int x,long int y) {
    return x ^ ((x ^ y) & -(x < y));
}

// Utility Function to find the index with maximum difference
long int max_index_diff(long int number_of_days, long int *days, long int *prefix_sum) {

    long int max_diff;
    long int i, j;

    long int l_min[number_of_days], r_max[number_of_days];

    // Construct l_min[] such that l_min[i] stores the minimum value from (arr[0], arr[1], ... arr[i])
    l_min[0] = prefix_sum[0];
    for (i = 1; i < number_of_days; ++i) {
        l_min[i] = min(prefix_sum[i], l_min[i - 1]);
    }
    printf("Lmin[]:\n");
    for (int i = 0; i < number_of_days; i++) {
        printf("%li\t", l_min[i]);
    }
    printf("\n");

    // Construct r_max[] such that r_max[j] stores the maximum value from (arr[j], arr[j+1], ..arr[n-1])
    r_max[number_of_days - 1] = prefix_sum[number_of_days - 1];
    for (j = number_of_days - 2; j >= 0; --j) {
        r_max[j] = max(prefix_sum[j], r_max[j + 1]);
    }
    printf("Rmax[]:\n");
    for (int i = 0; i < number_of_days; i++) {
        printf("%li\t", r_max[i]);
    }
    printf("\n");
    // Traverse both arrays from left to right to find optimum j - i
    // This process is similar to merge() of MergeSort
    i = 0, j = 0, max_diff = -1;
    long int maxi=0, maxj=number_of_days-1;
    while (j < number_of_days && i < number_of_days) {
       if (l_min[i] <= r_max[j]) {
            max_diff = max(max_diff, j - i);
            if (max_diff==j-i){
            	maxi = i;
            	maxj = j;
            }
            j = j + 1;
       }	
       else
            i = i + 1;
    }
    //Bypass by Alex.Tsaf
    if(((maxi!=0)&&(prefix_sum[maxj]<prefix_sum[maxi-1]))||((maxi==0)&&(prefix_sum[maxj]<0))){
    	return max_diff;
    }
    else{ 
    	return (max_diff + 1);
    }
}


// utility Function which subtracts X from all the elements in the array
void modify_days(long int number_of_days, int number_of_hospitals, long int *days) {

    for (int i = 0; i < number_of_days; i++) {
        days[i] = days[i] - number_of_hospitals;
    }
    printf("Minus Input AND Minus Hospitals:\n");
    for (int i = 0; i < number_of_days; i++) {
        printf("%li\t", days[i]);
    }
    printf("\n");
}

// Calculating the prefix sum array of the modified array
void calc_prefix(long int number_of_days, long int *days, long int *prefix_sum) {
    int sum = 0;
    for (int i = 0; i < number_of_days; i++) {
        sum += days[i];
        prefix_sum[i] = sum;
        // days[i] = -days[i];
    }
    printf("Prefix Sums[]:\n");
    for (int i = 0; i < number_of_days; i++) {
        printf("%li\t", prefix_sum[i]);
    }
    printf("\n");
}
// Function to find the length of the longest subarray with average >= x
long int longest_subarray(long int number_of_days, int number_of_hospitals, long int *days) {
    
    // longest_subarray declarations
    long int res;

    // longest_subarray initializations
    res = 0;

    modify_days(number_of_days, number_of_hospitals, days);
    // for (int i = 0; i < number_of_days; i++) {
    //     printf("%li\t", days[i]);
    // }
    // printf("\n");
    long int *prefix_sum = malloc(sizeof(long int) * number_of_days);
    calc_prefix(number_of_days, days, prefix_sum);
    // for (int i = 0; i < number_of_days; i++) {
    //     printf("%li\t", days[i]);
    // }
    // printf("\n");

    res = max_index_diff(number_of_days, days, prefix_sum);

    return (res);
}

// input reading, memory allocation and function calling
int main(int argc,char *argv[]) {

    // declarations
    FILE *fp;
    int i, ret, number_of_hospitals;
    long int number_of_days, *days, /**sums,*/ result/*, best_sum, best_start, best_end*/;

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

    printf("Input:\n");
    for (i = 0; i < number_of_days; i++) {
        printf("%li\t", days[i]);
    }
    printf("\n");
    // call find solution function
    for (int i = 0; i < number_of_days; i++) {
        days[i] = -days[i];
    }
    printf("Minus Input:\n");
    for (i = 0; i < number_of_days; i++) {
        printf("%li\t", days[i]);
    }
    printf("\n");
    
    result = longest_subarray(number_of_days, number_of_hospitals, days);
    printf("Output:\n");
    printf("%li\n", result);

    // testing
    printf("Number of days %li\n", number_of_days);
    printf("Number of hospitals %d\n", number_of_hospitals);
    // printf("Number of patients getting in or out:\n");
    // for (i = 0; i < number_of_days; i++) {
    //     printf("%li\t", days[i]);
    // }
    // printf("\n");

    // freeing memory
    free(days);

    return(0);
}