#include <stdio.h>
#include "../include/calc_add_sub.h"
#include "../include/calc_mult.h"
#include "../include/calc_div.h"

// esse é um programa feito apenas para testar as funcionalidades do cbuild e ajudar em sua construção, não faz parte da implementação real do projeto

int main() {
  int number1, number2;
  char param;

  printf("Digite os inteiros e a operação que você quer realizar: \n\n | Soma: 's' | Subtração: 'u' | Multiplicação: 'm' | Divisão: 'd' | Comparação 'c' | \n\n Exemplo: \n 10 2 m \n\n Retorno: \n 20 \n\n");
  scanf("%d", &number1);
  scanf("%d", &number2);
  scanf(" %c", &param);

  if (param == 's') {printf("%d\n", add(number1, number2)); return 0;}
  else if (param == 'u') {printf("%d\n", sub(number1, number2)); return 0;}
  else if (param == 'm') {printf("%d\n", mult(number1, number2)); return 0;}
  else if (param == 'd') {printf("%d\n", div(number1, number2)); return 0;}
  else if (param == 'c') {printf("%c\n", isEq(number1, number2)); return 0;}
  else {printf("Valor inválido, por favor coloque inteiros e operações válidas\n");}

  return 0;

}
