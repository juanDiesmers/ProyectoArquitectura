#Cálculo de los n primeros números en la serie de Fibbonacci

INIT_N:  MOV R2, #20        # carga el valor de n en R2

         ; Inicialización de variables
         MOV R3, #0         # t1 = 0
         MOV R4, #1         # t2 = 1
         MOV R5, #0         # índice i = 0

         ; Asignación de t1 a fib[0]
         MOV ACC, R3        # carga el valor de t1 en ACC
         MOV DPTR, #fib     # carga la dirección base de fib en DPTR
         MOV [DPTR], ACC    # mueve el valor de ACC a la posición de memoria en DPTR

LOOP:    MOV A, R5          # carga el valor de i en A
         CJZ END_LOOP       # salta a END_LOOP si i == 0
CALCULATE:
         MOV A, R3          # carga el valor de t1 en A
         MOV ACC, R4        # carga el valor de t2 en ACC
         ADD A, ACC         # suma t1 + t2
         MOV R6, A          # guarda el valor de la suma en R6

         MOV ACC, R6        # carga el valor de la suma en ACC
         MOV DPTR, #fib     # carga la dirección base de fib en DPTR
         ADD DPTR, R5       # suma el índice i a la dirección base de fib
         MOV [DPTR], ACC    # mueve el valor de ACC a la posición de memoria en DPTR

         MOV R3, R4         # t1 = t2
         MOV R4, R6         # t2 = nextTerm
         DEC R5             # i--
         JZ END_LOOP        # salta a END_LOOP si i == 0
         JMP LOOP           # salta al inicio del loop

END_LOOP:
         # Fin del programa
         RET               # retorna de la función

fib:     D B 50 DUP(0)     # reserva un espacio de 50 bytes para el arreglo fib
