;fltest
.text
main:               ; Inicia el codigo del programa
li $r0, 3           ; r0=3
li $r1, 5           ; r1=5
li $r2, 7           ; r2=7
li $a0, 6           ; codigo de imprimir flotante
fdiv $r0, $r0, $a0  ; r0=r0/6 0.5
fdiv $r1, $r1, $a0  ; r1=r1/6 0.833333333
fdiv $r2, $r2, $a0  ; r2=r2/6 1.166666667
fadd $r3, $r0, $r1  ; r3=r0+r1 1.333333
mov $a1, $r3        ; Registro del flotante a imprimir
syscall             ; Llamada al sistema (imprime r3)
fsub $r4, $r2, $r3  ; r4=r2-r3  
mov $a1, $r4        ; Registro del flotante a imprimir
syscall             ; Llamada al sistema (imprime r4)
fmul $r5, $r1, $r4  ; r5=r1*r4  
mov $a1, $r5        ; Registro del flotante a imprimir
syscall             ; Llamada al sistema (imprime r5)
fdiv $r6, $r5, $r2  ;r6=r5/r2    
mov $a1, $r6        ; Registro del flotante a imprimir
syscall             ; Llamada al sistema (imprime r6)
li $a0, 8           ; Codigo de salir del programa
syscall             ; Llamada al sistema (salir)
