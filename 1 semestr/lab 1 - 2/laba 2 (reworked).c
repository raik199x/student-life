#include <stdio.h>

int main() {
	int n, s = 0;
	scanf("%d", &n); // смысл был в том, что в задании не указано сколько элементов в массиве, мне и не важно, впишем сколько понадобится
	int array[100];
	for (int i = 0; i < n; i++) { 
		scanf("%d", &array[i]); //начинаем заполнять массив
	}
	for (int i = 0; i < n; i++) {
		if (i % 2 != 0) {
			s += array[i];
		}
	}
	printf("%d", s); // вывод ответа
	return 0;
}
