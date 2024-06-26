# 1. Процессор i8086. Структура основные регистры и взаимодействие частей в процессе функционирования.

Процессор i8086 является 16 битным и строится на базе архитертуры с общей шиной, которая включает в себя шину управления адреса и данных. Процессор может работать с целочисленными и вещественными данными, а так же с символами.

В структурный состав процессора входит устройство управления, АЛУ, блок преобразования адресов и регистры.

Управляющее устройство дешифрует коды команд и формирует управляющие системы. АЛУ выполняет необходимые арифметические и логические преобразования данных. В блоке преобразования адресов из базы и смещения формируется физический адрес в памяти. Регистры используются для временного хранения информации, для быстрого выполнения арифметических действий над данными, для хранения адресов данных в памяти и тд.

Регистры:
1. Общего назначения
    - AX -- Аккумулятор, оптимизирован для выполнения арифметических действий (но это не точно))
    - BX -- Базовый регистр
    - CX -- Счетчик
    - DX -- Расширитель аккумулятора
2. Адресные
    - SI -- регистр указания индекса источника
    - DI -- регистр указания индекса приемника
    - BP -- регистр указания базы стека
3. Управляющие
    - SP -- регистр стека
    - IP -- регистр адресов команд
    - FLAGS -- регистр флагов
4. Аппаратные счетчики
    - CS -- регистр счетчика кодов
    - DS -- регистр счетчика данных
    - ES -- регистр дополнительного сегмента данных
    - SS -- регистр сегмента стека

# 2. Процессор i8086. Адресация оперативной памяти в i8086.

Минимальной адресной единицей памяти является байт. Память представляет собой последовательность байтов.
Номер байта является его физическим адресом в устройстве памяти.

Для размещения программы и данных в памяти выделяются особые области -- сегменты. Сегмент при шеснадцатиразрядной адресации -- фрагмент памяти начинающийся с адреса памяти, кратного 16 и имеющий размер от 1 байта до 64 (2^16 байт) килобайт.

Физический адрес формируется из базового адреса (адреса сегмента) и смещения. Оба адреса 16-ти разрядные. Базовый адрес показывает формально номер сегмента, а сам адрес начала сегмента можно вычислить по формуле $номер*16$ или просто сдвигом номера на 4 бита влево. сам адрес при этом становится 20-ти разрядным, поэтому физические адреса в памяти тоже будут 20-ти разрядными, как и шины адреса.

1. Регистры, хранящие адреса сегментов:
    - CS -- регистр, хранящий адрес сегмента кода
    - DS -- регистр, хранящий адрес сегмента данных
    - CS -- регистр, хранящий адрес сегмента дополнительных данных
    - CS -- регистр, хранящий адрес сегмента стека
2. Регистры, хранящие смещений:
    - IP -- регистр, хранящий адрес смещения кода
    - Смещения данных рассматриваются в основной программе как исполнительный адрес и могут быть записаны в любые регистры
    - SP -- регистр, хранящий адрес смещения стека

# 3. Процессор i8086. Адресация сегментов различных типов

Программа располагается в сегментах 3 типов: сегменты кода, данных (основной и дополнительный) и стека.

1. Сегмент кода располагается в CS, значит команда будет CS:IP, IP -- смещение кода
1. Сегмент стека располагается в SS, значит верхнее значение стека будет SS:SP, SP -- смещение стека
1. Сегмент данных по умолчанию в DS, но можно переключить на ES, если DS не хватает чтоб адресовать все данные. Адреса, используемые в программах на ассемблере (даже транслированные в литералы) являются смещением этих сегментов.

# 4. Процессор i8086. Структура машинной команды. Примеры

Машинная команда -- набор битов, представляющих собой инструкции, для выполнения конкретный действий процессором.

Общая структура состоит из префиксов команд, кодов операции, байта адресации, двух байтов смещения и двух байтов данных.

Пример:```asm mov ax, bx```
`1000101111011001` -> `100010 1 1 11 011 001`

Код операции состоит из операции mov с 2 битами: 1 отвечает за то, что запись ведется в регистр, 2 показывает, что операнды двухбайтовые. В байте адресации первые 2 бита показывают, что операнды регистры и далее идут номера этих регистров.

# 5. Процессор IA-32. Программная модель


- Блок интерфейса с магистралью управляет передачей команд и данных из памяти и обратно. 
- Блок предвыборки команд отвечает за чтение очередных команд из сегмента кода
- Блок декодирования комманд осуществляет расшифровку команды и формирования последовательности управляющих сигналов для ее исполнения.
- Исполнительный блок выполняет комманду
- Блоки управления сегментации и разбиения на страницы формируют физические адреса

Процессоры могут функционировать в одном из 3 режимах:
- Реальной адресации -- процессор работает как i8086, адресует только (2^20) 1 мб памяти, с использованием 32 разрядных расширений. Используется при включения компьютера
- Защищенный режим -- процессор использует 32-разрядный адрес и страничную модель памяти.
- Управление системой -- изоляция от прикладного ПО и операционных систем. Переход в этот режим возможен только аппаратно.

# 6. Процессор i8086. Структура программы



















