# Notes

## Actual Condition (russian)

Моделирование и изучение характеристик генераторов псевдослучайных чисел

Написать приложение на языке С# для моделирования генераторов псевдослучайных чисел. Использовать 64х битную арифметику целых чисел без знака.

1. генератор на основе алгоритма Лемера

2. генератор на основе метода серединных произведений

3. генератор на основе регистра сдвига с обратными связями

Подобрать параметры для генераторов с целью наилучших результатов для каждого генератора (для выборок N=10000, 500000, 100000000)

Вывести гистограмму, математическое ожидание ,корреляцию и результаты 1-8 тестов NIST для лучшего случая.

Сравнить полученные результаты с встроенным в  С# генератором.

В генераторе 2  при умножении число разрядов увеличивается в 2 раза(64+64) =128 и это не ulong. используйте либо числа большей разрядности(BIGINT) либо число x будет состоять из двух частей x=(x0+2`64* x1) старшей x1 и младшей x0

и алгоритм сложения таких чисел ```z=z0+z1*2`64=(x0+y10)+2`64*(x1+y1)``` т.е отдельно складываем старшие и младшие части слагаемых x и y

алгоритм умножения ```z=z0+z1*2`64=(x0+2`64*x1)*(y0+2`64*y1)=x0*y0 +2`64*(x1*y0+y0*x1) +2`128*x1*y1;```

Для выделения средней части бит в генераторе 2 используйте битовую маску m=0b0000000111........1111000000;
```y=x&m;```
и сдвиг результата вправо на кол нулевых разрядов справа в маске n
```y=y>>n```

## Important notes

1. Гистограмма 256 интервалов
2. Делать всё в одном окне
