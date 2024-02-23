#import "@docs/bmstu:1.0.0":*
#show: student_work.with(
  caf_name: "Компьютерные системы и сети",
  faculty_name: "Информатика и системы управления",
  work_type: "лабораторной работе",
  work_num: "2",
  discipline_name: "Машинно-зависимые языки и основы компиляции",
  theme: "Программирование целочисленных вычислений",
  author: (group: "ИУ6-42Б", nwa: "А. П. Плютто"),
  adviser: (nwa: ""),
  city: "Москва",
  table_of_contents: true,
)

= Ввод чисел

Перед выполением лабораторной работы, следует подумать об организации ввода-вывода. В предыдущей лабораторной уже описывалось как организовать ввод строк, поэтому задача сводится только к их обработке, но для начала напишем входную процедуру которая будет принимать ввод и отдавать его функции по обработке.

== Процедура ```asm geti```

#img(image("flow/geti.svg", width:24%), [Схема алгоритма для ```asm geti```])

#let input = parserasm(read("input.asm"))
#code(funcstr(input, "geti:"), "asm", [Функция ```asm geti```])

Следует немного описать функцию. На вход мы передаем значения в регистрах. Для начала процедура организует вывод приглашения на ввод, из предыдущей лабораторной мы уже знаем как оно организовывается. Ссылка на первую букву приглашения будем просить ввести через регистр ```asm ebx```, количество букв через ```asm eax```. После этого будем читать введенные пользователем данные, поэтому нам нужна так же ссылка на буфер для хранения этих данных, запросим ее в регистр ```asm edx``` и длина этого буфера в регистре ```asm ecx```. Так как буквы по определению занимают больше места чем числа в памяти дополнительной памяти для обработки нам не нужно. Поэтому возвращать процедура ничего не будет, а будет только записывать в буфкр число введенное пользователем.

После ввода числа пользователь нажимает на enter (LF) и число записывается поциферно в память. Теперь нам необходимо достать каждую цифру, вычесть из нее код числа $0$ (```asm sub eax, '0'```) и сложить эту цифру с предыдущими, умноженными на 10.

Для этого напишем новую процедуру, которая будет брать адрес строки в ```asm edx``` и длину этой строки в ```asm ecx``` и после преобразования этой строки в число класть это числов регистр ```asm eax```.

Потом мы просто запишем число из ```asm eax``` в буфер, вернем все регистры из стека и выйдем из процедуры ```asm geti```.

#pagebreak()
== Процедура ```asm stoi```

#img(image("flow/stoi.svg", width:35%), [Схема алгоритма для ```asm stoi```])

=== Начало

Итак, вот начало процедуры преобразования строки в число:

#code(funcstr(input, "stoi:"), "asm", [Процедура ```asm stoi``` (начало)])

В стек загружаем все использованные в процедуре регистры, чтобы их не потерять после окончания выполнения. Готовим регистры для цикла ```asm eax```, как регистр арифмитических оперций, будет содержать в себе все число, что мы получили, поэтому зануляем его. Так как мы будем производить умножение, чтобы не потерять адрес, куда в последствии необходимо сохранить число переместим его в регистр адреса ```asm esi```.

Для умножения получившегося числа на 10 используем регистр ```asm ebx```(например пользователь ввел ```asm '10'``` мы обработали и поместили в ```asm eax``` $1$ и после обработки $0$ нам необходимо сделать 2 операции, чтобы получить исходное число: умножить ```asm eax``` на $10$ и прибавить $0$).

Регистр ```asm edx``` будем так же использовать как временный буфер для текущей цифры. Стоит сказать, что все цифры и знак минус входят в ACSII, поэтому будут занимать лишь 1 байт.

Перед началом цикла прочтем 1 байт в ```asm dl``` (младший байт ```asm edx```). Если 1 байт оказался с минусом, то число отрицательно, это необходимо запомнить. Создадим метку, в которой положим в стек число 1, как уведомление о том, что необходимо вернуть дополнительный код числа. После этого переходим к циклу.

#code(funcstr(input, "stoiminus:"), "asm", [Если число отрицательно кладем в стек 1])

Если же число положительное положим 0 и перейдем к циклу.

Но перед циклом необходимо написть обработчик одной цифры. Цифра эта будет занимать 1 байт, поэтому процедура будет брать только регистр ```asm dl``` и работать дальше с ним.

=== Процедура ```asm ctoi```

#img(image("flow/ctoi.svg", width:24%), [Схема алгоритма для ```asm ctoi```])

#code(funcstr(input, "ctoi:"), "asm", [Процедура ```asm ctoi```])

Итак, мы получили число, которое должно соответствовать коду от 0 до 9 в таблице ASCII, если это так, то вычитаем из этого числа ```asm '0'``` и получаем цифру, иначе просто вернем число без изменений.

Можно было бы написать обработчик, который при нахождении подобного числа завершал программу, или писал ошибку в stderr, но я думаю, что и такая простая проверка подойдет для выполнения данных лабораторных. В любом случае можно подобное реализовать, просто поменяв метки перехода в конец процедуры на метки реализации вывода ошибки.

И так, мы получили цифру, теперь необходимо выйти из процедуры:

#code(funcstr(input, "ctoie:"), "asm", [Процедура ```asm ctoi``` (выход)])

Вернемся к реализации цикла.

=== Цикл

#code(funcstr(input, "stoil:"), "asm", [Процедура ```asm stoi``` (цикл)])

Для начала переместим в ```asm dl``` новую цифру. Стоит отметить, что если число положительное, то на первой итерации цикла мы просто второй раз обратимся к тому же адресу памяти, к какому обращались, когда проверяли число на отрицательность, иначе мы обратимся к следующему байту, который идет после минуса. 

После этого выполним операцию инкремента (добавления единицы) в регистр с адресом, для того, чтобы в следующей итерации цикла взять новое, еще не обработанное число. 

Проверим то число, которое мы только что взяли, не является ли оно завершением строки (LF). В следующих лабораторных работах, когда появится необходимость вводить числа через пробел сюда же добавим и проверку на символ пробела. Если в ```asm dl``` символ пробела, то выходим из цикла.

Теперь необходимо вызвать функцию ```asm ctoi``` и после ее выполнения в ```asm dl``` наконец будет цифра введенного числа. Добавим эту цифру в конец ```asm eax```. Для этого, как описывалось ранее умножим ```asm esx``` на 10, не забыв, что при этой операции используется ```asm edx```  (поэтому, чтобы не потерять цифру уберем ее в стек). После умножения достаем цифру из стека и складываем с получившимся числом.

При вводе пользователь мог занять весь буфер огромным числом, поэтому символ LF мог и не поместиться в буфер, поэтому добавим в цикл проверку на конец буфера.

После этого снова переходим к метке цикла и начинается новая итерация.

=== Окончание

Когда цикл завершит свою работу мы переходим к метке ```asm stoie```.

#code(funcstr(input, "stoie:"), "asm", [Процедура ```asm stoi``` (конец 1)])

Тут нам длина буфера уже не важна, ведь он уже прочитан. Поэтому заносим в регистр ```asm ecx``` флаг минуса, который лежит наверху стека. Теперь когда у нас есть модуль числа можно и запросить его дополнительный код, если это необходимо. Прверяем ```asm ecx``` и если там лежит 1 переходим к метке для умножения eax на -1, иначе в конец.

#code(funcstr(input, "stoiaddm:"), "asm", [Преобразуем число в отрицательное])

Регистр ```asm edx``` уже не нужен, флаг тоже, поэтому просто перемещаем -1 в ```asm ecx``` и умножаем ```asm eax``` на ```asm ecx```. После чего перемещаемся в конец.

Стоит отметить, что подобная операция эквивалентна ```asm not eax```,```asm add eax, 1```.

Возвращаем все регистры, как они были, кроме ```asm eax```, в котором ответ и выходим из процедуры ```asm stoi```.
#code(funcstr(input, "stoiend:"), "asm", [Процедура ```asm stoi``` (конец 2)])

Как уже было сказано ранее, после выполнения этой процедуры продолжится выполнение ```asm geti```, которая положит значение ```asm eax``` в буфер пользователя и, вернув все регистры в их начальное состояние завершится.

= Вывод чисел

После выполнения арифмитических операций программа должна вывести пользователю результат выполнения перед ее завершением. Для этого напишем еще несколько процедур, которые теперь будут обратно преобразовывать число в строку. Тут мы для удобства будем пользоваться все той же памятью в которой лежит число и просто впоследствии сохраним туда строку. Но для использования иного буфера необходимо поменять лишь несколько строк.

== Процедура ```asm outi```

#img(image("flow/outi.svg", width:24%), [Схема алгоритма для ```asm outi```])

#let output = parserasm(read("output.asm"))
#code(funcstr(output, "outi:"), "asm", [Процедура ```asm outi```])

Вот первая процедура, она все так же выдает строку, которую мы передаем в ```asm ecx```. Длина этой строки лежит в ```asm edx```. В ```asm eax``` лежит ссылка на буфер. Длину буфера предполагаем достаточной, что бы вывести все число целиком.

Процедура начинает свое выполнение опять с сохранения всех регистров в стек. Затем мы вызываем прервывание на вывод предложения перед числом, после этого готовим регистры и выполняем  процкдуру ```asm itos```, которая преобразует данное нам число в строку и сама сохраняет эту строку в память, где было число. И после выполнения процедуры преобразования мы снова организуем вывод только для числа. Затем достаем из стека значения регистров и завершаем процедуру.

#pagebreak()
== Процедура ```asm itos```

Теперь давайте подробнее разберем процедуру ```asm itos```.

#img(image("flow/itos.svg", width:50%), [Схема алгоритма для ```asm itos```])

=== Начало

#code(funcstr(output, "itos:"), "asm", [Процедура ```asm itos``` (Начало)])

Опять убераем все используемые регистры в стек.
Перемещаем полученный адрес числа в ```asm esi```. После чего получаем само число по этому адресу. Его записываем в регистр ```asm eax```.В регистр ```asm ebx``` записываем основание системы счисления, так же как мы делали на вводе, но тут использоваться оно будет для деления. Если само число меньше нуля то необходимо перед циклом сразу убрать в память ```asm '-'```. Иначе просто переходим к циклу.


#code(funcstr(output, "itosminus:"), "asm", [Добавляем минус в буфер])

Добавляем минус в буфер, прибавляем единицу в адрес, что бы этот минус не затерся последней цифрой числа (ведь при делении на 10 мы первой получим именно последнюю цифру). После этого берем чисамо число по модулю, т.е. преобразуем его дополнительный код в нормальный. Потом так же переходим в цикл.

=== Цикл

#code(funcstr(output, "itosl:"), "asm", [Процедура ```asm itos``` (Цикл)])

Тут мы будем использовать беззнаковое деление (так как со знаком мы уже разобрались, само число по модулю). При выполнении операции ```asm div``` результат деления попадает ```asm eax```, что позволяет нам не делать никаких других логических преобразований, регистр и так с каждой итерацией цикла будет уменьшаться на 10, т.е. на одну цифру. Эта цифра будет остатком от деления на 10 и будет храниться в ```asm edx```, прибавляя к этому регистру ```asm '0'``` получим ASCII код этой цифры, которую и сохраним в памяти. Мы знаем что этот код занимает лишь байт, поэтому он весь поместился в ```asm dl```.

После записи в текущий байт переместимся на следующий, иначе число затрется.

Когда будет последняя итерация в ```asm eax``` останется только одна цифра, после деления на 10 она перенесется в остаток, а с сам регистр останется 0, поэтому когда это произойдет мы выйдем из цикла.

И перепрыгиваем снова на метку цикла, чтобы начать новую итерацию.

=== Окончание

#code(funcstr(output, "itose:"), "asm", [Процедура ```asm itos``` (Конец)])

В конце возвращаем значения регистров на свои места. Берем начальный адрес и вычитаем его из конечного, таким образом, получая длину всей строки. Эту длину запишем в ```asm ecx```.

А теперь немного подробнее посмотрим на проблему которую я упоминал ранее. При делении числа на 10 мы получаем последнюю его цифру, таким образом число $1234$ будет записано нами в памяти как ```asm '4321'``` ($-1234$ #sym.arrow ```asm '-4321'```).

Для решения этой проблемы напишем еще одну процедуру, которую назовем ```asm reverse```. Вызовем ее, вернем значения в оставшиеся регистры и завершим процедуру ```asm itos```.

#pagebreak()
== Процедура ```asm reverse``` 

#img(image("flow/reverse.svg", width:25.5%), [Схема алгоритма для ```asm reverse```])

#code(funcstr(output, "reverse:"), "asm", [Процедура ```asm reverse``` (Начало)])

В ```asm eax``` передадим адрес числа, а в ```asm ecx``` количество цифр в числе. Суть алгоритма заключается в том, что ```asm ebx``` указывает на начало, а ```asm edx``` на конец числа, и при каждой итерации они меняют значения друг друга на противоположные, таким образом за половину числа мы поменяем ровно все значения. (```asm ebx``` и ```asm edx``` указывают на начало и конец, как палочка в буквах).

Оба регистра это адреса, но указывают они на байты, поэтому для сохранения самих значений будем использовать только ```asm al```. Первым делом берем первый символ и проверяем не минус ли он.

Напишем обработчик для этого случая:

#code(funcstr(output, "reverseminus:"), "asm", [Обрабатываем минус])

Просто смещаем регистр указывающий на начало на 1 и входим в цикл.

#code(funcstr(output, "reversel:"), "asm", [Процедура ```asm reverse``` (Цикл)])

В цикле мы проверяем, чтобы ```asm ebx``` был строго меньше ```asm edx``` (если больше -- число четное, если равен -- число нечетное).
Потом перемещаем текущие значения в свободные регистры и, меняя их местами, сразу записываем обратно. Дальше мы увеличиваем ```asm ebx``` и уменьшаем ```asm edx```, "двигая" их друг к другу.

#code(funcstr(output, "reversee:"), "asm", [Процедура ```asm reverse``` (Конец)])

В конце возвращаем все регистры на место и выходим из процедуры.


= Выполнение лабораторной работы
== Задание

Вычислить целочисленное выражение:

$ f = (a-c)^2 + 2 times a times c^3/(k^2+1) $

== Цель работы

Изучение форматов машинных команд, команд
целочисленной арифметики ассемблера и программирование целочисленных
вычислений. 

== Выполнение

=== Работа с данными

Проинициализируем все сообщения пользователю. Зарезервируем 12 байт для каждого из переменных. 12 байт потому что минимальное число типа целочисленное $−2 147 483 648$ (оно же максимальное по количеству знаков, их 11), добавляя еще знак переноса получаем максимальное значение в 12 байт.

#let lab2 = parserasm(read("lab2.asm"))
#code(funcstr(lab2, "section .data")+funcstr(lab2, "section .bss"), "asm", [Выделяем и инициализируем необходимые данные])

Я сразу разбил выполнение программы на блоки, первый из которых получение данных.

=== Получение данных

#img(image("flow/getack.svg", width:70%), [Схема алгоритма для ```asm getack```])

#code(funcstr(lab2, "getack:"), "asm", [Запрашиваем данные на ввод])

Для этого просто перемещаем приглашение позльзователю, длину приглашения, ссылку на буфер для данных и длину буфера в нужные регистры и вызываем ```asm geti```. Проделываем эту процедуру 3 раза и получаем в памяти 3 числа, готовых к обработке.

Все выполнения арифмитических операций будет в```asm calc``` переходим в нее, когда значения успешно введены.

=== Вычисление значения функции

#img(image("flow/calc.svg", width:21%), [Схема алгоритма для ```asm getack```])

Перепишем задание и разобъем его на шаги.
$ f = (a-c)^2 + 2 times a times c^3/(k^2+1) $
1. $a-c$ 
2. $(a-c)^2$
3. $2 times a$
4. $c^3$
5. $k^2$
6. $k^2+1$
7. $2 times a times c^3$
8. $2 times a times c^3\/(k^2+1)$
9. $(a-c)^2 + 2 times a times c^3\/(k^2+1)$



#code(funcstr(lab2, "calc:"), "asm", [Вычисляем значение функции])

В начале сохраним в стеке значение `a`, оно нам понадобится для шага 3. Выполним шаг 1 и запишем значение в ```asm eax```. После чего умножим этот регистр сам на себя. Итак, в ```asm eax``` лежит значение шага 2, оно нам не нужно до 10 шага, поэтому уберем его в стек, предварительно достав от туда `a`.

Умножим ```asm eax``` на 2 и поместим значение в стек, оно нам не понадобится до 7 шага. Переместим значение `c` в ```asm eax``` и умножим ```asm eax``` на `c` два раза. Куб `c` нам так же не понадобится до 7 шага, тоже уберем в стек. Умножим `k` саму на себя и прибавим к ней единицу.

Таким образом мы сделали все простейшие операции, осталось только вынуть из стека все значения, которые у нас получились. $c^3$ #sym.arrow ```asm eax```; $2 times a$ #sym.arrow ```asm ebx```. Умножаем ```asm eax``` на ```asm ebx``` и получаем ответ на 7 шаг.

Для 8 шага необходимо подготовить регистр ```asm edx```. При делении используется расширенная версия регистра ```asm eax```: ```asm edx:eax```, поэтому если в ```asm edx``` у нас нет расширения для ```asm eax```, то необходимо заполнить ```asm edx``` нулями, если число положительно и единицами, если число отрицательно. Для этого перед делением вызовем ```asm cdq```.

После этого просто делим со знаком весь результат 7 шага на $k^2+1$. В стеке осталось лежать только $(a-c)^2$, достаем и это значение, суммируем с результатом деления и получаем целочисленный ответ. Осталось только вывести ответ и завершить программу.

=== Вывод и завершение

#img(image("flow/outandexit.svg", width:20%), [Схема алгоритма для ```asm getack```])
#code(funcstr(lab2, "outandex:"), "asm", [Вывод и выход])

Перемещаем получившееся значение в память, а ссылку указываем в регистр. После этого указываем сообщение перед выводом и вызываем вывод.

После того, как вывод отработает остается только вызвать завершение программы.

=== Компиляция

Ввод, вывод и код лабораторной я ранес в отдельные файлики, которые и назвал ```sh input.asm```,
```sh output.asm``` и ```sh lab2.asm```.

Поэтому компилировать их будем тоже отдельно, а после этого соберем.

Вот, что необходимо ввести в терминал, для компиляции и сборки всех 3 файлов:

#code("mod=lab2/lab2 # Название ассемблерного файла без расширения
nasm -f elf -o $mod.o $mod.asm
nasm -f elf -o lab2/input.o lab2/input.asm
nasm -f elf -o lab2/output.o lab2/output.asm
ld -m elf_i386 -o $mod $mod.o lab2/input.o lab2/output.o", "sh", "Команда в терминале")


== Отладка

Отладим все выполнение, заодно посмотрим как работают операции ввода-вывода.

=== Отладка ввода

Первой процедурой посмотрим выполнение ```asm stoi```, так как простейший ввод и вывод был показан в предыдущей лабораторной работе.

Введем при запросе `a` большое отрицательное число: $-123477790$.

#grid(
  columns:2,
  gutter:10pt,
  img(image("img/1.png", width: 90%), "Запуск"),
  img(image("img/2.png", width: 90%), "Сохраняем регистры")
)
#grid(
  columns:2,
  gutter:10pt,
  img(image("img/3.png", width: 90%),"Переносим 1-ый символ"),
  img(image("img/4.png", width: 90%),"Обрататываем минус")
)
#grid(
  columns:2,
  gutter:10pt,
  img(image("img/5.png", width: 90%),"Заходим в цикл"),
  img(image("img/6.png", width: 90%),[Заходим в ```asm ctoi```])
)
#grid(
  columns:2,
  gutter:10pt,
  img(image("img/7.png", width: 90%), [Выходим из ```asm ctoi```]),
  img(image("img/8.png", width: 90%), "Готовим цифру")
)
#grid(
  columns:2,
  gutter:10pt,
  img(image("img/9.png", width: 90%),[Добавляем к ```asm eax```]),
  img(image("img/10.png", width: 90%),[Добавляем 2-ую цифру])
)
#grid(
  columns:2,
  gutter:10pt,
  img(image("img/11.png", width: 90%),[Добавляем 3-ую цифру]),
  img(image("img/12.png", width: 90%),[Добавляем 4-ую цифру])
)
#grid(
  columns:2,
  gutter:10pt,
  img(image("img/13.png", width: 90%), [Добавляем 5-ую цифру]),
  img(image("img/14.png", width: 90%), [Добавляем 6-ую цифру])
)
#grid(
  columns:2,
  gutter:10pt,
  img(image("img/15.png", width: 90%),[Добавляем 7-ую цифру]),
  img(image("img/16.png", width: 90%),[Добавляем 8-ую цифру])
)
#grid(
  columns:2,
  gutter:10pt,
  img(image("img/17.png", width: 90%),[Добавляем 9-ую цифру]),
  img(image("img/18.png", width: 90%),[Инвертируем и выходим])
)
Более подробно о работе этой функции я расписал в части 1.2, поэтому тут приведу только скриншоты с подписями. В конечном итоге мы получили ответ в регистре ```asm eax``` теперь переносим его в память и смотрим как он отображается в памяти:

#img(image("img/19.png", width: 60%),[Память программы], f:(i)=>{i.display()})

=== Отладка арифметических операций

Для проверки ```asm calc``` необходимы числа поменьше, поэтому перезапустим программу и с помощью команды ```sh break calc``` устрановим точку останова уже непосредственно перед арифмитическими операциями.

В качестве переменных будем использовать $a=1; c=-13; k=5$. 

$ f = (1 - (-13))^2 + 2 times 1 times (-13)^3/(5^2+1) = 14^2 + 2 times -2197/26 = \ = 196 + (-4394)/26 = 196-169 = 27 $

При выполнении деления перед умножением в результате мы получили бы $-84,5$, остаток отбросился и результат был бы неверен. 

#grid(
  columns:2,
  gutter:10pt,
  img(image("img/21.png", width: 90%),"Готовим отладчик"),
  img(image("img/22.png", width: 90%),[Значения в регистрах])
)
#grid(
  columns:2,
  gutter:10pt,
  img(image("img/23.png", width: 90%), [```asm sub eax, ebx```]),
  img(image("img/24.png", width: 90%),[```asm mul eax```])
)
#grid(
  columns:2,
  gutter:10pt,
  img(image("img/25.png", width: 90%),[Возвращаем `a`]),
  img(image("img/26.png", width: 90%),[```asm mov edx, 2```])
)
#grid(
  columns:2,
  gutter:10pt,
  img(image("img/27.png", width: 90%),[```asm mul edx```]),
  img(image("img/28.png", width: 90%),[```asm mov eax, ebx```])
)
#grid(
  columns:2,
  gutter:10pt,
  img(image("img/29.png", width: 90%),[```asm mul ebx```]),
  img(image("img/30.png", width: 90%),[```asm mul ebx```])
)
#grid(
  columns:2,
  gutter:10pt,
  img(image("img/31.png", width: 90%),[```asm mov eax, ecx```]),
  img(image("img/32.png", width: 90%),[```asm mul ecx```])
)
#grid(
  columns:2,
  gutter:10pt,
  img(image("img/33.png", width: 90%),[```asm add eax, 1```]),
  img(image("img/34.png", width: 90%),[```asm mov ecx, eax```])
)
#grid(
  columns:2,
  gutter:10pt,
  img(image("img/35.png", width: 90%),[```asm pop eax```]),
  img(image("img/36.png", width: 90%),[```asm pop ebx```])
)
#grid(
  columns:2,
  gutter:10pt,
  img(image("img/37.png", width: 90%),[```asm mul ebx```]),
  img(image("img/38.png", width: 90%),[```asm cdq```])
)
#grid(
  columns:2,
  gutter:10pt,
  img(image("img/39.png", width: 90%),[```asm idiv ecx```]),
  img(image("img/40.png", width: 90%),[```asm pop ecx```])
)
#img(image("img/41.png", width: 50%),[```asm add eax, ecx```],  f:(i)=>{i.display()})

Выше приведен полный арифметический разбор всех операций, а в отладчике просто наглядно видно какие значения лежат в регистрах.

Теперь напишем пару простых тестов, которые покажут правильность выполнения программы. Запускать их будем вызывая саму программу, не испозьзуя деббагер.

$ a=1; c=13; k=5\ f = (1 - 13))^2 + 2 times 1 times 13^3/(5^2+1) = 12^2 + 2 times 2197/26 = \ = 144 + (4394)/26 = 144+169 = 313 $

#img(image("img/72.png", width: 40%),[Тест 1],  f:(i)=>{i.display()})

$ a=13; c=-13; k=25\ f = (13 - (-13))^2 + 2 times 13 times (-13)^3/(25^2+1) = 26^2 + 26 times -2197/626 = \ = 676 + (-57122)/626 = 676 - 91 = 585 $

#img(image("img/73.png", width: 40%),[Тест 2],  f:(i)=>{i.display()})

$ a=1; c=-1000; k=0\ f = (1 - (-1000))^2 + 2 times 1 times (-1000)^3/(0^2+1) = 1001^2 + 2 times (-1000000000) =\ =1002001 - 2000000000 = -1998997999 $

#img(image("img/74.png", width: 40%),[Тест 3],  f:(i)=>{i.display()})

=== Отладка вывода

Мы получили ответ к задаче и осталось его только вывести.

Так как адреса памяти все равно дают мало представнения о том, как процедура выполняется для ```asm reverse``` в основном приведу только значения, хранящиеся в памяти до и после.

#grid(
  columns:2,
  gutter:10pt,
  img(image("img/42.png", width: 90%),[Переходим к ```asm outandex```]),
  img(image("img/43.png", width: 90%),[Вызываем ```asm outi```])
)
#grid(
  columns:2,
  gutter:10pt,
  img(image("img/44.png", width: 90%),[Выводим строку перед числом]),
  img(image("img/46.png", width: 90%),[Вызываем ```asm itos```])
)
#grid(
  columns:2,
  gutter:10pt,
  img(image("img/47.png", width: 90%),[Обрабатываем 1 цифру]),
  img(image("img/48.png", width: 90%),[Обрабатываем 2 цифру])
)
#grid(
  columns:2,
  gutter:10pt,
  img(image("img/49.png", width: 90%),[Конец ```asm itos```]),
  img(image("img/50.png", width: 90%),[Вызываем ```asm reverse```])
)
#grid(
  columns:2,
  gutter:10pt,
  img(image("img/51.png", width: 90%),[Входим в цикл]),
  img(image("img/52.png", width: 90%),[Проверяем условие])
)
#grid(
  columns:2,
  gutter:10pt,
  img(image("img/53.png", width: 90%),[Память до цикла]),
  img(image("img/54.png", width: 90%),[Память после цикла])
)
#grid(
  columns:2,
  gutter:10pt,
  img(image("img/55.png", width: 90%),[Завершаем ```asm itos```]),
  img(image("img/56.png", width: 90%),[Готовим число к выводу])
)
#grid(
  columns:2,
  gutter:10pt,
  img(image("img/57.png", width: 90%),[Выведенный ответ]),
  img(image("img/58.png", width: 90%),[Программа завершилась])
)

#pagebreak()
=== Дизассемблирование кода и расшифоровка команд

Запустим утилиту ```sh objdump```: ```sh objdump -d $mod```. Посмотрим на код в двочином (для удобства шеснадцатеричном) виде.

#grid(
  columns:2,
  gutter:10pt,
  img(image("img/59.png", width: 90%),[```asm _start``` и ```asm getack```]),
  img(image("img/60.png", width: 90%),[```asm calc```])
)
#grid(
  columns:2,
  gutter:10pt,
  img(image("img/61.png", width: 90%),[```asm outandex```]),
  img(image("img/62.png", width: 88%),[```asm geti```])
)
#grid(
  columns:2,
  gutter:10pt,
  img(image("img/63.png", width: 90%),[```asm ctoi```, ```asm ctoie``` и ```asm stoi```]),
  img(image("img/64.png", width: 90%),[```asm stoiminus```, ```asm stoil``` и ```asm stoie```])
)
#grid(
  columns:2,
  gutter:10pt,
  img(image("img/65.png", width: 90%),[```asm stoiaddm```, ```asm stoiend``` и ```asm outi```]),
  img(image("img/66.png", width: 90%),[```asm itos```, ```asm itosminus``` и ```asm itosl```])
)
#grid(
  columns:2,
  gutter:10pt,
  img(image("img/67.png", width: 90%),[```asm itose```, ```asm reverse``` и ```asm reverseminus```]),
  img(image("img/68.png", width: 90%),[```asm reversel``` и ```asm reversee```])
)

Для разбора команды возьмем команду ```asm mov```.

При компиляции языком ассемблера команда ```asm mov``` может быть заменена на множество команд: это зависит от операндов.

Приведем таблицу команды ```asm mov```. Стоит отметить, что в данной таблице не указаны перемещения из/в системные (отладочные) регистры.

#pagebreak()
#table(
  columns: 3,
  inset: 10pt,
  align: horizon,
  [`89 /r`],   [`10001000 | modregr/m`], [```asm mov r/m8, r8```],
  [`89 /r`],   [`10001001 | modregr/m`], [```asm mov r/m16, r16```],
  [`89 /r`],   [`10001001 | modregr/m`], [```asm mov r/m32, r32```],
  [`8A /r`],   [`10001010 | modregr/m`], [```asm mov r8, r/m8```],
  [`8B /r`],   [`10001011 | modregr/m`], [```asm mov r16, r/m16```],
  [`8B /r`],   [`10001011 | modregr/m`], [```asm mov r32, r/m32```],
  [`8C /r`],   [`10001100 | mod0sregr/m`], [```asm mov r/m16(32), sreg```],
  [`8E /r`],   [`10001110 | mod0sregr/m`], [```asm mov sreg, r/m16(32)```],
  [`A0`],      [`10100000 | off_low8/16bit | off_high8/16bit`], [```asm mov al, moffs8```],
  [`A1`],      [`10100001 | off_low8/16bit | off_high8/16bit`], [```asm mov ax, moffs16```],
  [`A1`],      [`10100001 | off_low8/16bit | off_high8/16bit`], [```asm mov eax, moffs32```],
  [`A2`],      [`10100010 | off_low8/16bit | off_high8/16bit`], [```asm mov r8, imm8```],
  [`A3`],      [`10100011 | off_low8/16bit | off_high8/16bit`], [```asm mov r16, imm16```],
  [`A3`],      [`10100011 | off_low8/16bit | off_high8/16bit`], [```asm mov r32, imm32```],
  [`B0 + rb`], [`10110reg | data8bit `], [```asm mov r8, imm8```],
  [`B8 + rw`], [`10111reg | data16bit`], [```asm mov r16, imm16```],
  [`B8 + rd`], [`10111reg | data16bit`], [```asm mov r32, imm32```],
  [`C6 /0`],   [`11000110 | mod000r/m`], [```asm mov r/m8, imm8```],
  [`C7 /0`],   [`11000111 | mod000r/m`], [```asm mov r/m16, imm16```],
  [`C7 /0`],   [`11000111 | mod000r/m`], [```asm mov r/m32, imm32```],
)


Для расшифровки возьмем 3 команды ```asm mov```. Перемещение адреса в регистр, перемещение регистра в регистр, перемещение в адрес, в указанный в регистре, значения другого регистра.

==== Перемещение адреса в регистр
#img(image("img/69.png", width: 70%),[```asm mov edx, k```],  f:(i)=>{i.display()})
Адрес определяется в процессе копиляции, поэтому является константой. Формально для процессора мы перемещаем обычный длинный литерал. О том, что этот литерал -- адрес в оперативнй памяти помнит только программист.

Выпишем шеснадцатеричный код и переведем его в двоичный:

``` ba 3c a0 04 08 = 1011 1010  0011 1100 1010 0000 0000 0010 0000 0100= 
= 10111 010 0111100101000000000001000000100```

Эта команда подходит под шаблон `B8 + rd`, поэтому будем разбирать из него. Сама команда ```asm mov``` записана как `10111` потом идет регистр ```asm edx``` -- `010`. После записан `imm32` -- наш адрес.

==== Перемещение из регистра в регистр

#img(image("img/70.png", width: 70%),[```asm mov ecx, eax```],  f:(i)=>{i.display()})

``` 89 с1  = 1000 1001  1100 0001 = 100010 01 11 000 001```

Где `100010` -- код ассемблерной команды ```asm mov```. `01` -- первое число записи означент направление, в данном случае из регистра, второе указывают на то, что операнды 4-тырех байтовые. `11` -- указывает на то, что операнды - регистры. Далее идут номера самих регистров ```asm 000 = eax```, ```asm 001 = ecx```.

==== Перемещение из регистра в адрес в регистре

#img(image("img/71.png", width: 70%),[```asm mov [ebx], eax```],  f:(i)=>{i.display()})

``` 89 03  = 1000 1001  0000 0011 = 100010 01 00 000 011```

Где `100010` -- код ассемблерной команды ```asm mov```. `01` -- первое число записи означент направление, в данном случае из регистра, второе указывают на то, что операнды 4-тырех байтовые. `00` -- указывает на то, что смещение в команде 0 байт, это и отличает эту команду от предыдущей, т.к. теперь мы интерпритируем принимающий регистр как адрес в оперативной памяти, в который мы записываем ```asm eax``` без смещения. Далее идут номера самих регистров ```asm 000 = eax```, ```asm 011 = ebx```.

== Вывод 

В процессе выполнения лабораторной работы были созданы, отлажены и дизассемблированны библеотеки ввода-вывода на ассемблере. Были проделаны арифметические операции, использован стек и оперативная память. Все арифметические операции были так же отлажены и дизассемблированны. Был показан механизм определения команд ассемблера на основе двоичного кода.
