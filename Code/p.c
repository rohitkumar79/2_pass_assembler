int toint(char hex[],int size)
{
  int num=0,i;
  for(i=0;i<size;i++)
  { num+=((hex[i]>='0'&&hex[i]<='9')? (hex[i]-'0'):(hex[i]-'A'+10));
    if(i<size-1) num*=16;
  }
  return num;
}

#include<stdio.h>
int main()
{
 FILE *fp;
 fp = fopen("symtab.txt","r");
 char buf[30],loc[30],c[1]; int x;
 fscanf(fp,"%s",buf);
 fscanf(fp,"%s",loc);
 fscanf(fp," %d",&x);
 printf("\n%s %s %d",buf,loc,x);
 //printf("\n %d",toint(loc,4));
}
