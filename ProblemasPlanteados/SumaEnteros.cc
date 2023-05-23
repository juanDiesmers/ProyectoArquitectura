#include <stdio.h>

int main(){
    int x, y;
    printf("Ingrese el valor de x");
    scanf("%d",&x);
    printf("Ingrese el valor de y");
    scanf("%d",&y);

    while (y!=0)
    {
        int carry = x & y; //and
        x = x ^ y; //xor
        y = carry << 1;
    }
    printf("la suma de x e y es : %d\n", x);
    return 0;
}