%{
#include "lexico_calc.c"
int valor[26];
%}

%token NUM
%token ENTER
%token MAIS
%token MENOS
%token VEZES
%token BARRA
%token ABRE
%token FECHA
%token VAR
%token RECEBE

%start linha

%left MAIS MENOS
%left VEZES BARRA

%%
linha : linha statement ENTER  
      |
      ;

statement : expr              {printf ("result = %d\n", $1);}
          | VAR RECEBE expr   {valor[$1] = $3;}
          ;

expr  : NUM               {$$ = $1;}
      | VAR               {$$ = valor[$1];}
      | expr MAIS expr    {$$ = $1 + $3;}
      | expr MENOS expr   {$$ = $1 - $3;}
      | expr VEZES expr   {$$ = $1 * $3;}
      | expr BARRA expr   {$$ = $1 / $3;}
      | ABRE expr FECHA   {$$ = $2;}
      ;


%%

void yyerror(char *s){
  printf("ERRO: %s", s);
  exit(10);
}

int main(void){
  yyparse();
}
