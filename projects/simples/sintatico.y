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

int ehRegistro = 0;
int tam;
int des;
int pos = 0;

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

%token T_DEF
%token T_FIMDEF
%token T_REGISTRO
%token T_IDPONTO


%left T_E T_OU
%left T_IGUAL
%left T_MAIOR T_MENOR
%left T_MAIS T_MENOS
%left T_VEZES T_DIV

%%
programa 
  : cabecalho definicoes variaveis
    {mostra_tabela();}
    {
       empilha(conta);
       if(conta)
        fprintf(yyout, "\tAMEM\t%d\n", conta);
    }

  T_INICIO lista_comandos T_FIMPROGRAMA

  {
       int conta = desempilha();
       if(conta)
          fprintf(yyout, "\tDMEM\t%d\n", conta);
       fprintf(yyout, "\tFIMP\n");
  }

  ;

cabecalho 
  : T_PROGRAMA T_IDENTIF

    {
      fprintf(yyout, "\tINPP\n");
      //pre-cadastro de tipos na tabela de simbolos
      strcpy(elem_tab.id, "inteiro");
      elem_tab.endereco = -1;
      elem_tab.tipo = INT;
      elem_tab.tam = 1;
      elem_tab.pos = pos;
      insere_simbolo(elem_tab);
      pos++; //incrementando pos;
      strcpy(elem_tab.id, "logico");
      elem_tab.endereco = -1;
      elem_tab.tipo = LOG;
      elem_tab.tam = 1;
      elem_tab.pos = pos;
      insere_simbolo(elem_tab);
      pos++;
    }

  ;

tipo
  : T_LOGICO 
    {
      tipo = LOG;
      // TODO #1 -- FEITO
      // Além do tipo, precisa guardar o TAM (tamanho) do
      // tipo e a POS (posição) do tipo na tab. símbolos
      tam = 1;
      pos = 1;
    }
  | T_INTEIRO 
    {
      tipo = INT;
      tam = 1;
      pos = 0;
      //TODO #1 -- FEITO
      }
  | T_REGISTRO T_IDENTIF 
    {
      tipo = REG;
        // TODO #2
        // Aqui tem uma chamada de buscaSimbolo para encontrar
        // as informações de TAM e POS do registro
    }
  ;

definicoes
  : define definicoes
  |
  ;


define 
   : T_DEF
        {
            // TODO #3
            // Iniciar a lista de campos
        } 
   definicao_campos T_FIMDEF T_IDENTIF
       {
           // TODO #4
           // Inserir esse novo tipo na tabela de simbolos
           // com a lista que foi montada

          strcpy(elem_tab.id, atomo); // adicionando registro na tabela de simbolos
          elem_tab.endereco = -1;   
          elem_tab.tipo = REG;
          elem_tab.tam = tam; // contar tamanho da lista de campos
          elem_tab.pos = pos;
          insere_simbolo(elem_tab);
          pos++;
       }
   ;

definicao_campos
   : tipo lista_campos definicao_campos
   | tipo lista_campos
   ;

lista_campos
   : lista_campos T_IDENTIF
      {
         // TODO #5
         // acrescentar esse campo na lista de campos que
         // esta sendo construida
         // o deslocamento (endereço) do próximo campo
         // será o deslocamento anterior mais o tamanho desse campo
      }
   | T_IDENTIF
      {
        // idem
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



lista_variaveis
  : lista_variaveis T_IDENTIF 
  {
    strcpy(elem_tab.id, atomo);
    elem_tab.endereco = conta;   //adicionando variaveis na tab de simbolo
    elem_tab.tipo = tipo;
    elem_tab.tam = tam;
    elem_tab.pos = pos;
    // TODO #6 -- FEITO
    // Tem outros campos para acrescentar na tab. símbolos
    insere_simbolo(elem_tab);
    conta++; 
    // TODO #7
    // Se a variavel for registro
    // contaVar = contaVar + TAM (tamanho do registro)
  }
  | T_IDENTIF
  {
    strcpy(elem_tab.id, atomo);
    elem_tab.endereco = conta; 
    elem_tab.tipo = tipo;
    elem_tab.tam = tam;
    elem_tab.pos = pos;
    // idem
    insere_simbolo(elem_tab);
    conta++;
    // idem
  }
  ;

lista_comandos
  : 
  | comando lista_comandos
  ;

comando
   : entrada_saida
   | atribuicao
   | selecao
   | repeticao
   ;

entrada_saida
   : entrada
   | saida 
   ;


entrada
  : T_LEIA T_IDENTIF

    { 
     int pos = busca_simbolo(atomo);
     // TODO #8
     // Se for registro, tem que fazer uma repetição do
     // TAM do registro de leituras
     fprintf(yyout, "\tLEIA\n");
     if(pos == -1)
        erro("Variavel nao declarada!");
     fprintf(yyout, "\tARZG\t%d\n", TabSimb[pos].endereco);
     }

  ;

saida
  : T_ESCREVA expr

    { 
      desempilha();
      // TODO #9
      // Se for registro, tem que fazer uma repetição do
      // TAM do registro de escritas
      fprintf(yyout, "\tESCR\n");
    }

  ;

atribuicao
   : expressao_acesso
       { 
         // TODO #10 - FEITO
         // Tem que guardar o TAM, DES e o TIPO (POS do tipo, se for registro)
          empilha(tam);
          empilha(des);
          empilha(tipo);
       }
     T_ATRIBUICAO expr
       { 
          int tipexp = desempilha();
          int tipvar = desempilha();
          int des = desempilha();
          int tam = desempilha();
          if (tipexp != tipvar)
             yyerror("Incompatibilidade de tipo!");
          // TODO #11 - FEITO
          // Se for registro, tem que fazer uma repetição do
          // TAM do registro de ARZG
          for (int i = 0; i < tam; i++)
             fprintf(yyout, "\tARZG\t%d\n", des + i); 
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

expressao_acesso
   : T_IDPONTO
       {   //--- Primeiro nome do registro
           if (!ehRegistro) {
              ehRegistro = 1;
              // TODO #12
              // 1. busca o simbolo na tabela de símbolos
              // 2. se não for do tipo registo tem erro
              // 3. guardar o TAM, POS e DES desse t_IDENTIF
           } else {
              //--- Campo que eh registro
              // 1. busca esse campo na lista de campos
              // 2. se não encontrar, erro
              // 3. se encontrar e não for registro, erro
              // 4. guardar o TAM, POS e DES desse CAMPO
           }
       }
     expressao_acesso
   | T_IDENTIF
       {   
           if (ehRegistro) {
               // TODO #13
               // 1. buscar esse campo na lista de campos
               // 2. Se não encontrar, erro
               // 3. guardar o TAM, DES e TIPO desse campo.
               //    o tipo (TIP) nesse caso é a posição do tipo
               //    na tabela de simbolos
           }
           else {
              // TODO #14
              int pos = busca_simbolo (atomo);
              // guardar TAM, DES e TIPO dessa variável
           }
           ehRegistro = 0;
       };
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
  printf("ERRO linha %d: %s\n", numLinha, s);
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