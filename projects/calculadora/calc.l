%{
#include "calc.h"
#include <stdlib.h>
void yyerror(char *);

%}

%%
[0-9]+          {yylval = atoi(yytext); return NUM;}
[A-Z]           {yylval = *yytext - 'A'; return VAR;}
[a-z]           {yylval = *yytext - 'a'; return VAR;}
"<-"            return RECEBE;
"+"             return MAIS;
"-"             return MENOS;
"*"             return VEZES;
"/"             return BARRA;
\n              return ENTER;
"("             return ABRE;
")"             return FECHA;


[ \t]+          ;
.               yyerror("Simbol desconhecido ");

%%

int yywrap (void){
  return 1;
}