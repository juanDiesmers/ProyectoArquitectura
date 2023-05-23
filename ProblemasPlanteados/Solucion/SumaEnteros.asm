; Inicialización de variables
INIT_X:   MOV ACC, CTE       # carga la dirección de x en ACC
          x                  # CTE - dirección de x
          MOV DPTR, ACC      # mueve la dirección de x a DPTR
          MOV ACC, [DPTR]    # carga el valor de x en ACC
          MOV R0, ACC       # guarda el valor de x en R0

INIT_Y:   MOV ACC, CTE       # carga la dirección de y en ACC
          y                 # CTE - dirección de y
          MOV DPTR, ACC     # mueve la dirección de y a DPTR
          MOV ACC, [DPTR]   # carga el valor de y en ACC
          MOV R1, ACC       # guarda el valor de y en R1

LOOP:     MOV A, R1         # carga el valor de y en A
          JZ FIN_LOOP       # salta a FIN_LOOP si y es 0

          MOV B, R0         # carga el valor de x en B
          AND A,B           # calcula el carry entre x e y
          MOV R2,A          # guarda el carry en R2
          # no se como calcular el xor de x = x ^ y
          # no se puede realizar un ADD ya que una xor hace una suma bit a bit
          # en la tabla no existe un operador que haga de XOR 
          # investigando se podria usar un # XOR  A, B para calcular este 
          # este seria un X = X^Y
          MOV R0, A         # si se desarroya de esa forma 

          MOV A, R2         # carga el carry en A
          MOV B,A           # copia el carry a B
          ADD A,A           # desplaz el carry hacia la izquierda (multiplica por 2)
          MOV R1, A         # gurda el nuevo valor de y en R1

          JMP R1
          LOOP              # salra al inicio del loop
FIN_LOOP:

x:  0x02    # valor de x
y:  0x05    # valor de y