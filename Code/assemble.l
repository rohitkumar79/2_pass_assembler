%{
#include"y.tab.h"
#include<string.h>
int locctr ;
%}
Arith ("ADD"|"ADC"|"INC"|"AAA"|"DAA"|"SUB"|"SBB"|"DEC"|"NEG"|"CMP"|"AAS"|"DAS"|"MUL"|"IMUL"|"AAM"|"DIV"|"IDIV"|"CBW"|"CWD")
Log ("NOT"|"SHL"|"SAH"|"ROL"|"ROR"|"RCL"|"RCR"|"AND"|"TEST"|"OR"|"XOR"|"SHR")
DataTrnsfr ("MOV"|"PUSH"|"POP"|"XCHG"|"XLAT"|"LEA"|"LDS"|"LAHF"|"SAHF"|"PUSHF"|"POPF")
CtrlTrnsfr ("CALL"|"JMP"|"RET"|"JE"|"JZ"|"JL"|"JNGE"|"JLE"|"JNG"|"JB"|"JNAE"|"JBE"|"JNA"|"JP"|"JPE"|"JO"|"JS"|"JNE"|"JNZ"|"JML"|"JGE"|"JNLE"|"JG"|"JNB"|"JAE"|"JNBE"|"JA"|"JNP"|"JNO"|"JNS"|"LOOP"|"LOOPZ"|"LOOPE"|"LOOPNZ"|"LOOPNE"|"JCXZ"|"INT"|"INTO"|"IRET"|"CLC"|"CMC"|"STC"|"CLD"|"STD"|"CLI"|"STI"|"HLT"|"WAIT"|"ESC"|"LOCK")
Inout ("IN"|"OUT")
Reg8 ("AL"|"AH"|"BL"|"BH"|"CL"|"CH"|"DL"|"DH")
Reg16 ("AX"|"BX"|"CX"|"DX"|"SP"|"BP"|"SI"|"DI")
Segreg ("CS"|DS"|"ES"|"SS")
Mem  ("[BX][SI]"|"[BX][DI]"|"[BP][SI]"|"[BP][DI]"|"[BP]"|"[SP]"|"[DI]"|"[SI]")
Hex [0-9|a-f|A-F]
Hex8 {Hex}{2}[hH]
Hex16 {Hex}{4}[hH]
word ([a-zA-Z])([a-zA-Z0-9]*)
String ['"'][a-z|A-Z|0-9|,|"."|;|:|/|-|+|*|?|!|*|"("    |")"|_|=|"$"| ]+['"']
Spaces [ \t]*
%%
{Arith}  {ECHO; strcpy(yylval.str,yytext); return ARITH;}
{Log}    {ECHO; strcpy(yylval.str,yytext);return LOG; }
{DataTrnsfr} {ECHO; strcpy(yylval.str,yytext);return DTTF;}
{CtrlTrnsfr} {ECHO; strcpy(yylval.str,yytext);return CTTF;}
{Inout} {ECHO;strcpy(yylval.str,yytext); return IO;}
{Hex8}  {ECHO; strcpy(yylval.str,yytext);return IBYTE;}
{Hex16} {ECHO; strcpy(yylval.str,yytext);return IWORD;}
{Mem}  {ECHO; 
           if(strcmp(yytext,"[SP]")==0) yylval.num=4;
		   else if(strcmp(yytext,"[BP]")==0) yylval.num=5;
		   else if(strcmp(yytext,"[SI]")==0) yylval.num=6;
		   else if(strcmp(yytext,"[DI]")==0) yylval.num=7;
		   else
		   yylval.num=(yytext[1]=='B')*((yytext[5]=='D')+2*(yytext[2]=='P'));
		   return MEM;}
{Spaces} {ECHO;}
"DB"  {ECHO; return DB;}
"DW" {ECHO; return DW;}
{Reg8}  {ECHO; yylval.num = ((yytext[1]=='L')?0:4)+ (yytext[0]-'A') + ((yytext[0]=='B')?3:0);
			if(yytext[0]>='B') yylval.num-=1;
			if(yytext[0] =='C' && yytext[1] =='L') {return CL;}
		   return REG8;}
{Reg16} {ECHO; 
		yylval.num=(yytext[1]=='X')*(yytext[0]-'A'-(yytext[0]>='B')+((yytext[0]=='B')? 3:0))+8;

		if(strcmp(yytext,"SP")==0) yylval.num=12;
		else if(strcmp(yytext,"BP")==0) yylval.num=13;
		else if(strcmp(yytext,"SI")==0) yylval.num=14;
		else if(strcmp(yytext,"DI")==0) yylval.num=15;

		return REG16;}
{word} {ECHO;strcpy(yylval.str,yytext);return LABEL;}
{String} {ECHO;strcpy(yylval.str,yytext); return STR;}
":"  {ECHO; return COLON; }
(";"[^\n]*)  {;}
\n {ECHO; return E;}
. {ECHO; return yytext[0]; }
%%
