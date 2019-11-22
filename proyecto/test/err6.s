;inttest
.text               
main:               ; Inicia el codigo del programa
li $a1, 5         ; a1=0
li $a0, 20                       ; Codigo erroneo
syscall                         ; Llamada al sistema (imprime entero)

