;btest
.text
main:                         ; Inicia el codigo del programa

li $r6, 1                     ; r6=1
li $r7, 2                     ; r7=2
li $r0, label0                ; r0=<posicion de label0>
li $r1, label1                ; r1=<posicion de label1>
li $r2, label2                ; r2=<posicion de label2>

label0: 
sub $r7, $r7, $r6             ; r7=r7-1
beqz $r1,$r7                  ; ir a label1 si r7==0
b $r0                         ; ir a label0

label11: 
mov $a1, $r3
li $a0, 7                       ; Codigo para imprimir cadena
syscall                         ; Llamada al sistema (imprime cadena)

label1:
bltz $r2, $r7                 ; ir a label2 si r7<0
sub $r7, $r7, $r6             ; r7=r7-1
b $r1                        ; ir a label1

label2:
li $a0, 8                     ; Codigo de salir del programa
syscall                       ; Llamada al sistema (salir)
