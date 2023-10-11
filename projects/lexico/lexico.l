identifier      [a-zA-Z]([a-zA-Z0-9])*
number          [0-9]+
blank_space     [ \t]+
new_line        [\n]

%x coment

%{

int nlines = 1;

%}


%%
PROGRAMA              printf("%3d|%11s: reservada\n", nlines, yytext);
INICIO                printf("%3d|%11s: reservada\n", nlines, yytext);
FIMPROGRAMA           printf("%3d|%11s: reservada\n", nlines, yytext);

LEIA                  printf("%3d|%11s: reservada\n", nlines, yytext);
ESCREVA               printf("%3d|%11s: reservada\n", nlines, yytext);

SE                    printf("%3d|%11s: reservada\n", nlines, yytext);
ENTAO                 printf("%3d|%11s: reservada\n", nlines, yytext);
SENAO                 printf("%3d|%11s: reservada\n", nlines, yytext);
FIMSE                 printf("%3d|%11s: reservada\n", nlines, yytext);

ENQUANTO              printf("%3d|%11s: reservada\n", nlines, yytext);
FACA                  printf("%3d|%11s: reservada\n", nlines, yytext);
FIMENQUANTO           printf("%3d|%11s: reservada\n", nlines, yytext);

INTEIRO               printf("%3d|%11s: reservada -> tipo\n", nlines, yytext);
LOGICO                printf("%3d|%11s: reservada -> tipo\n", nlines, yytext);

"+"                   printf("%3d|%11s: soma\n", nlines, yytext);
"-"                   printf("%3d|%11s: subtracao\n", nlines, yytext);
"*"                   printf("%3d|%11s: multiplicacao\n", nlines, yytext);
"<-"                  printf("%3d|%11s: atribuicao\n", nlines, yytext);
DIV                   printf("%3d|%11s: divisao\n", nlines, yytext);
">"                   printf("%3d|%11s: maior\n", nlines, yytext);
"<"                   printf("%3d|%11s: menor\n", nlines, yytext);
"="                   printf("%3d|%11s: igual\n", nlines, yytext);
E                     printf("%3d|%11s: e logico\n", nlines, yytext);
OU                    printf("%3d|%11s: ou logico\n", nlines, yytext);
NAO                   printf("%3d|%11s: negacao\n", nlines, yytext);
"("                   printf("%3d|%11s: abre\n", nlines, yytext);
")"                   printf("%3d|%11s: fecha\n", nlines, yytext);

"V"                   printf("%3d|%11s: constante logica\n", nlines, yytext);
"F"                   printf("%3d|%11s: constante logica\n", nlines, yytext);

"//".*                ;
"/*"                  BEGIN(coment);
<coment>"*/"          BEGIN(INITIAL);
<coment>.             ;
<coment>\n            nlines++;

{identifier}          printf("%3d|%11s: identificador\n", nlines, yytext);
{number}              printf("%3d|%11s: numero\n", nlines, yytext);
{blank_space}         ;
{new_line}            nlines++;
.                     printf("%11s: ERRO: SIMBOLO NAO RECONHECIDO", yytext);

%%

int yywrap(){
  return 1;
}

int main(){
  yylex();
  return 0 ;
}