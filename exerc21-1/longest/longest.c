#include <stdio.h>

int main(int argc,char *argv[]){
    FILE *f;
    if(f = fopen(argv[1],"r")== NULL) return 1;
    else {
       int M,N,sum=0,day;
       fscanf(f,"%d",&M);
       fscanf(f,"%d",&N);
       int A[1000000], B[1000000];
       while(fgetc(f)!="\n");
       for(int i=0;i<M;i++){
           fscanf(f,"%d ",&day);
           sum+=day;
           A[i]=day;
           B[i]=sum; 
       }
    }
    
}

