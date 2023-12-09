#include <stdio.h>
#include <stdlib.h>

#define TAM_TAB 100
#define TAM_PIL 100

enum
{
    INT,
    LOG,
    REG
};

char nomeTipo[3][4] = {"INT", "LOG", "REG"};



//lista encadeada de campos da tabela de simbolos
typedef struct campo *pto_campo;
struct campo
{
  char nome[100];
  int tipo;
  int pos;
  int desl;
  int tam;
  pto_campo prox;
};

//rotinas lista de campos

pto_campo insere_lista(pto_campo head, char nome[100], int tipo, int pos, int desl, int tam)
{
  pto_campo p, novo;
  novo = (pto_campo)malloc(sizeof(struct campo));
  strcpy(novo->nome, nome); 
  novo->tipo = tipo;
  novo->pos = pos;
  novo->desl = desl;
  novo->tam = tam;
  novo->prox = NULL;
  p = head;
  while(p !=NULL && p->prox != NULL){
    p = p->prox;
  }
  if(p != NULL){
     p->prox = novo;
  }else
  {
     head = novo;
  }
    
  return head;

}

pto_campo busca_campo(pto_campo head, char nome[100])
{
  pto_campo p;
  p = head;
  
  while(p && strcmp(p->nome, nome)){
    p = p->prox; 
  }
  return p;
}




int sizeOfList(pto_campo head){
  int size = 0;
  pto_campo p;
  p = head;
  while(p != NULL){
    size = size + p->tam; // somatorio do tamanho de todos os campos
    p = p->prox;
  }
   
  return size;
}

char *type_toString(int tipo){
  switch (tipo)
  {
  case REG:
    return "REG";
    break;
  case INT:
    return "INT";
    break;
  case LOG:
    return "LOG";
    break;
  default:
    return "?";
  }
}

char* build_list(pto_campo head){

  char* list = (char*)malloc(500*sizeof(char));
  char* list2 = (char*)malloc(500*sizeof(char));
  pto_campo p;
  p = head;
  while(p != NULL){
    if(p->prox != NULL){
       sprintf(list2, "(%s, %s, %d, %d ,%d)=>", p->nome, type_toString(p->tipo), p->pos, p->desl, p->tam);
       strcat(list, list2);
    }else{
       sprintf(list2, "(%s, %s, %d, %d ,%d)", p->nome, type_toString(p->tipo), p->pos, p->desl, p->tam);
       strcat(list, list2);
    }
    p = p->prox;
  }

  return list;
}


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
    pto_campo lista_campos; //ponteiro p lista de campos
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
  printf("\n%3s | %30s | %s | %s | %s | %s | %s\n", "#", "ID", "END", "TIP", "TAM", "POS", "CAMPOS");
  for(i = 0; i<100; i++)
    printf("-");
  for(i = 0; i<pos_tab; i++)
    if(TabSimb[i].tipo == REG){
      printf("\n%3d | %30s | %3d | %3s | %3d | %3d | %3s", i, TabSimb[i].id, TabSimb[i].endereco, "REG",
       TabSimb[i].tam, TabSimb[i].pos, build_list(TabSimb[i].lista_campos) );
    } else{
      printf("\n%3d | %30s | %3d | %3s | %3d | %3d | %3s", i, TabSimb[i].id, TabSimb[i].endereco,
     TabSimb[i].tipo == INT? "INT" : "LOG", TabSimb[i].tam, TabSimb[i].pos, "-");
    }
    
  puts("\n");
}


