#include <stdio.h>

void mcr(char rsi[], int rcx, int r8) {
    for (int rax = r8 - 1; rax >= 0; rax--) {
        rsi[rax + rcx] = rsi[rax];
    }
}

void mcl(char rsi[], int rcx, int r8) {
    for (int rax = 0; rax < r8 - rcx; rax++) {
        rsi[rax] = rsi[rax + rcx];
    }
    rsi[r8-rcx] = '\0';
}

void swp(char rsi[], int r9, int r10, int r11){
    for (int rcx = 0; rcx < r11; rcx++) {
        char r8 = rsi[r9 + rcx];
        rsi[r9 + rcx] = rsi[r10 + rcx];
        rsi[r10 + rcx] = r8;
    }
}

void len(char rsi[], int* r12){
    *r12 = 0;
    while (rsi[*r12] != 0) (*r12)++;
}

void lnw(char rsi[], int* r13){
    *r13 = 0;
    while (rsi[*r13] != ' ' && rsi[*r13] != 0) (*r13)++;
}

void slp(char rsi[], int rax, int rbx, int r12){
    int r13 = 0;
    int r14 = 0;
    lnw(rsi+rbx, &r13);
    r14 = r13;
    lnw(rsi+rax, &r13);
    if(r13 > r14){
        int o = r13;
        r13 = r14;
        r14 = o;

        o = rax;
        rax = rbx;
        rbx = o;
    } else {rbx += r14-r13;};
    mcr(rsi+rax, r14-r13, r12);
    swp(rsi, rax, rbx, r14);
    mcl(rsi+rbx, r14-r13, r12+r14-r13);
}


void bst(char rsi[])
{
    int rcx, rax;
    int r12 = 0;
    len(rsi, &r12);
    for (rcx = 0; rcx < r12; rcx++)
        for (rax = 0; rax < r12 - rcx; rax++){
            if (rax== 0 || rsi[rax-1] == ' '){
            int rbx = 0;
            lnw(rsi+rax, &rbx);
            rbx += rax + 1;
            if (rbx < r12 - rcx){
                if (rsi[rax] > rsi[rbx])
                    slp(rsi, rax, rbx, r12);
                }
            }
        }
}

int main() {
    char rsi[] = "db1c ac12d b2345de c12345678ef\0                                                                                            ";
    printf("%s\n", rsi);
    bst(rsi);
    printf("%s\n", rsi);
    return 0;
}

