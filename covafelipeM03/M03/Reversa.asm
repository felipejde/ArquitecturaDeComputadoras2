# Ejercicio 2
# Leer cadena e imprimir la reversa

.data
Cadena:		.space 1024
Reversa: 	.space 1024
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
	lb $t9, SaltoDeLinea($t2)

loop:   # calcula el tamaño de la cadena
	lb $t3, Cadena($t1)
	beq $t3, $t2, step2
	beq $t3, $t9, step2
	add $t1, $t1, 1
	j loop

step2:
	# inicializa un contador a la cadena en reversa y otro al final de la cadena original
	sub $t1, $t1, 1
	li  $t4, 0

loop2:
	# copia caracter por caracter de final al inicio de la original y las guarda de inicio a fin de la reversa
	blt $t1, $t2, end
	lb $t3, Cadena($t1)
	sb $t3, Reversa($t4)
	sub $t1, $t1, 1
	add $t4, $t4, 1
	j loop2

end:
	# Guarda un salto de linea al final
	lb $t3, SaltoDeLinea($t2)
	sb $t3, Reversa($t4)

	# Guarda el caracter nulo al final
	add $t4, $t4, 1
	li $t3, 0
	sb $t3, Reversa($t4)

	# imprimir la reversa
	la $a0, Reversa
	li $v0, 4
	syscall

	# Fin
	li $v0, 10
	syscall