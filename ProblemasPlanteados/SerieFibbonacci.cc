#include <stdio.h>

int main (){
  int n=20;
int fib[50];
int t1=0;
int t2=1;
int nextTerm;
fib[0]=t1;
for(int i=1; i<=n; i++){
  fib[i]=t1;
  //printf("fib[%d]= %d/n",i,t1);
  nextTerm = t1 +t2;
  t1=t2;
  t2=nextTerm;
}}