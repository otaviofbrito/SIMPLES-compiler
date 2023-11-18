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

programa              return T_PROGRAMA;
inicio                return T_INICIO;
fimprograma           return T_FIMPROGRAMA;

leia                  return T_LEIA;
escreva               return T_ESCREVA;

se                    return T_SE;
entao                 return T_ENTAO;
senao                 return T_SENAO;
fimse                 return T_FIMSE;

enquanto              return T_ENQUANTO;
faca                  return T_FACA;
fimenquanto           return T_FIMENQUANTO;

inteiro               return T_INTEIRO;
logico                return T_LOGICO;

"+"                   return T_MAIS;
"-"                   return T_MENOS;
"*"                   return T_VEZES;
"<-"                  return T_ATRIBUICAO;
div                   return T_DIV;
">"                   return T_MAIOR;
"<"                   return T_MENOR;
"="                   return T_IGUAL;

e                     return T_E;
ou                    return T_OU;
nao                   return T_NAO;

"("                   return T_ABRE;
")"                   return T_FECHA;

"V"                   return T_V;
"F"                   return T_F;



{identifier}           return T_IDENTIF;
{number}               return T_NUMERO;
{blank_space}         
{new_line}             
.                      erro("LEXICO");

%%
