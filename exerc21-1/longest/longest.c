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
#include <stddef.h>

int main(int argc,char *argv[]){
    FILE *f;
    char c;
    if((f = fopen(argv[1],"r")) == NULL) return 1;
    else {
        int M,N,sum=0,day;
        fscanf(f,"%d",&M);
        fscanf(f,"%d",&N);
        int A[1000000], B[1000000];
        while( (c = fgetchar(f)) != "\n");
        for(int i=0;i<M;i++){
            fscanf(f,"%d ",&day);
            sum+=day;
            A[i]=day;
            B[i]=sum; 
        }
    }
    
}

