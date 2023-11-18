%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdarg.h>

#include "lexico.c"
void erro(char *);
int yyerror(char *);
%}


%start programa

%token T_PROGRAMA
%token T_INICIO
%token T_FIMPROGRAMA

%token T_LEIA
%token T_ESCREVA

%token T_SE
%token T_ENTAO
%token T_SENAO
%token T_FIMSE

%token T_ENQUANTO
%token T_FACA
%token T_FIMENQUANTO

%token T_INTEIRO
%token T_LOGICO

%token T_MAIS
%token T_MENOS
%token T_VEZES
%token T_ATRIBUICAO
%token T_DIV
%token T_MAIOR
%token T_MENOR
%token T_IGUAL

%token T_E
%token T_OU
%token T_NAO

%token T_ABRE
%token T_FECHA

%token T_V
%token T_F

%token T_IDENTIF
%token T_NUMERO


%left T_E T_OU
%left T_IGUAL
%left T_MAIOR T_MENOR
%left T_MAIS T_MENOS
%left T_VEZES T_DIV

%%
programa 
  : cabecalho variaveis

    {
       printf("\tAMEM\tx\n");
    }

  T_INICIO lista_comandos T_FIMPROGRAMA

  {
       printf("\tDMEM\tx\n");
       printf("\tFIMP\tx\n");
  }

  ;

cabecalho 
  : T_PROGRAMA T_IDENTIF

    {
       printf("\tINPP\n");
    }

  ;

variaveis
  :
  | declaracao_variaveis
  ;

declaracao_variaveis
  : tipo lista_variaveis declaracao_variaveis
  | tipo lista_variaveis
  ;

tipo
  : T_LOGICO
  | T_INTEIRO
  ;

lista_variaveis
  : T_IDENTIF lista_variaveis
  | T_IDENTIF
  ;

lista_comandos
  : 
  | comando lista_comandos
  ;

comando
  : leitura
  | escrita
  | repeticao
  | selecao
  | atribuicao
  ;


leitura
  : T_LEIA T_IDENTIF

    { printf("\tLEIA\n");}
    { printf("\tARZG\tx\n");}

  ;

escrita
  : T_ESCREVA expr

    { printf("\tESCR\n");}

  ;

repeticao
  : T_ENQUANTO

    { printf("Lx\tNADA\n");}

    expr T_FACA 
    
    { printf("\tDSVF\tLy\n");}

    lista_comandos T_FIMENQUANTO

    { printf("\tDSVS\tLx\n");}
    { printf("Ly\tNADA\n");}
  ;


selecao
  : T_SE expr T_ENTAO 
  
  { printf("\tDSVF\tLx\n");}

  lista_comandos T_SENAO
  
  { printf("\tDSVS\tLy\n");}
  { printf("Lx\tNADA\n");}

   lista_comandos T_FIMSE

  { printf("Ly\tNADA\n");}

  ;

atribuicao
  : T_IDENTIF T_ATRIBUICAO expr
  
  { printf("\tARZG\tx\n");}

  ;

expr
  : expr T_MAIS expr

  { printf("\tSOMA\n");}

  | expr T_MENOS expr

  { printf("\tSUBT\n");}

  | expr T_VEZES expr

  { printf("\tMULT\n");}

  | expr T_DIV expr

  { printf("\tDIVI\n");}

  | expr T_MAIOR expr

  { printf("\tCMMA\n");}

  | expr T_MENOR expr

  { printf("\tCMME\n");}

  | expr T_IGUAL expr

  { printf("\tCMIG\n");}

  | expr T_E expr

  { printf("\tCONJ\n");}

  | expr T_OU expr

  { printf("\tDISJ\n");}

  | termo
  ;

termo 
  : T_IDENTIF

  { printf("\tCRVG\tx\n");}

  | T_NUMERO

  { printf("\tCRCT\tx\n");}

  | T_V

  { printf("\tCRCT\t1\n");}

  | T_F

  { printf("\tCRCT\t0\n");}

  | T_NAO termo

  { printf("\tNEGA\n");}

  | T_ABRE expr T_FECHA
  ;
            

%%

void erro(char *s){
  printf("ERRO: %s\n", s);
  exit(10);
}

int yyerror(char *s){
  erro(s);
}

int main(){
  if (!yyparse()){
    puts("Programa ok");
  }
}