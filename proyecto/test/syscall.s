;sysctest
.asciiz "Da un entero\n" str1
.asciiz "Da un caracter\n" str2
.asciiz "Da un flotante\n" str3
.asciiz "Da una cadena\n" str4
.text                           
main:                           ; Inicia el codigo del programa
li $a1, str1
li $a0, 7                       ; Codigo para imprimir cadena
syscall    
li $r0, 100                     ;r0=100
sub $sp, $sp, $r0               ;avanza Stack pointer 100 bytes
li $a0, 0                       ; Codigo para leer entero
syscall                         ; Llamada al sistema (lee entero)
mov $a1, $s0                    ; Se pasa el entero leido como parametro
li $a0, 4                       ; Codigo para imprimir entero
syscall                         ; Llamada al sistema (imprime entero)

li $a1, str2
li $a0, 7                       ; Codigo para imprimir cadena
syscall    
li $a0, 1                       ; Codigo para leer caracter
syscall                         ; Llamada al sistema (lee caracter)
mov $a1, $s0                    ; Se pasa el caracter leido como parametro
li $a0, 5                       ; Codigo para imprimir caracter
syscall                         ; Llamada al sistema (imprime caracter)

li $a1, str3
li $a0, 7                       ; Codigo para imprimir cadena
syscall    
li $a0, 2                       ; Codigo para leer flotante
syscall                         ; Llamada al sistema (lee flotante)
mov $a1, $s0                    ; Se pasa el flotante leido como parametro
li $a0, 6                       ; Codigo para imprimir flotante
syscall                         ; Llamada al sistema (imprime flotante)
mov $a1, $sp                    ; localidad para guardar cadena (stack pointer)

li $a1, str4
li $a0, 7                       ; Codigo para imprimir cadena
syscall    
li $a0, 3                       ; Codigo para leer cadena
syscall                         ; Llamada al sistema (lee cadena)
li $a0, 7                       ; Codigo para imprimir cadena
syscall                         ; Llamada al sistema (imprime cadena)
li $a0, 8                       ; Codigo de salir del programa
syscall                         ; Llamada al sistema (salir)
