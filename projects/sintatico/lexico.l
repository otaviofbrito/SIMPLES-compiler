%{
#include "sintatico.h" 
void erro (char *s); 
%}


identifier      [a-zA-Z]([a-zA-Z0-9])*
number          [0-9]+
blank_space     [ \t]+
new_line        [\n]

%option noyywrap

%%

PROGRAMA              return T_PROGRAMA;
INICIO                return T_INICIO;
FIMPROGRAMA           return T_FIMPROGRAMA;

LEIA                  return T_LEIA;
ESCREVA               return T_ESCREVA;

SE                    return T_SE;
ENTAO                 return T_ENTAO;
SENAO                 return T_SENAO;
FIMSE                 return T_FIMSE;

ENQUANTO              return T_ENQUANTO;
FACA                  return T_FACA;
FIMENQUANTO           return T_FIMENQUANTO;

INTEIRO               return T_INTEIRO;
LOGICO                return T_LOGICO;

"+"                   return T_MAIS;
"-"                   return T_MENOS;
"*"                   return T_VEZES;
"<-"                  return T_ATRIBUICAO;
DIV                   return T_DIV;
">"                   return T_MAIOR;
"<"                   return T_MENOR;
"="                   return T_IGUAL;

E                     return T_E;
OU                    return T_OU;
NAO                   return T_NAO;

"("                   return T_ABREP;
")"                   return T_FECHAP;

"V"                   return T_V;
"F"                   return T_F;



{identifier}           return T_IDENTIF;
{number}               return T_NUMBER;
{blank_space}         
{new_line}             
.                      erro("LEXICO");

%%
