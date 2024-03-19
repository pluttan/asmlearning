#import "@docs/bmstu:1.0.0":*
#show: student_work.with(
  caf_name: "Компьютерные системы и сети",
  faculty_name: "Информатика и системы управления",
  work_type: "лабораторной работе",
  work_num: "1",
  discipline_name: "Машинно-зависимые языки и основы компиляции",
  theme: "Изучение среды и отладчика ассемблера",
  author: (group: "ИУ6-42Б", nwa: "А. П. Плютто"),
  adviser: (nwa: "Я. С. Петрова"),
  city: "Москва",
  table_of_contents: true,
)

= Цель работы
Изучение процессов создания, запуска и отладки программ
на ассемблере Nasm под управлением операционной системы Linux, а также
особенностей описания и внутреннего представления данных.
 
= Создание папок и файлов

При работе с операционной системой `linux` удобно использовать для большинства действий терминал, поэтому я буду использовать только его. Редактор кода `neovim`, деббагер `gdb`.

Создадим папку и файлы для 1 лабораторной работы. Для этого воспользуемся утилитами ```sh mkdir```, ```sh cd```, ```sh touch``` и выведем все файлы в папке на экран с помощью ```sh ls```.\ 
#code("mkdir -r ~/labs/lab1
cd ~/labs/lab1
touch lab1.{1..6}.asm
ls", "zsh", "Создаем папки и файлы")

#img(
  image("01-ls.png", width: 80%),
  [Вывод команды ```sh ls```]
)

= Заготовка программы

Возьмем заготовку программы для 32 битной архитектуры.

#code(read("lab1.1.asm"), "asm", "Заготовка программы")

Программу скомпилируем и скомпануем при помощи компилятора ```sh nasm``` и копоновщика ```sh ld```.
Так как процессор у меня 64-ех разрядный, а программа написана для 32-ух разрядного процессора укажем компановщику, что нужно использовать режим эмуляции: ```sh ld -m elf_i386```.\

#pagebreak()
И так вся команда для собрания бинарного файла будет выглядеть так:

#code("mod=lab1.1 # Название ассемблерного файла без расширения
nasm -f elf -o $mod.o $mod.asm 
ld -m elf_i386 -o $mod $mod.o
", "sh", "Команда для создания бинарного файла")\
После этого программу можно запустить при помощи команды ```sh ./$mod```.

#img(
  image("02-lab1.1.png", width: 80%),
  [Вывод программы 1]
)\

Разберем основные идеи в программе.

Она разделена на 3 подпрограммы: вывод, ввод, выход. Между подпрограммами используется механизм прерываний, который выполняет системные функции указанные в регистре ```asm eax```. Следует отметить, что сейчас все прерывания обрабатываются программно и доступ к действительным аппаратным прерываниям современные операционные системы не предоставляют.

Для вывода используем системную функцию 4. Для этого помещаем значение 4 в ```asm eax```. В регистр ```asm ebx``` помещаем декриптор файла `stdout`. Дескрипторы файлов `stdin`, `stdout` и `stderr` -- 0, 1 и 2, соответственно. В ```asm ecx``` указываем ссылку на первый элемент массива с нашей строкой (которая в памяти представлена как набор чисел). В ```asm edx``` помещаем размер строки. 

Тут следует немного подробнее остановиться на том как мы получаем этот размер строки, объявленный в ```asm section .data```. Знак `$` воспринимается в диалекте `nasm` как адрес текущей ячейки памяти, т.е. если использовать знак `$` после объявления массива то мы получим адрес, который на единицу превосходит адрес последнего элемента массива. Вычитая из полученного адреса адрес начала массива мы получаем длину массива, а так как эти операции были проделаны не с литералами, а с адресами мы используем ```asm equ```. По такому же принципу мы получаем и ```asm lenIn```. 

Для чтения выделим отдельно неинициализированную память для 10 букв(после ввода 11 ввод перенаправится в командную строку по завершении программы). Используем системную функцию 3, файл stdin, выделенную память и ее длину для регистров ```asm eax```, ```asm ebx```, ```asm ecx```и ```asm edx``` соответственно. 

Для выхода используем системную функцию 0, возвращаем код 0, чтобы показать, что программа успешно завершилась.

Посмотрим как выглядит машинное представление программы, ее дизассемблированный код, содержимое регистров в отладчике. Для этого запустим отладку с помощью команды ```sh gdb $mod```.

#img(
  image("03-interfgdb.png", width: 80%),
  [Интерфейс `gbd`]
)\

Создадим новый "слой" в котором сверху будут регистры, а снизу ассемблерный код, созданный на основе полученного бинарного кода. Сам машинный код это набор чисел, так что он совершенно не нагляден для отладки. 

```sh
tui new-layout ra regs 1 asm 1 cmd 1
```

После создания слоя перейдем в него с помощью команды ```sh lay ra```.
Тут создадим точку останова на метке начала нашей программы ```sh br start```. 

Перед запуском убедимся что в память загрузилось все, что мы объявили в ```asm section .data```.
#img(
  image("04-mem.png", width: 80%),
  [Занятая память]
)

Как мы видим в начале памяти идет `"Press Enter to Exit"`. Попробую представить это более наглядно:
#text(size: 12pt)[
```math
50  72  65  73  73  20  45  6e  74  65  72  20  74  6f  20  45  78  69  74 
P   r   e   s   s       E   n   t   e   r       t   o       E   x   i   t 
```]

10 байт после этой записи зарезервированы под ввод, а константы просто заменяются самим компилятором nasm, поэтому памяти они не используют (аналогично ```c #define```).

Итак теперь все готово к запуску, вводим команду ```sh run```.

#img(
  image("05-deb.png", width: 60%),
  [Запуск программы]
)\

Как мы видим регистры ```asm eax```, ```asm ebx```, ```asm ecx```и ```asm edx``` пусты, а курсор на первой ассемблерной инструкции. Выполним первую часть кода и посмотрим как изменится содержимое регистров.

#img(
  image("06-deb1.png", width: 60%),
  [Первая часть кода]
)\

Переместили все значения в регистры, и результатом стало, что все значения просто лежат в регистрах, но после системного прерывания значение в регистре ```asm eax```  поменяется на коды, возвращенные системой после печати.

#img(
  image("07-deb2.png", width: 60%),
  [Вызываем прерывание и видим как меняется значение регистра]
)\

После выполнения первой части кода уже понятно, как ведут себя регистры при операциях перемещения и вызове системы, поэтому просто для наглядности приведу еще один скриншот программы с перемещением в регистры второй части программы.

#img(
  image("08-deb3.png", width: 60%),
  [Готовим регистры для вызова ввода]
)\

Итак, мы нажали на enter, программа завершилась с кодом $0$. Осталось только проверить флаги. Они хранятся в регистре ```asm eflags```. Вот, что находится в этом регистре после завершения программы:

#img(
  image("09-deb4.png", width: 100%),
  [Флаги после завершения программы]
)\

Приведу таблицу флагов.

#img(
  image("10-eflags.svgz", width: 80%),
  [Таблица флагов]
)\

Из таблицы видно, что так как программа завершилась нулем, она подняла флаг четности `PF` и флаг нуля `CF`. `IF` по умолчанию всегда поднят, если у программы есть возможность вызвать прерывание.


= Отладка арифмитических операций

Приведем другой ассемблерный код с арифмитическими операциями:
#code(read("lab1.2.asm"), "asm", "Код для отладки")

Скомпилируем, соберем и запустим файл. Он просто завершит работу. Все операции мы можем посмотреть опять обратившись к отладке. Тут я построчно приведу всю отладку начиная с ```asm _start```.

Но для начала снова проверим память:

#img(
  image("11-mem2.png", width: 50%),
  [Память]
)\

Тут $-30$ это `0xffe2` (правило получения числа -а: переводим а в двоичную форму (прямой код), заменяем все 0 на 1, а 1 на 0 (обратный код), прибавляем 1 к записи (дополнительный код)). Убедимся в правильности записи `30 = 0x1e`, преобразуем в обратный `0x1e = 00011110b`#sym.arrow`11100001b = 0xe1` тут стоит заметить что на самом деле в памяти мы выделяем слово, получается 30 это не `0x1e`, а `0x001e`, тогда обратный код `0xffe1`, добавим 1, чтобы получить дополнительный и получится как раз `0xffe2`.

А `b` положительно, поэтому представляется в памяти в виде простой формы `21 = 16+5 = 0x15`.

Теперь запускаем программу и смотрим на результат.
#grid(
  columns:2,
  gutter:10pt,
  img(image("12-deb5.png", width: 90%),"Запуск"),
  img(image("13-deb6.png", width: 90%),```asm mov eax, [a]```)
)
#grid(
  columns:2,
  gutter:10pt,
  img(image("14-deb7.png", width: 90%),```asm add eax, 5```),
  img(image("15-deb8.png", width: 90%),```asm sub eax, [b]```)
)
#grid(
  columns:2,
  gutter:10pt,
  img(image("16-deb9.png", width: 90%),```asm mov [x], eax```),
  img(image("17-deb10.png", width: 90%),```asm mov eax, 1```)
)

Так как числа записываются в память друг за другом, и по шине данных проходит ровно 32 бита, то в регистр ```asm eax``` попала не только ```asm a```, но и ```asm b```. Но операции не изменили знак числа, поэтому в конечном итоге мы получили правильный ответ, который записали в память:

#img(image("18-mem3.png", width: 60%),[Память программы после завершения], f:(i)=>{i.display()})

Как мы видим в память записывается весь регистр ```asm eax```, но так как память выделена только для 1 байта, то неициализированные переменные могут перезаписать код, например если в ```asm section .bss``` добавить ```asm nw resb 2```, а в ```asm _start``` добавить перед выходом ```asm mov [nw], 0```, то `15ff` затрется.

Но есть и другие способы решения этой проблемы.
Сначала разберем, что нам необходимо с потерей данных, но все же записать в оперативную память некоторые данные размер которых превышает размер выделенной памяти. Тогда необходимо объявить сколько именно байт мы хотим записать в память, т.е. заменить ```asm mov [x], eax``` #sym.arrow ```asm mov byte[x], eax```.

Но в идеале изначально отсечь все, что не относится к нашему числу, для этого можно заменить ```asm mov eax, [a]``` #sym.arrow ```asm mov ax, [a]```, а дальше продолжить работать с ```asm eax```. Еще есть более сложный способ -- применение маски: дело в том, что если нам необходимо из числа `0xff271369` сделать `0x00000369`, то можно просто воспользоваться логической операцией ```asm and``` с литералом `0x00000fff`, тогда все "ненужные" числа логически умножатся на ноль и останутся только те, что логически умножились на 1. Для данного случая маску можно применить после ```asm mov eax, [a]``` так:```asm and eax, 0x0000ffff```.

Так же стоит отметить, что изначально мы выделяем памяти на 1 байт меньше для ответа, так что использовать ключевое слово ```asm byte``` все равно придется.

= Работа с памятью

В отличии от высокоуровневых языков со строгой типизацией в ассемблере, при выделении памяти в нее можно положить любое значение, оно будет транслированно компилятором в численное значение.

#code(read("lab1.3.asm"), "asm", [Код для работы с памятью])

Скомпилируем, соберем и откроем в отладчике код.
В коде нас интересуют только данные в памяти:

#img(image("19-mem4.png", width: 100%),[Память программы], f:(i)=>{i.display()})

jdlkaslkdja    jadklkjdla   dajklj kkakjd  djjdj


Разбирать данные будем снизу вверх, справа налево, каждые 32 бита, слева направо каждый. Для удобства напишу таблицу, в которой показано какой байт к чему относится, адресация идет на каждый байт, в строке 4 байта поэтому адрес меняется на 4, уменьшается адрес потому что мы читаем снизу вверх (адрес полностью не вместился так что к написанному смещению необходимо прибавить `0x804a000`):\
\
#table(
  columns: (auto, auto, auto, auto, auto, auto),
  inset: 10pt,
  align: horizon,
  [Смещение], [Значение 32 бит], [1 байт], [2 байт],  [3 байт],  [4 байт], 
       
  [30], [`00 00 00 00`], [`f1`],     [`f1`],     [`f1`],     [`f1`],
  [2c], [`00 00 00 00`], [`f1`],     [`alu`],    [`alu`],    [`alu`],
  [28], [`00 00 00 00`], [`alu`],    [`alu`],    [`alu`],    [`alu`],
  [24], [`00 00 00 00`], [`alu`],    [`alu`],    [`alu`],    [`alu`],
  [20], [`00 00 00 00`], [`alu`],    [`alu`],    [`alu`],    [`alu`], 
  [1c], [`00 00 00 00`], [`alu`],    [`alu`],    [`alu`],    [`alu`],
  [18], [`00 08 08 08`], [`alu`],    [`valar`],  [`valar`],  [`valar`],
  [14], [`08 08 12 34`], [`valar`],  [`valar`],  [`ar`],     [`ar`],
  [10], [`56 78 80 01`], [`ar`],     [`ar`],     [`min`],    [`min`],
  [0c], [`0a 6f 6с 6c`], [`sdk`\\n], [`sdk`o],   [`sdk`l],   [`sdk`l],
  [08], [`65 48 0c 23`], [`sdk`e],   [`sdk`H],   [`beta`],   [`beta`],
  [04], [`17 25 10 ff`], [`beta`],   [``],       [`v5`],     [`lue3`],
  [00], [`80 01 00 ff`], [`lue3`],   [`chart`],  [`chart`],  [`val1`],
)

= Определение данных

*Задание*:
Определите в памяти следующие данные:

+ целое число 25 размером 2 байта со знаком;
+ двойное слово, содержащее число -35;
+ символьную строку, содержащую ваше имя (русскими буквами и латинскими буквами).

Вот получившийся по данному заданию код:
#code(read("lab1.4.asm"), "asm", [Определение данных])

Скомпилируем, соберем и откроем в отладчике код.
В коде нас снова интересуют только данные в памяти:

#img(image("20-mem5.png", width: 100%),[Память программы], f:(i)=>{i.display()})

Составим такую же таблицу, что и в предыдущем задании.
#pagebreak()
#table(
  columns: (auto, auto, auto, auto, auto, auto),
  inset: 10pt,
  align: horizon,
  [Смещение], [Значение 32 бит], [1 байт], [2 байт],  [3 байт],  [4 байт], 
       
  [18], [`00 00 00 b9`], [], [],[],[`n`й],
  [14], [`d0 b5 d0 80`], [`n`й], [`n`е],[`n`е],[`n`р],
  [10], [`d1 b4 d0 bd`], [`n`р], [`n`д],[`n`д],[`n`н],
  [0c], [`d0 90 d0 20`], [`n`н], [`n`А],[`n`А],[`n` ],
  [08], [`79 65 72 64`], [`n`y], [`n`e],[`n`r],[`n`d],
  [04], [`6e 41 ff ff`], [`n`n], [`n`A],[`b`],[`b`],
  [00], [`ff dd 00 19`], [`b`], [`b`],[`a`],[`a`],
)

Так как буквы кириллицы не входят в ASCII, то для их записи необходимо 2 байта, для латиницы используется только 1 байт. Тут пример из начала с получением длины не сможет сработать, ведь у нас каждая буква кодируется разным количеством байт.

= Работа с данными

*Задание*: Определите несколькими способами в программе числа, которые
во внутреннем представлении (в отладчике) будут выглядеть как 25 00 и 00 25. Проверьте правильность ваших предположений, введя соответствующие
строки в программу.

Вот получившийся по данному заданию код:
#code(read("lab1.5.asm"), "asm", [Работа с данными])

В данном задании требуется несколькими способами вывести числа. В отладчике все числа выводятся в 16-ричном формате, так что буду работать с ним. Первым способом я выбрал простой ввод в память двух чисел. Чтобы они не "слиплись" используем двойное слово -- 32 бита. 

#img(image("21-mem6.png", width: 60%),[Первый способ], f:(i)=>{i.display()})

Вторым способом я выбрал использование регистров, ведь 16-тибитные ```asm ax```,```asm bx```,```asm cx```,```asm dx``` разделяются на верхние ```asm ah```,```asm bh```,```asm ch```,```asm dh``` и нижние ```asm al```,```asm bl```,```asm cl```,```asm dl```. Таким образом если `0x25` внести в нижний регистр то в отладчике он так и будет, а если в верхний, то он автоматически умножится на 256, т.е. станет `0x2500`.

#img(image("22-deb11.png", width: 50%),[Второй способ], f:(i)=>{i.display()})

= Переполнение

Добавьте в программу переменную ```py F1 = 65535``` размером слово и переменную ```py F2 = 65535``` размером двойное слово. Вставьте в программу команды сложения этих чисел с 1:

```asm
 add [F1],1
 add [F2],1
```

Проанализируйте и прокомментируйте в отчете полученный результат (обратите внимание на флаги).

Вот получившийся код:
#code(read("lab1.6.asm"), "asm", [Переполнение])

Заходим в отладчик и запускаем программу:

#img(image("23-deb12.png", width: 60%),[Запуск], f:(i)=>{i.display()})

Добавляем значения в регистры:

#img(image("24-deb13.png", width: 60%),[Значения в регистрах], f:(i)=>{i.display()})

Устраиваем переполнение для регистра ```asm ax```:

#img(image("25-deb14.png", width: 60%),[Переполнение], f:(i)=>{i.display()})

Так как мы прибавили 1, то при переполнении ax перешагнул на 1 и стал 0, поэтому поднялся нулевой флаг `ZF` и флаг четности `PF`. `AF` и `CF` как флаги переноса свидетельствуют о переполнении регистра.

```asm ebx``` имеет размер в 2 раза больше, поэтому при прибавлении единицы значение в этом регистре станет просто `0x10000`:

#img(image("26-deb15.png", width: 60%),[```asm ebx``` не переполняется], f:(i)=>{i.display()})

= Вывод

В процессе работы были изучены процессы создания, запуска и отладки программ на ассемблере NASM под управлением Linux. Были освоены специфики описания и внутреннего представления данных, а также изучены операции ввода-вывода через прерывания, арифметические операции, работа с памятью и отслеживание переполнения. Этот опыт позволил более глубоко понять внутреннее устройство компьютера, архитектуру и специфику работы операционной системы на низком уровне.

= Контрольные вопросы

1. *Дайте определение ассемблеру. К какой группе языков он относится?*
Ассемблер - низкоуровневый язык программирования, посылающий команды процессору. Язык ассемблера относится к машинно-зависимым языкам программирования.

2. *Из каких частей состоит заготовка программы на ассемблере?*

Заготовка программы на языке ассемблера состоит из трех частей:
- ```asm section .text``` (сегмент кода)
- ```asm section .data``` (сегмент инициализированных данных)
- ```asm section .bss``` (сегмент неинициализированных данных)

3. *Как запустить программу на ассемблере на выполнение? Что происходит с программой на каждом этапе обработки?*
Для подготовки программы к выполнению сперва вызывают транслятор
`nasm` и компоновщик `ld` следующей командой:
```sh nasm -f elf64 lab1.asm -l lab1.lst```
В результате работы транслятор создает объектный файл, которые затем подается на вход компоновщика:
```sh ld -o lab1 lab1.o```
Компоновщик формирует исполняемую программу.

4. *Назовите основные режимы работы отладчика. Как осуществить пошаговое выполнение программы и просмотреть результаты
выполнения машинных команд.*
- `si` – выполнить шаг с заходом в тело процедуры;
- `s` – выполнить шаг, не заходя в тело процедуры.
- `r` - запуск программы
- `br` - установить точку останова
- `lay` - переключиться между слоями
5. *В каком виде отладчик показывает положительные и
отрицательные целые числа? Как будут представлены в памяти
числа: A dw 5,-5 ? Как те же числа будут выглядеть после загрузки в регистр AX?*

5 в шестнадцатеричной системе счисления равно `00000005`, а -5 будет выглядеть как `fffffffb`. В регистре ```asm AX``` число 5 будет выглядеть как `0005`, а число -5 будет выглядеть как `fffb`.

6. *Каким образом в ассемблере программируются выражения?
Составьте фрагмент программы для вычисления С=A+B, где A, В и С – целые числа формата BYTE.*

#code("section .data
  A db 1
  B db 2

section .bss
  C resb 1

section .text
global _start

_start:
  mov al, [A]
  mov ah, [B]
  add al, ah
  mov byte[C], al
", "asm", "C = A+B")


