import subprocess
import os

# Цикл для ввода 1000 значений
for i in range(6000,7000):
    value = str(i*10)  # Используем значение i в качестве ввода
    
    # Запускаем утилиту "lab2.lab2" и передаем ей значение
    process = os.popen(f'echo "{value}" | lab2/lab2')
    
    # Получаем вывод утилиты
    output = process.read()
    process.close()
    
    # Выводим информацию о введенном значении и результат работы утилиты
    print(f"Введено значение {i}: {value}")
    print("Результат работы утилиты:")
    print(output)

