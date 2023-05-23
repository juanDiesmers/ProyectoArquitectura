# bubble sort

INIT_LOOP1: 
LOAD_SIZE:  MOV A, CTE          # carga el valor de n en A
            n
            MOV B, CTE          # carga 1 en B
            0x01
            SUB A, B            # resta 1 a n y luego lo guarda en a


Load_it:    MOV ACC, CTE        # carga la direccion de i en ACC
            i                   # CTE - direccion de i
            MOV DPTR, ACC       # mueve la direccion de i a DPTR
            MOV ACC, [DPTR]     # carga [i] en ACC
            

# aca agrege el resto del bubble
# use variables init_loop2 para referirce al segundo loop
# inc_it2 para la suma del j+1

inc_it1:    MOV     ACC, CTE    # carga la dirección del i en ACC
            i                    # CTE - dirección del i
            MOV     DPTR, ACC   # mueve la dirección del i a DPTR
            MOV     ACC, [DPTR] # carga [i] en ACC
            MOV     A, ACC      # carga i en el registro A
            MOV     ACC, CTE    # carga CTE +1 en ACC
            0x01                # CTE +1
            ADD     ACC, A      # ACC = i+1
            MOV     [DPTR], ACC # almacena el nuevo valor del i
goto_init:  JMP CTE             # ir a INIT_LOOP
            INIT_LOOP1          # CTE - direccion en INIT_LOOP1
END_LOOP1:
const:
n: 0x07
i: 0x00
j: 0x00
ARRAY: 0x64
       0x34
       0x25
       0x12
       0x22
       0x11
       0x90