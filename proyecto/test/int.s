;inttest
.text               
main:               ; Inicia el codigo del programa
li $r0, 1           ; r0=1
li $r1, 9           ; r1=9
li $r2, 2           ; r2=2
li $a0, 4           ; Codigo de imprimir entero
add $r3, $r0, $r1   ; r3=r0+r1
mov $a1, $r3        ; Registro del entero a imprimir
syscall             ;Llamada al sistema (imprime r3)
sub $r4, $r2, $r3   ; r4=r2-r3
mov $a1, $r4        ; Registro del entero a imprimir
syscall             ; Llamada al sistema (imprime r4)
mul $r5, $r1, $r4   ; r5=r1*r4
mov $a1, $r5        ; Registro del entero a imprimir
syscall             ; Llamada al sistema (imprime r5)
div $r6, $r5, $r2   ; r6=r5/r2
mov $a1, $r6        ; Registro del entero a imprimir
syscall             ; Llamada al sistema (imprime r6)
li $a0, 8          ; Codigo de salir del programa
syscall             ; Llamada al sistema (salir)
