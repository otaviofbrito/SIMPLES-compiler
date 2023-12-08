#define TAM_TAB 100
#define TAM_PIL 100

enum
{
    INT,
    LOG,
    REG
};

char nomeTipo[3][4] = {"INT", "LOG", "REG"};


//pilha semantica
int Pilha[TAM_PIL];
int topo = -1;

//adicionar tam pos e ponteiro p lista de campos
//tab de simbolos
struct elem_tab_simbolos{
    char id[100];
    int endereco;
    int tipo;
    int tam;
    int pos;
    //ponteiro p lista de campos
} TabSimb[TAM_TAB], elem_tab;
int pos_tab = 0;

//rotina de pilha semantica
void empilha(int valor){
  if(topo == TAM_PIL)
    erro("Pilha cheia!");
  Pilha[++topo] = valor;
}

int desempilha(){
  if(topo == -1)
    erro("Pilha vazia!");
  return Pilha[topo--];
}

//rotina tabela de simbolos
int busca_simbolo(char *id){
  int i = pos_tab -1;
  for(; strcmp(TabSimb[i].id, id) && i >= 0; i--)
    ;
  return i;
}

void insere_simbolo(struct elem_tab_simbolos elem){
  int i;
  if (pos_tab == TAM_TAB)
    erro("Tabela de simbolos cheia!");
  i = busca_simbolo(elem.id);
  if(i != -1)
    erro("Identificador duplicado");
  TabSimb[pos_tab++] = elem;
}


//testar tipos
//tipo1 e tipo2 sao os tipos esperados na expressao 
//ret eh o tipo que sera empilhado com resultado da expressao
void testaTipo(int tipo1, int tipo2, int ret){
    int t1 = desempilha();
    int t2 = desempilha();

    if(t1 != tipo1 || t2 != tipo2)
        erro("Incompatibilidade de tipo!");
    empilha(ret);
    
}

void mostra_tabela(){
  int i;
  puts("Tabela de Simbolos");
  printf("\n%3s | %30s | %s | %s | %s | %s \n", "#", "ID", "END", "TIP", "TAM", "POS");
  for(i = 0; i<100; i++)
    printf("-");
  for(i = 0; i<pos_tab; i++)
    printf("\n%3d | %30s | %3d | %3s | %3d | %3d", i, TabSimb[i].id, TabSimb[i].endereco,
     TabSimb[i].tipo == INT? "INT" : "LOG", TabSimb[i].tam, TabSimb[i].pos);
  puts("\n");
}