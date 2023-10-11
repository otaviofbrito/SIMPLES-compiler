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

%token T_ABREP
%token T_FECHAP

%token T_V
%token T_F

%token T_IDENTIF
%token T_NUMBER


%left T_E T_OU
%left T_IGUAL
%left T_MAIOR T_MENOR
%left T_MAIS T_MENOS
%left T_VEZES T_DIV

%%
programa : cabecalho variaveis T_INICIO lista_comandos T_FIMPROGRAMA
         ;

cabecalho : T_PROGRAMA T_IDENTIF
          ;

variaveis :
          | declaracao_variaveis
          ;

declaracao_variaveis : tipo lista_variaveis declaracao_variaveis
                     | tipo lista_variaveis
                     ;

tipo : T_LOGICO
     | T_INTEIRO
     ;

lista_variaveis : T_IDENTIF lista_variaveis
                | T_IDENTIF
                ;

lista_comandos : 
               | comando lista_comandos
               ;

comando : leitura
        | escrita
        | repeticao
        | selecao
        | atribuicao
        ;


leitura : T_LEIA T_IDENTIF
        ;

escrita : T_ESCREVA expr
        ;

repeticao: T_ENQUANTO expr T_FACA lista_comandos T_FIMENQUANTO
         ;

selecao : T_SE expr T_ENTAO lista_comandos T_SENAO lista_comandos T_FIMSE
        ;

atribuicao : T_IDENTIF T_ATRIBUICAO expr
           ;

expr : expr T_MAIS expr
     | expr T_MENOS expr
     | expr T_VEZES expr
     | expr T_DIV expr
     | expr T_MAIOR expr
     | expr T_MENOR expr
     | expr T_IGUAL expr
     | expr T_E expr
     | expr T_OU expr
     | termo
     ;

termo : T_IDENTIF
      | T_NUMBER
      | T_V
      | T_F
      | T_NAO termo
      | T_ABREP expr T_FECHAP
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