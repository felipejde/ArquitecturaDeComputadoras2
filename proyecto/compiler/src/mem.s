.asciiz "Hello World!" hwstr
.ascii entero 4
.ascii flotante 4
.ascii char 1 
.text
main:

li $r1, 10
li $r2, 6
fdiv $r2, $r1, $r2

li $r3, entero                  
li $r4, flotante
li $r5, char
li $r6, hwstr

mov $a1, $r1                    ; Se pasa el entero leido como parametro
li $a0, 4                       ; Codigo para imprimir entero
syscall                         ; Llamada al sistema (imprime entero)

mov $a1, $r2                    ; Se pasa el flotante leido como parametro
li $a0, 6                       ; Codigo para imprimir flotante
syscall                         ; Llamada al sistema (imprime flotante)

lb $r6, $r7                     ; Cargamos el primer caracter de la cadena
mov $a1, $r7                    ; Se pasa el caracter leido como parametro
li $a0, 5                       ; Codigo para imprimir caracter
syscall                         ; Llamada al sistema (imprime caracter)

sb $r5, $r7                     ; Guardamos el caracter en memoria

sw $r3, $r1                     ; Guardamos el entero 10 en memoria 
sw $r4, $r2                     ; Guadamos el flotante en memoria

lw $r3, $r7                     
mov $a1, $r7                    ; Se pasa el entero leido como parametro
li $a0, 4                       ; Codigo para imprimir entero
syscall                         ; Llamada al sistema (imprime entero)

lw $r4, $r7
mov $a1, $r7                    ; Se pasa el flotante leido como parametro
li $a0, 6                       ; Codigo para imprimir flotante
syscall                         ; Llamada al sistema (imprime flotante)

lb $r5, $r7
mov $a1, $r7                    ; Se pasa el caracter leido como parametro
li $a0, 5                       ; Codigo para imprimir caracter
syscall                         ; Llamada al sistema (imprime caracter)

li $a0, 8
syscall
