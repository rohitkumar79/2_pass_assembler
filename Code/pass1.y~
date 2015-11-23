%{
#include "functions.h"
extern FILE *yyin;
extern int locctr;
int lineno=1;
FILE *op;
SYMBOL *temp;
char hex[5];
%}

%token ARITH LOG DTTF CTTF IO REG8 REG16 MEM DB DW IBYTE IWORD LABEL STR COLON E
%token CL

%nonassoc CON
%nonassoc ','
%union
 {
    int num;
	char str[30];
  }

%start S 
%type <str> LABEL
%type <str> STR
%type <num> VAL
%type <num> VAR
%type <num> NBYTES
%type <num> NWORDS
%type <num> IBYTE
%type <num> IWORD
%type <num> MEMORY
%type <num> RM
%type <num> CONST
%type <num> IMMED
%type <num> REGMEM
%type <num> INSTR
%type <num> ARITHMETIC
%type <num> DATATRANS
%type <num> LOGICAL
%type <num> CTRLTRANS

%%
S: N S  
| {printf("\n PASS 1 complete ...."); }
;

N: VAR E	{tohex(locctr,hex,4);printf("\n%4d\t%s\t",++lineno,hex);fprintf(op,"%s ",hex);}
| INSTR E	{locctr+=$1;tohex(locctr,hex,4);printf("\n%4d\t%s\t",++lineno,hex);fprintf(op,"%s ",hex);}
| LABEL COLON E {if((temp=search_symbol($1))==NULL)
		  insert_symbol($1,locctr,0);
		 else {insert_symbol($1,locctr,temp->flag);}
		 tohex(locctr,hex,4);printf("\n%4d\t%s\t",++lineno,hex);fprintf(op,"%s ",hex);
		}
| E 		{printf("\n%4d",++lineno);}
;
VAR: LABEL VAL  {if((temp = search_symbol($1))==NULL)
		  insert_symbol($1,locctr,0);
		 else {insert_symbol($1,locctr,temp->flag);}
		  locctr+=$2;
		}
;
NBYTES: IBYTE ',' NBYTES  { $$ = 1+$3;}
	| IBYTE           { $$ = 1; }
	;


NWORDS: IWORD ',' NWORDS  { $$ = 2+$3;}
 	| IWORD         	{$$ = 2;}
	;


VAL:  DB NBYTES  { $$  = $2; }
   |  DW NWORDS	 {$$ = $2; }
   | DB STR     {$$ = strlen($2)-2;}
   ;


INSTR: ARITHMETIC   {$$= $1;}
	| LOGICAL        {$$=$1;} 
	| DATATRANS		{$$=$1;}
	| CTRLTRANS		{$$=$1;}
        ;

STEP: '1'
	| CL 
   ;


ARITHMETIC: ARITH REGMEM     {$$ = 2+$2;}
	| ARITH IMMED		    {$$ = 2+$2;}
	| ARITH RM			{$$ = 2+ $2;}
	|ARITH				{$$= 1;}
         ;   

LOGICAL:LOG REG ',' STEP  {$$= 2;}
	  | LOG MEMORY ',' STEP	{$$=2+ $2;}
	  | LOG REGMEM	{$$=2+$2;}
	  | LOG IMMED	{$$=2+$2;}
        ;


DATATRANS: DTTF REGMEM   {$$ = 2+$2;}
	| DTTF IMMED		{$$ = 2+$2;}
	| DTTF RM		{$$ = 2+$2;}
        ;

CTRLTRANS: CTTF LABEL  {Symbol *temp=search_symbol($2);
			 if(temp==NULL)
		  	  $$=3;
			 else {
			  if(abs(locctr+4-temp->addrs) > 255) $$=3;
			  else $$=2;
			 }
			}
        | CTTF CONST		{$$=1+$2;}
        ;

REGMEM: REG ',' MEMORY  	{$$=$3;}
| MEMORY ',' REG        	{$$=$1;}
| REG ',' REG 	     	{$$=0;}
;

IMMED: RM ',' CONST {$$=$1+$3;}
        ;

RM: REG	 %prec CON	{$$=0;}
        | MEMORY	 %prec CON	{$$=$1;}


MEMORY: MEM CONST	{$$=$2;}
| MEM		{$$=0;}
| '[' CONST ']'		{$$=$2;}
| CONST			{$$=$1;}
| LABEL	 		{Symbol *temp=search_symbol($1);
			 if(temp==NULL)
		  	  $$=2;
			 else {
			  if(abs(locctr+4-temp->addrs) > 255) $$=2;
			  else $$=1;
			 }
			}
        ;


CONST: IWORD	{$$=2;}
        | IBYTE     	{$$=1;}
        ;

REG: REG8
| REG16
;


%%

int main()
{
  locctr=0;
  yyin=fopen("prog.asm","r");
  op=fopen("inter.txt","w");
  tohex(locctr,hex,4);
  printf("\n\nLineNo LOCCTR   INSTRUCTION\n\n");
  printf("%4d\t%s\t",lineno,hex);
  yyparse();
  printf("\n\n");
  print_symtab();
  write_symtab();
  printf("\n");
  return 0;
}

int yyerror()
{
  printf("\nFatal Error %d:Unable to parse\n",lineno);

}
