%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdarg.h>

#include "lexico.c"
#include "utils.c"

void erro(char *);
int yyerror(char *);

int conta = 0;
int rot = 0;
int tipo;

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
    {mostra_tabela();}
    {
       fprintf(yyout, "\tAMEM\t%d\n", conta);
       empilha(conta);
    }

  T_INICIO lista_comandos T_FIMPROGRAMA

  {
       fprintf(yyout, "\tDMEM\t%d\n", desempilha());
       fprintf(yyout, "\tFIMP\n");
  }

  ;

cabecalho 
  : T_PROGRAMA T_IDENTIF

    {
       fprintf(yyout, "\tINPP\n");
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
  : T_LOGICO {tipo ='i';}
  | T_INTEIRO {tipo = 'l';}
  ;

lista_variaveis
  : lista_variaveis T_IDENTIF 
  {
    strcpy(elem_tab.id, atomo);
    elem_tab.endereco = conta++;   //adicionando variaveis na tab de simbolo
    elem_tab.tipo = tipo;
    insere_simbolo(elem_tab);
  }
  | T_IDENTIF
  {
    strcpy(elem_tab.id, atomo);
    elem_tab.endereco = conta++; 
    elem_tab.tipo = tipo;
    insere_simbolo(elem_tab);
  }
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

    { 
     fprintf(yyout, "\tLEIA\n");
     int pos = busca_simbolo(atomo);
     if(pos == -1)
        erro("Variavel nao declarada!");
     fprintf(yyout, "\tARZG\t%d\n", TabSimb[pos].endereco);
     
     
     }

  ;

escrita
  : T_ESCREVA expr

    { 
      desempilha();
      fprintf(yyout, "\tESCR\n");
    }

  ;

repeticao
  : T_ENQUANTO

    {
      rot++;
      fprintf(yyout, "L%d\tNADA\n", rot);
      empilha(rot); 
    }

    expr T_FACA 
    
    {
      int t = desempilha();
      if (t != LOG)
        yyerror("Incompatibilidade de tipo!");
      rot++; 
      fprintf(yyout, "\tDSVF\tL%d\n", rot);
      empilha(rot);
    }

    lista_comandos T_FIMENQUANTO

    {
      int rot_fim_rep = desempilha();
      int rot_ini_rep = desempilha(); 
      fprintf(yyout, "\tDSVS\tL%d\n", rot_ini_rep);
      fprintf(yyout, "L%d\tNADA\n", rot_fim_rep);
    }
  ;


selecao
  : T_SE expr T_ENTAO 
  
  { 
    int t = desempilha();
    if(t != LOG)
      yyerror("Incompatibilidade de tipo!");
    rot++;
    fprintf(yyout, "\tDSVF\tL%d\n", rot);
    empilha(rot);
  }

  lista_comandos T_SENAO
  
  { 
    int rot_entrada_senao = desempilha();
    rot++;
    fprintf(yyout, "\tDSVS\tL%d\n", rot);
    empilha(rot);
    fprintf(yyout, "L%d\tNADA\n", rot_entrada_senao);
    
  }

   lista_comandos T_FIMSE

  { 
    int rot_fim_se = desempilha();
    fprintf(yyout, "L%d\tNADA\n", rot_fim_se);
    
  }

  ;

atribuicao
  : T_IDENTIF
  {
     int pos = busca_simbolo(atomo);
     if(pos == -1)
        erro("Variavel nao declarada!");
     empilha(pos);
  }
   T_ATRIBUICAO expr
  {
    int t = desempilha();
    int p = desempilha();
    if(t != TabSimb[p].tipo)
      yyerror("Incompatiblidade de tipos");
    fprintf(yyout, "\tARZG\t%d\n", TabSimb[p].endereco);
  }
  ;

expr
  : expr T_MAIS expr

  { 
    testaTipo(INT,INT,INT);
    fprintf(yyout, "\tSOMA\n");
  }

  | expr T_MENOS expr

  { 
    testaTipo(INT,INT,INT);
    fprintf(yyout, "\tSUBT\n");
  }

  | expr T_VEZES expr

  {
    testaTipo(INT,INT,INT);
    fprintf(yyout, "\tMULT\n");
  }

  | expr T_DIV expr

  { 
    testaTipo(INT,INT,INT);
    fprintf(yyout, "\tDIVI\n");
  }

  | expr T_MAIOR expr

  { 
    testaTipo(INT,INT,LOG);
    fprintf(yyout, "\tCMMA\n");  
  }

  | expr T_MENOR expr

  { 
    testaTipo(INT,INT,LOG);
    fprintf(yyout, "\tCMME\n");  
  }

  | expr T_IGUAL expr

  { 
    testaTipo(INT,INT,LOG);  
    fprintf(yyout, "\tCMIG\n");
  }

  | expr T_E expr

  { 
    testaTipo(LOG,LOG,LOG);
    fprintf(yyout, "\tCONJ\n");
  }

  | expr T_OU expr

  { 
    testaTipo(LOG,LOG,LOG);
    fprintf(yyout, "\tDISJ\n");
  }

  | termo
  ;

termo 
  : T_IDENTIF

  { 
    int pos = busca_simbolo(atomo);
    if(pos == -1)
      erro("Variavel nao declarada!");
    fprintf(yyout, "\tCRVG\t%d\n", TabSimb[pos].endereco);
      empilha(TabSimb[pos].tipo);
  }

  | T_NUMERO

  { 
    fprintf(yyout, "\tCRCT\t%s\n", atomo);
    empilha(INT);  
  }

  | T_V

  { 
    fprintf(yyout, "\tCRCT\t1\n");
    empilha(LOG);  
  }

  | T_F

  { 
    fprintf(yyout, "\tCRCT\t0\n");
    empilha(LOG);  
  }

  | T_NAO termo

  { 
    int t = desempilha();
    if(t != LOG)
      yyerror("Incompatibilidade de tipo!");
    fprintf(yyout, "\tNEGA\n");
    empilha(LOG);  
  }

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

int main(int argc, char *argv[]) {
    char *p, nameIn[100], nameOut[100];
    argv++;
    if (argc < 2) {
        puts("\nCompilador da linguagem SIMPLES");
        puts("\n\tUSO: ./simples <NOME>[.simples]\n\n");
        exit(1);
    }
    p = strstr(argv[0], ".simples");
    if (p) *p = 0;
    strcpy(nameIn, argv[0]);
    strcat(nameIn, ".simples");
    strcpy(nameOut, argv[0]);
    strcat(nameOut, ".mvs");
    yyin = fopen(nameIn, "rt");
    if (!yyin) {
        puts ("Programa fonte não encontrado!");
        exit(2);
    }
    yyout = fopen(nameOut, "wt");
    yyparse();
    printf("programa ok!\n\n");
    return 0;
}