#include <stdio.h>
#include <string.h>

#define MAX_LENGTH 255

void findIdenticalFragments(char* rsi, char* rdx, char* r10) {
    // push rdi
    int r8 = strlen(rsi);
    int r9 = strlen(rdx);
    int r11 = 0;
    if (r8 == 0 || r9 == 0) {
        printf("Одна или обе строки пусты.\n");
        return;
    }
    for (int rcx = 0; rcx < r8; rcx++) {
        for (int rbx = 0; rbx < r9; rbx++) {
            if (rsi[rcx] == rdx[rbx]) {
                int rdi = rcx;
                int rax = rbx;
                while (rdi < r8 && rax < r9 && rsi[rdi] == rdx[rax] && rsi[rdi] != ' ') {
                    rdi++;
                    rax++;
                }
                if (rdi - rcx > 1) {
                    int o = rcx;
                    while (rdi > rcx) {
                        r10[r11] = rsi[rcx];
                        r11++;
                        rcx++;
                    }
                    rcx = o;
                    r10[r11]='\n';
                    r11++;
                }
            }
        }
    }
}

int main() {
    char str1[MAX_LENGTH + 1];
    char str2[MAX_LENGTH + 1];
    
    printf("Введите первую строку: ");
    fgets(str1, sizeof(str1), stdin);
    str1[strcspn(str1, "\n")] = '\0';

    printf("Введите вторую строку: ");
    fgets(str2, sizeof(str2), stdin);
    str2[strcspn(str2, "\n")] = '\0';
    char res[255];
    
    findIdenticalFragments(str1, str2, res);

    printf("%s", res);
    
    return 0;
}

