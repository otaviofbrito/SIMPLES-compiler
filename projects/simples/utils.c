#define TAM_TAB 100
#define TAM_PIL 100

//pilha semantica
int Pilha[TAM_PIL];
int topo = -1;

//tab de simbolos
struct elem_tab_simbolos{
    char id[100];
    int endereco;
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

void mostra_tabela(){
  int i;
  puts("Tabela de Simbolos");
  printf("\n%30s | %s \n", "ID", "END");
  for(i = 0; i<50; i++)
    printf("-");
  for(i = 0; i<pos_tab; i++)
    printf("\n%30s | %d ", TabSimb[i].id, TabSimb[i].endereco);
  puts("\n");
}