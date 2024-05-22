import re

def create_pattern(end_char):
    return re.compile(
        r'\b(?:'
        r'char|'
        r'signed\ char|'
        r'unsigned\ char|'
        r'short|'
        r'signed\ short|'
        r'unsigned\ short|'
        r'int|'
        r'signed\ int|'
        r'unsigned\ int|'
        r'long|'
        r'signed\ long|'
        r'unsigned\ long|'
        r'long\ long|'
        r'signed\ long\ long|'
        r'unsigned\ long\ long|'
        r'float|'
        r'double|'
        r'long\ double|'
        r'wchar_t|'
        r'char16_t|'
        r'char32_t|'
        r'bool'
        r')\s+[a-zA-Z][^()\s-]*'
        + re.escape(end_char)+'\s*'
    )

def leks(string):
    replaced = []
    def repf(m):
        replaced.append("Найдено начало процедуры: " + m.group(0) +
            " Замена: " + 'vd%fn%(_%')
        return  'vd%fn%(_%'
    def repla(m):
        replaced.append("Найден Аргумент: " + m.group(0) +
            " Замена: " + 'id%')
        return 'id%'
    def replae(m):
        replaced.append(
            "Найден последний аргумент и закрытие процедуры: " 
            + m.group(0) +
            " Замена: " + 'id%)_%')
        return 'id%)_%'
    def reple(m):
        replaced.append(
            "Найден последний аргумент и закрытие процедуры: " 
            + m.group(0) +
            " Замена: " + 'id%)_%;_%')
        return 'id%)_%;_%'

    string = re.sub(r'\bvoid\s+[a-zA-Z][^()\s-]*\(', 
                    repf, string, count=1)
    string = re.sub(create_pattern(';'), repla, string)
    string = re.sub(create_pattern(');'), reple, string)
    string = re.sub(create_pattern(')'), replae, string)

    for r in replaced:
        print(r)

    return string

def checkleks(string):
    st = string.split("%")
    for i in st:
        if i not in ["vd","fn","(_","id",")_",";_",""]:
            return False
    return True
#
def syntax(string):
    st = string.split("%")
    if st[0] != 'vd':return False
    if st[1] != 'fn':return False
    if st[2] != '(_':return False
    i = 3
    while st[i] == "id": i+=1
    if st[i]   != ')_':return False
    if st[i+1] != ';_':return False
    if st[i+2] != '':return False
    if len(st) > i+3: return False
    return True

inp = input("Введите входную строку: ")
l = leks(inp)
print("Результат лексического анализа: ", l)
print("Результат проверки лексического анализа: ", checkleks(l))
print("Результат синтаксического анализа: ", syntax(l))
