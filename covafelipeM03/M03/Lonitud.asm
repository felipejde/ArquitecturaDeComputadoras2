# Ejercicio 1
# Leer cadena e imprimir su longitud

.data
Cadena:		.space 1024
SaltoDeLinea:  .asciiz  "\n"

.text
main:
	# leer cadena
	la	$a0, Cadena
	li	$a1, 1024
	li	$v0, 8
	syscall

	li $t1, 0    # aqui se cuenta el tamaño de la cadena
	li $t2, 0    # representa el caracter nulo
	lb $t9, SaltoDeLinea

loop:
	lb $t3, Cadena($t1)
	beq $t3, $t2, end
	beq $t3, $t9, end
	add $t1, $t1, 1
	j loop

end:
	# imprime el tamaño de la cadena
	move $a0, $t1
	li $v0, 1
	syscall

	# imprime el salto de linea
	la $a0, SaltoDeLinea
	li $v0, 4
	syscall

	# sale del programa
	li $v0, 10
	syscall
