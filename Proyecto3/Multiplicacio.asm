MULTIPLICADO: 
        0x07
MULTIPLICADOR: 
        0x03
COUNT: 
        0x08
A1:     
        0x00
Q1:
        0x00
VALOR:
        0x00

LOOP:   ;Inicio del loop
        ;Cargamos "Q" (con el bit menos significativo de multiplicador) en ACC
        MOV ACC, MULTIPLICADOR
        MOV DPTR,ACC
        MOV ACC,[DPTR]
        MOV A,ACC
        MOV ACC,0x01
        AND ACC,A
        MOV A, ACC
        MOV ACC,VALOR
        MOV DPTR,ACC
        MOV ACC, a
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
        JZ SHIFT_RIGHT
        JMP CHEK10_01
        
CHECK00:
        MOV ACC,A; Recuperamos Q del registro A
        JZ SHIFT_RIGHT ; Si Q es tambien 0 osea Q y Q-1 = 00
        JMP CHEK10_01 ; Si Q no es 0, entonces Q y Q-1 podrian ser 10 o 01
CHEK10_01:
        MOV ACC, A ; Recuperamos "Q" del regustro A
        JZ Add ; Si Q e 0, entonces Q y Q-1 SON 01, por lo que salta a Add

        ;En caso de que no es 0, entonces q y Q-1 prodien ser  10
        MOV ACC, Q1  ;Tomamos Q-1
        MOV ACC, DPTR,
        MOV ACC, [DPTR]
        AND ACC, 0x01 
        INV ACC
        JZ SUBB  ; si Q-1 = 0, entoces Q  Q-1 son 10 por lo tanto salta a subtract

SHIFT_RIGHT:
        ;La idea es mover los bits de los operadores A, Q, Q-1
        MOV A1, [DPTR]         ; Cargar el valor de DPTR en A1
        AND A1, #0FEH          ; Desplazar los bits hacia la 
        ;derecha (#0FEH, representa el valor binario 1111 1110, 
        ;lo hace que al usarse con un AND, se desplace el valor 
        ;de A1 hacia la derecha y establece el MSB a 1)   
        ;JMP COUNT     
       
CONTINUE:

SUBB:  ; si Q0, Q-1 == 10 resta M a A
        MOV ACC, A1        ; Carga A1 en Acc
        MOV DPTR, ACC      ; Mueve el valor de ACC a DPTR
        MOV ACC,[DPTR]     ; Carga el valor almacenado en la direccion de memoria apuntada por DPTR en ACC
        MOV A,ACC          ; Mueve el valor almacenado en ACC a A
        MOV ACC, M         ; Carga M en ACC
        INV ACC            ; Invierte el valor de ACC
        ADD A, ACC         ; Suma el  valor de ACC al valor de A
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
        MOV ACC, M          ; Carga M en ACC
        ADD A, ACC          ; Suma el valor de ACC al valor de A
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
        JMP SHIFT_RIGHT  ; Salta a SHIFT_RIGHT



COUNT:
        MOV ACC, COUNT         # load address of COUNT in ACC
        MOV DPTR, ACC          # move address of COUNT to DPTR
        MOV ACC, [DPTR]        # load [COUNT] in ACC
        MOV A, ACC             # load [COUNT] in A register
        JZ FIN_LOOP            # if A = 0, jump to FIN_LOOP
        MOV ACC, 0x01          # load CTE 1 in ACC
        INV ACC                # invert 0x01 to obtain complement
        ADD A,ACC              # ACC = [COUNT]-1
        MOV A, ACC             # load [COUNT] -1 into A register        
        JMP STORE_COUNT        # go to store_COUNT

STORE_COUNT: MOV ACC, COUNT    # load address of COUNT in ACc       
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
