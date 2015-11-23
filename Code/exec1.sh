#!/bin/bash
clear
cc functions.h
yacc -d pass1.y
lex assemble.l
cc lex.yy.c y.tab.c -ll -o AKASM
