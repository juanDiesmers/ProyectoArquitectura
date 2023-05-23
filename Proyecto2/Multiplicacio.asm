; Rutina de multiplicacion utilizando el algoritmo de Booth
; Multiplica dos valores de 8 bits almacenados en memoria
; El resultado se almacena en memoria en dos registros de 8 bits

MULTIPLICAND: 0x07
MULTIPLIER: 0X03
COUNT: 0x08

; A<-0, Q-1<-0
          MOV A1, 0x00
          MOV Q1, 0x00

          ; M<-MULTIPLICAND
          MOV ACC, MULTIPLICAND
          MOV M, ACC

          ; Q<-MULTIPLIER
          MOV ACC, MULTIPLIER
          MOV Q, ACC

LOOP:   ;Incia el bucle
        ; ¿Q0,Q-1==01 o 10?
        MOV A, Q1  ; Mueve el valor de Q1 al registro A
        AND A, Q   ; Realiza una operacion AND bit a bit entre el valor en A y el valor de Q
        ; Esta operacion se guarda en A
        ;Si el resultado de esta operación AND es cero, significa que los bits Q0 y Q1 son iguales a 00 o 11. 
        ;En ese caso, el código salta a la etiqueta SHIFT_RIGHT (que representa una operación 
        ;de desplazamiento a la derecha). Si el resultado no es cero (es decir, los bits Q0 y Q1 son iguales 
        ;a 01 o 10), el código continúa ejecutando la siguiente instrucción.
        JZ SHIFT_RHIGHT ; Salta si Q0, Q1 == 00 o 11
        JC Add   
        
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

STORE_A1: MOV ACC, A1      ; Carga A1 en ACC
          MOV DPTR, ACC    ; Mueve el valor de ACC a DPTR
          MOV ACC, A       ; Carga A en ACC
          MOV [DPTR],ACC   ; Almacena el valor de ACC en la direccion de memoria apuntada por DPTR
          JMP SHIFT_RIGHT  ; Salta a SHIFT_RIGHT

SHIFT_RIGHT:
        ;La idea es mover los bits de los operadores A, Q, Q-1
        MOV A1, [DPTR]         ; Cargar el valor de DPTR en A1
        AND A1, #0FEH          ; Desplazar los bits hacia la 
        ;derecha (#0FEH, representa el valor binario 1111 1110, 
        ;lo hace que al usarse con un AND, se desplace el valor 
        ;de A1 hacia la derecha y establece el MSB a 1)   
        ;JMP COUNT

COUNT:
        MOV ACC, COUNT         # load address of COUNT in ACC
        JZ FIN_LOOP            # if A = 0, jump to FIN_LOOP
        MOV DPTR, ACC          # move address of COUNT to DPTR
        MOV ACC, [DPTR]        # load [COUNT] in ACC
        MOV A, ACC             # load [COUNT] in A register
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
