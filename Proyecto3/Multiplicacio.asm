LOOP:   ;Inicio del loop
        ;Cargamos "Q" (con el bit menos significativo de multiplicador) en ACC
        MOV ACC, MULTIPLICADOR
        MOV DPTR,ACC
        MOV ACC,[DPTR]
        MOV A,ACC
        MOV ACC,0x01
        AND ACC,A
        MOV A, ACC

        ;llamamos a valor para almacenar el nuevo valor
        MOV ACC,VALOR
        MOV DPTR,ACC
        MOV ACC, A
        MOV [DPTR],ACC ; Guarda "q" en VALOR para uso poseterior

        ;Cargarmos Q-1 en ACC
        MOV ACC,Q1
        MOV DPTR, ACC
        MOV ACC,[DPTR]
        MOV A, ACC
        MOV ACC,0x01
        AND ACC,A
        ;verificanos que Q y Q-1 sen 00
        JZ CHECK00   

        ; si Q-1 no es 0, verificanos que Q y Q-1 son 11
        MOV ACC, VALOR
        MOV DPTR, ACC
        MOV ACC,[DPTR] ; Recuperamos el valor de Q del registro A
        INV ACC ; invirete todos los bits en ACC
        JZ SHIFTRIGHT_A ; si el valor al momento de hacer INV ACC y JZ ve que Q = 0, eso dice que Q si es 1
        ; por lo tanto Q y Q-1 = 11
        JMP CHEK10_01
        
CHECK00:
        MOV ACC,VALOR; Recuperamos Q del registro valor
        MOV DPTR, ACC
        MOV ACC,[DPTR] 
        JZ SHIFTRIGHT_A ; Si Q es tambien 0 osea Q y Q-1 = 00
        JMP CHEK10_01 ; Si Q no es 0, entonces Q y Q-1 podrian ser 10 o 01

CHEK10_01:
        MOV ACC,VALOR ; Recuperamos "Q" del regustro A
        MOV DPTR,ACC
        MOV ACC,[DPTR]
        JZ Add ; Si Q e 0, entonces Q y Q-1 SON 01, por lo que salta a Add

        ;En caso de que no es 0, entonces q y Q-1 prodien ser  10
        MOV ACC, Q1  ;Tomamos Q-1
        MOV DPTR,ACC
        MOV ACC,[DPTR]
        AND ACC,0x01 
        INV ACC
        JZ SUBB  ; si Q-1 = 0, entoces Q  Q-1 son 10 por lo tanto salta a subtract
        
        
MSB_A1:
; Guardamos el MSB de A1 en la variable MSB_A1 para despues. 
        MOV ACC, CTE
        A1
        MOV DPTR, ACC
        MOV ACC, [DPTR]
        MSB ACC
        MOV A, ACC
        MOV ACC, CTE
        MSB_A1
        MOV DPTR, ACC
        MOV ACC, A
        MOV [DPTR], ACC
       
LSB_A1:
; Guardamos el LSB de A1 en la variable LSB_A1 para despues.
        MOV ACC, CTE
        A1
        MOV DPTR, ACC
        MOV ACC, [DPTR]
        LSB ACC
        MOV A, ACC
        MOV ACC, CTE
        LSB_A1
        MOV DPTR, ACC
        MOV ACC, A
        MOV [DPTR], ACC
       
SHIFTRIGHT_MULTIPLICADOR:
        MOV ACC, CTE
        MULTIPLICADOR
        MOV DPTR, ACC
        MOV ACC, [DPTR]
        LSR ACC ;Aplicamos un logical shift right en acc 
        MOV A, ACC
        
CAMBIAR_MULTIPLICADOR:
        MOV ACC, CTE
        MULTIPLICADOR
        MOV DPTR, ACC
        MOV ACC, A
        MOV [DPTR], ACC
        
CAMBIO_MULTIPLICADOR:
        MOV ACC, CTE
        A1
        MOV DPTR, ACC
        MOV ACC, [DPTR]
        LSB ACC
        MOVE A, ACC
        AND A, A
        JZ
        CAMBIAR2_MULTIPLICADOR
        JMP SUMAR_Q
        
SUMAR_Q+0:
        MOV ACC, CTE
        MULTIPLICADOR
        MOV DPTR, ACC
        MOV ACC, [DPTR]
        MSB ACC
        ADD ACC, ACC
        JZ
        SUMAR_Q+1
        JMP CAMBIAR2_MULTIPLICADOR
        
SUMAR_Q+1:
        MOV ACC, CTE
        M_MSB
        MOV DPTR, ACC
        MOV ACC, [DPTR]
        MOV A, ACC
        MOV ACC, CTE
        MULTIPLICADOR
        MOV DPTR, ACC
        MOV ACC, [DPTR]
        ADD ACC, A
        MOV A, ACC

CAMBIAR2_MULTIPLICADOR:
        MOV ACC, CTE
        MULTIPLICADOR
        MOV DPTR, ACC
        MOV ACC, A
        MOV [DPTR], ACC
        JUMP SHIFTRIGHT_Q1


SHIFTRIGHT_A:
        ; Desplazamiento a la derecha de A (Shift Right)
        MOV ACC, CTE ; Cargamos el valor de A1 en ACC
        A1
        MOV DPTR, ACC 
        MOV ACC, [DPTR]
        LSR ACC ; Realizamos la operacion de Logical Shift Right al ACC
        MOV A, ACC; Movemos el valor de ACC en A
       
CAMBIAR_A1:
        MOV ACC, CTE
        A1
        MOV DPTR, ACC
        MOV ACC, A
        MOV [DPTR], ACC

; cambiar el msb de A dependiendo si es 0 o 1
CAMBIO_A1:
        MOV ACC, CTE
        MSB_A1
        MOV DPTR, ACC
        MOV ACC, [DPTR]
        ADD ACC, ACC
        JZ
        CAMBIO_0
        JMP CAMBIO_1
        
CAMBIO_0:
        MOV ACC, CTE
        A1
        MOV DPTR, ACC
        MOV ACC, [DPTR]
        MSB ACC
        MOV A, ACC
        ADD A, A
        JZ
        CAMBIAR2_A1 ; Si el valor es 1, le restamos la inversa a la mascara
        MOV ACC, CTE
        M_MSB
        MOV DPTR, ACC
        MOV ACC, [DPTR]
        MOV A, ACC
        INV A
        MOV ACC, CTE
        A1
        MOV DPTR, ACC
        MOV ACC, [DPTR]
        ADD ACC, A
        MOV A, ACC
        
CAMBIAR2_A1:
        MOV ACC, CTE
        A1
        MOV DPTR, ACC
        MOV ACC, A
        MOV [DPTR], ACC
        
CAMBIO_1:
        MOV ACC, CTE
        A1
        MOV DPTR, ACC
        MOV ACC, [DPTR]
        MSB ACC
        MOV A, ACC
        ADD A, A
        JZ
        ULTIMO_CAMBIO
        JMP SHIFT_Q1
        
ULTIMO_CAMBIO:
        MOV ACC, CTE
        A1
        MOV DPTR, ACC
        MOV ACC, [DPTR]
        MOV A, ACC
        MOV ACC, CTE
        M_MSB
        MOV DPTR, ACC
        MOV ACC, [DPTR]
        ADD ACC, A
        MOV A, ACC
        
CAMBIAR3_A1:
        MOV ACC, CTE
        A1
        MOV DPTR, ACC
        MOV ACC, A
        MOV [DPTR], ACC
        JUMP SHIFTRIGHT_MULTIPLICADOR
                
SHIFTRIGHT_Q1:
        MOV ACC, CTE
        VALOR
        MOV DPTR, ACC
        MOV ACC, [DPTR]
        MOV A, ACC
        MOV ACC, CTE
        Q1
        MOV DPTR, ACC
        MOV ACC, A
        MOV [DPTR], ACC
        JMP COUNT

SUBB:  ; si Q0, Q-1 == 10 resta M a A
        MOV ACC, A1        ; Carga A1 en Acc
        MOV DPTR, ACC      ; Mueve el valor de ACC a DPTR
        MOV ACC,[DPTR]     ; Carga el valor almacenado en la direccion de memoria apuntada por DPTR en ACC
        MOV A,ACC          ; Mueve el valor almacenado en ACC a A
        MOV ACC, MULTIPLICADO 
        MOV DPTR, ACC
        MOV ACC, [DPTR]    ; Carga M en ACC
        INV ACC            ; Invierte el valor de ACC
        ADD ACC, A
        MOV A,ACC        ; Suma el  valor de ACC al valor de A
        JMP STORE_A1       ; Salta a STORE_A1

;La función SUBB se utiliza para restar un valor almacenado en el registro M al valor de un registro A. 
;En este caso específico, si los bits Q0 y Q-1 son iguales a 10, se activa la función y resta el valor M de A.

;La función comienza cargando el valor de A1 en el registro ACC. Luego, mueve el valor de ACC a DPTR, 
;que es un registro especial que apunta a una dirección de memoria. A continuación, carga el valor 
;almacenado en la dirección de memoria apuntada por DPTR en ACC y lo mueve a A.

;Después, carga el valor de M en ACC y lo invierte. Luego, suma el valor de ACC al valor de A. 
;Finalmente, salta a la dirección de memoria llamada STORE_A1 para almacenar el resultado en el registro A1.

Add:   ; si Q0,Q-1 == 01 suma M a A
        MOV ACC, A1         ; Carga A1 en Acc
        MOV DPTR, ACC       ; Mueve el valor de ACC a DPTR
        MOV ACC,[DPTR]      ; Carga el valor almacenado en la direccion de memoria apuntada por DPTR en ACC
        MOV A,ACC           ; Mueve el valor almacenado en ACC a A
        MOV ACC, MULTIPLICADO   
        MOV DPTR,ACC
        MOV ACC,[DPTR]      ; Carga M en ACC
        ADD ACC,A           ; Suma el valor de ACC al valor de A
        MOV A,ACC       
        JMP STORE_A1        ; Salta a STORE_A1
/*
La función llamada "Add" se utiliza para sumar el valor de un registro M al valor de un registro A. 
En este caso específico, si los bits Q0 y Q-1 son iguales a 01, se activa la función y suma el valor M a A.

La función comienza cargando el valor de A1 en el registro ACC. Luego, mueve el valor de ACC a DPTR, 
que es un registro especial que apunta a una dirección de memoria. A continuación, carga el valor 
almacenado en la dirección de memoria apuntada por DPTR en ACC y lo mueve a A.

Después, carga el valor de M en ACC y lo suma al valor de A. Finalmente, salta a la dirección de memoria 
llamada STORE_A1 para almacenar el resultado en el registro A1.
*/

STORE_A1: 
        MOV ACC, A1      ; Carga A1 en ACC
        MOV DPTR, ACC    ; Mueve el valor de ACC a DPTR
        MOV ACC, A       ; Carga A en ACC
        MOV [DPTR],ACC   ; Almacena el valor de ACC en la direccion de memoria apuntada por DPTR
        JMP SHIFTRIGHT_A ; Salta a SHIFT_RIGHT

COUNT:
        MOV ACC, COUNT         # load address of COUNT in ACC
        MOV DPTR, ACC          # move address of COUNT to DPTR
        MOV ACC, [DPTR]        # load [COUNT] in ACC
        MOV A, ACC             # load [COUNT] in A register
        JZ FIN_LOOP            # if A = 0, jump to FIN_LOOP
        MOV ACC, 0x01          # load CTE 1 in ACC
        INV ACC                # invert 0x01 to obtain complement
        ADD ACC,A
        MOV A,ACC             # A = [COUNT]-1     
        JMP STORE_COUNT        # go to store_COUNT

STORE_COUNT: 
        MOV ACC, COUNT    # load address of COUNT in ACc       
        MOV DPTR, ACC         # move address of COUNT to DPTR
        MOV ACC, A            # move value to store from a to ACC
        MOV [DPTR], ACC       # store value in [COUNT]
        JMP LOOP              # jump back to LOOP

FIN_LOOP:

; Guarda el resultado en memoria
MOV DPTR, Q1        ; Guardamos el contenido de Q1 en el registro DPTR
MOV ACC, [DPTR]     ; Movemos el contenido apuntando por DPTR al registro ACC
ADD ACC, 0x01       ; Sumamos 1 byte de memoria al registro ACC para poder cargar 
                      ;un valor de 16 bits
MOV DPTR, A1        ; Guardamos el contenido de A1 en el registro DPTR
MOV [DPTR], ACC     ; Guardamos el valor del registro ACC en la direccion de memoria 
                       ;apuntada por DPTR
MOV DPTR, 0x07      ; Actualizamos el registro DPTR para que apunte a la memoria 7
MOV ACC, [DPTR]     ; Asignamos la direccion de memoria apuntada por DPTR en ACC
ADD ACC, 0x01       ; Sumamos 1 byte de memoria al registro ACC para poder cargar 
                      ;un valor de 16 bits
MOV DPTR, A1        ; Guardamos el contenido de A1 en el registro DPTR
MOV [DPTR], ACC     ; Guardamos el valor del registro ACC en la direccion de memoria 
                    ;  apuntada por DPTR
                    
; Funcion MSB (Instruccion Nueva)
MSB:
        MOV A, ACC
        MOV ACC, CTE
        M_MSB ; cargamos la mascara para determinar el msb (10000000)
        
        MOV DPTR, ACC
        MOV ACC, [DPTR]
        AND A, ACC ; hacemos and para encontrar el msb y descartar lo demas
        LSR7 A, ACC ; hacemos un logical shift right de 7 espacios para dejar el msb como el lsb
        MOV ACC, A ; guardamos el valor en acc
        
 ; Funcion LSB (Instruccion Nueva)
 LSB: 
        MOV A, ACC
        MOV ACC, CTE
        M_LSB ; cargamos la mascara para determinar el lsb (00000001)
        
        MOV DPTR, ACC
        MOV ACC, [DPTR]
        AND A, ACC ; hacemos and para encontrar el msb y descartar lo demas
        MOV ACC, A ; guardamos el valor en acc
                    
MULTIPLICADO:   0x07,00000111   ; valor en 0x16A
MULTIPLICADOR:  0x03,00000011   ; valor en 0x16B
COUNT:          0x08,00001000   ; valor en 0x16C
A1:             0x00,00000000   ; valor en 0x16D
Q1:             0x00,00000000   ; valor en 0x16E
VALOR:          0x00,00000000   ; valor en 0x16F
MSB: "Instruccion Nueva" ; opcode 0b10000000
LSB: "Instruccion Nueva" ; opcode 0b10001000

MSB_A1:         0x00,00000000   ; valor en 0x173
LSB_A1:         0x00,00000000   ; valor en 0x174
M_MSB:          0x01,00000001   ; valor en 0x175
M_LSB:          0x08,00001000   ; valor en 0x176

LOOP:                           00000000,0x00
CHECK00:                        00100100,0x36
CHEK10_01:                      00101011,0x2B
MSB_A1:                         00111010,0x3A
LSB_A1:                         00111010,0x48
SHIFTRIGHT_MULTIPLICADOR:       01010110,0x56
CAMBIAR_MULTIPLICADOR:          01011110,0x5E
CAMBIO_MULTIPLICADOR:           01100101,0x65
SUMAR_Q+0:                      01110001,0x71
SUMAR_Q+1:                      01111100,0x7C
CAMBIAR2_MULTIPLICADOR:         10001001,0x89
SHIFTRIGHT_A:                   10010010,0x92
CAMBIAR_A1:                     100011011,0x9B
CAMBIO_A1:                      10100011,0xA3
CAMBIO_0:                       10101101,0xAD
CAMBIAR2_A1:                    11000100,0xC4
CAMBIO_1:                       11001011,0xCB
ULTIMO_CAMBIO:                  110101111,0xD7
CAMBIAR3_A1:                    11100100,0xE4
SHIFTRIGHT_Q1:                  11101100,0xEC
SUBB:                           11111001,0xF9
Add:                            000100010000,0x110
STORE_A1:                       000100100111,0x127
COUNT:                          000100101110,0x12E
STORE_COUNT:                    000100111010,0x13A
FIN_LOOP:                       000101000001,0x141