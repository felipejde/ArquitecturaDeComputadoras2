;btest
.text
main:                         ; Inicia el codigo del programa

li $r0, label0                ; r0=<posicion de label0>
li $r1, 4

label0: 
sub $sp, $sp, $r1
sw $sp, $r1
b $r0                      ; ir a label0

