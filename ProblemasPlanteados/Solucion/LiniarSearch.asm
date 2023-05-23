# liniar search in an array

INIT_LOOP:  
LOAD_SIZE:  MOV ACC, CTE        # carga la direccion de SIZE en ACC
            SIZE                # CTE - direccion de SIZE
            MOV DPTR, ACC       #  mueve la diereccion de SIZE a DPTR
            MOV ACC, [DPTR]     # Carga [SIZE] en ACC

NEG_SIZE:   INV ACC             # complemento a1 de SIZE
            0x01                # CTE  +1
            ADD ACC, A          # ACC = -SIZE(complemento a2)
            MOV A,ACC           # carga -SIZE en el registro A

Load_it:    MOV ACC, CTE        # carga la direccion de iterado en ACC
            ITERATOR            # CTE - direccion de iterador
            MOV DPTR, ACC       # mueve la direccion de iterador a DPTR
            MOV ACC, [DPTR]     # carga [ITERADOR] em ACC
            ADD ACC, A          # ACC = -SIZE

LOOP_TEST:  JN                  # comprueba si (ITERADOR -SIZE) < 0
            INIT_IF             # ITERADOR < SIZE
            JMP CTE             # salta a END_LOOP
            END_LOOP
INIT_IF:   
LOAD_KEY:   MOV ACC,CTE         # carga la direccion de key en ACC
            KEY                 # CTE - direccion de key
            MOV DPTR, ACC       # mueve la direccion de key a DPTR
            MOV ACC, [DPTR]     # carga [KEY] en A

LOAD_ELEMENT: MOV ACC, CTE      # carga la direccion de i en ACC
            ITERATOR            # CTE - direccion de i en ACC

# comprar key con numberts[i]
COMPA:      MOV DPTR, CTE        # mueve la dirección de memoria donde se encuentra el arreglo "numbers" a DPTR
            NUMBERS              # Señala que la dirección de memoria almacenada en DPTR es la dirección base del arreglo "numbers"
            ADD ACC, A           # Suma el valor actual de "ACC" con el valor actual de "A". En este caso, "A" almacena el valor del iterador "i"
            MOV A, [DPTR]        # Carga el valor almacenado en la dirección de memoria indicada por DPTR en el registro A
            # Este valor corresponde al valor almacenado en la posición "i" del arreglo "numbers
            JN inc-it           # salta a inc-it si key != numbers[i]

IGUAL:      MOV ACC, CTE        # carga la dirrecion de key en ACC  
            ITERATOR            # ITERATOR = direccion de memoria i
            MOV DPTR, ACC       # mueve la direccion de memoria de KEY a DPTR
            MOV [DPTR],A         # almacena la direccion de KEY

inc-it:     MOV     ACC, CTE    # carga la dirección del iterador en ACC
            ITERATOR            # CTE - dirección del iterador
            MOV     DPTR, ACC   # mueve la dirección del iterador a DPTR
            MOV     ACC, [DPTR] # carga [iterador] en ACC
            MOV     A, ACC      # carga i en el registro A
            MOV     ACC, CTE    # carga CTE +1 en ACC
            0x01                # CTE +1
            ADD     ACC, A      # ACC = i+1
            MOV     [DPTR], ACC # almacena el nuevo valor del iterador
goto_init:  JMP CTE             # ir a INIT_LOOP
            INIT_LOOP           # CTE - direccion en INIT_LOOP
END_LOOP:

CONSTANTES:
SIZE:   0x10
ITERATOR: 0x00
KEY:    0x66
ARRAY:  0x01
        0x21
        0x45
        0x66
        0x98
        0x85
        0x78
        0x04
        0x55
        0x48
        hola