# Condition

Система управления версиями Git
Цели работы:

- изучить порядок работы с Git
- научиться выполнять основные операции с репозиторием
- получить навык совместной работы над проектом
Инструментарий:
- Git ([источник](https://git-scm.com/downloads))
- IntelliJ IDEA ([источник](https://www.jetbrains.com/idea/download/))
- JUnit
Теоретические сведения:

1. Понятие «система контроля версий»; виды СКВ; особенности Git – лекционный материал
2. Порядок установки и настройки Git: книга «ProGit», глава 1.4 и 1.5
[ссылка](https://git-scm.com/book/ru/v2)
3. Основные приёмы работы: там же, главы 2 и 3.

Порядок выполнения работы:

1. Изучить теоретические сведения.
2. Установить и сконфигурировать Git (использовать своё реальное имя и номер группы)
3. Зарегистрировать аккаунт на github.com (использовать своё реальное имя и номер группы)
4. Сделать fork [репозитория с проектом](https://github.com/pvmbsuir/laba1)
5. Склонировать полученный на шаге 4 репозиторий.
6. Собрать и запустить проект в IDE, рассмотреть и проанализировать код.
7. Произвести изменения (каждое изменение – отдельный commit):
   - a. поменять цветовую гамму изображения
   - b. изменить уравнение фрактала yc(z) = z2 + c, на аналогичное (те же операции + и *)
   - c. добавить другие операции над комплексными числами и использовать их в уравнении нового фрактала
   - d. добавить Unit тесты для проверки выполнения правильности новых операций
8. Сделать push изменений в свой репозиторий.
9. Создать pull-request в web-интерфейсе github (указать реальное имя и номер группы в заголовке; контроль по дате запроса!)

---

To run this lab you need:

- (only debian like systems) sudo apt-get install openjfx
- install SDK v7 (but i used corretto-1.8, that was the oldest version that i could download using idea tools)
