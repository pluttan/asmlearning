#import "@docs/bmstu:1.0.0":*
#show: student_work.with(
  caf_name: "Компьютерные системы и сети",
  faculty_name: "Информатика и системы управления",
  work_type: "домашней работе",
  work_num: "2",
  discipline_name: "Машинно-зависимые языки и основы компиляции",
  theme: "Лексические и синтаксические анализаторы",
  author: (group: "ИУ6-42Б", nwa: "А. П. Плютто"),
  adviser: (nwa: "Я. С. Петрова"),
  city: "Москва",
  table_of_contents: true,
)

= Задание
== Цель работы

Закрепление знаний теоретических основ и основных методов приемов разработки лексических и синтаксических анализаторов регулярных и контекстно-свободных формальных языков.

== Задание

Разработать грамматику и распознаватель имени процедуры для языка программирования C++. Считать, что параметры только стандартных (скалярных) типов. Например:
```cpp void f1(int a; float b; double c);```

= Выполнение
== Форма Бекуса-Наура
```
<Буква> ::= a|b|…|z|A|B|…|Z

<Цифра> ::= 0|1|2|...|9

<Идентификатор> ::= <Буква>|<Идентификатор><Буква>|
                    <Идентификатор><Цифра>

<Тип> ::= char|signed char|unsigned char|short|signed short|
          unsigned short|int|signed int|unsigned int|long|
          signed long|unsigned long|long long|signed long long|
          unsigned long long|float|double|long double|wchar_t|
          char16_t|char32_t|bool

<Аргумент> ::= <Тип> <Идентификатор>

<Аргументы> ::= <Аргумент>;<Аргументы>|<Аргумент>

<Процедура> ::= void <Идентификатор>(<Аргументы>);| 
                void <Идентификатор>();
```

== Синтаксическая диаграмма 

#img(image("1.png", width:100%), [Синтаксическая диаграмма])

== Определение типа грамматики Хомского

Данная грамматика по классификации Хомского относится к грамматикам 3 типа, так как в описании присутствует только левосторонняя рекурсия (грамматика контекстно-независима так как в БНФ в левой части всегда один нетерминал).


== Код для лексического анализа
Напишем код для лексического анализа. Для упрощения анализа воспользуемся регулярными выражениями: с помощью них найдем начало процедуры, все аргументы и конец процедуры.

#let dz2 = parserasm(read("dz2.py"))
#code(funcstr(dz2, "def leks(string):"), "py", [Код для лексического анализа])
#code(funcstr(dz2, "def create_pattern(end_char):"), "py", [Код для поиска аргументов и символов после них])

Результатом лексического анализа будет являться строка, содержащая только символы разделения (я взял %), и некоторые токены, которыми мы заменили все терминалы, не терминалы и т.д. Таких токенов у меня получилось 6: `vd`,`fn`,`(_`,`id`,`)_`,`;_`. Последовательность этих токенов проверит синтаксический анализ, а на этапе лексического просто проверим, что в строке не осталось иных символов.

#code(funcstr(dz2, "def checkleks(string):"), "py", [Код для проверки лексического анализа])

== Код для синтаксического анализа

В синтаксическом анализе просто проверим последовательность идущих друг за другом символов: с начала необходим символ `vd` -- ```cpp void``` затем идентификатор-название функции `fn`, после терминал ( -- `(_`, потом должен идти или терминал ) `)_` или аргумент `id`, после аргумента идет тоже самое. после закрывающей скобки идет ; -- `;_`, затем никаких символов больше быть не должно, т.е. проверяем на пустую строку.


#code(funcstr(dz2, "def syntax(string):"), "py", [Код для синтаксического анализа])

Как видно мы получили код для автомата, который переходит из одного состояния в другое, если ожидаемое состояние недостижимо, то автомат сразу возвращает ```py False```

== Проверка
Для проверки напишем код:

```py
inp = input("Введите входную строку: ")
l = leks(inp)
print("Результат лексического анализа: ", l)
print("Результат проверки лексического анализа: ", checkleks(l))
print("Результат синтаксического анализа: ", syntax(l))
```

Введем 3 входных строки и проверим результаты:

#img(image("2.png", width:100%), [Проверка])

Как видно на скриншоте лексический и синтаксический анализы работают верно.

== Вывод

При выполнении домашнего задания были освоены методы компиляции и разработан лексический и синтаксический анализатор для формального языка.

= Контрольные вопросы

== Дайте определение формального языка и формальной грамматики
Формальный язык L(A) – это совокупность допустимых предложений, составленных из A, где А - некоторый алфавит. 

Формальная грамматика – математическая система, определяющая язык посредством порождающих правил (правила продукции).

== Как определяется тип грамматики по Хомскому?

Грамматики по Хомскому различаются по набору правил, которые они используют

В 3 типе допустимы левосторонняя и правосторонняя рекурсия, он контекстно-независим.

Во 2 типе допустима вложенность, он контекстно-независим.

В 1 типе допустимо все то, что в предыдущих типах и контекстная зависимость.

В 0 типе допустимо все то, что в предыдущих типах и все остальные конструкции.

== Поясните физический смысл и обозначения формы Бэкуса–Наура. 

БНФ связывает терминальные и нетерминальные символы.

Обозначения: «::=» – «можно заменить на» и « | » – «или».

== Что такое лексический анализ? Какие методы выполнения лексического анализа вы знаете?
 
Лексический анализ - процесс преобразования исходной строки в последовательность однородных символов (токенов), которые используются на этапе синтаксического анализа для распознавания конструкций.

Выполнять лексический анализ можно с помощью последовательного сравнения строк, или при помощи конечных автоматов.

== Что такое синтаксический анализ? Какие методы синтаксического анализа вы знаете? К каким грамматикам применяются перечисленные вами методы?

Синтаксический анализ - процесс распознавания конструкций языка в строке токенов.

Для регулярных грамматик возможен синтаксический анализ при помощи конечных автоматов.

Для КС-грамматик необходимо разработать автомат с магазинной памятью LL(k), LR(k).

== Что является результатом лексического анализа?

Результатом лексического анализа является строка, состоящая из токенов, или ошибка именования

== Что является результатом синтаксического анализа?

Результатом синтаксического анализа является распознавание заданной
конструкции или информация о наличии ошибки.

== В чем заключается метод рекурсивного спуска?

Метод рекурсивного спуска заключается в распознавании аксиомы, вызова соответствующей процедуры, которая вызывает процедуру нетерминала, которые вызывают процедуру аксиомы и т.д. Это обеспечивается рекурсивным вложением в правилах продукции грамматики.

== Что такое таблица предшествования и для чего она строится?

Таблица предшествования строится для сведения в удобную форму отношений предшествования терминалов с учетом приоритетов различных операций. Отношения предшествования характерны для грамматик, в которых существует однозначное отношение предшествования между соседними символами (оно позволяет определить очередную основу, т.е. момент выполнения каждой свёртки). Впоследствии на таблицах предшествования строится метод синтаксического анализа LR(k).

== Как с использованием таблицы предшествования осуществляют синтаксический анализ
 
В начале выполняется лексический анализ, получается строка токенов. 
После чего строка токенов разбирается в соответствие с таблицей предшествования. Далее с применением данной таблицы по стековому методу выявляются команды или операции или конструкции.




















