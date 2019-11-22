# Ejercicio 1
# Leer 2 numeros x y y. Imprimir x^y

.data
SaltoDeLinea: .asciiz	"\n"
Instr:   .asciiz  "Introducir 'x' y 'y', cada uno en una linea diferente.\n"
.text
main:
	subu $sp, $sp, 32
	sw	$ra, 20($sp)
	sw	$fp, 16($sp)
	addiu $fp, $sp, 28

	# imprimir las instrucciones
	la $a0, Instr
	li $v0, 4
	syscall

	li $v0, 5
	syscall

	# Guardar X en la funcion (el primer parametro)
	move $a0, $v0

	li $v0, 5
	syscall

	# Guardar Y en la funcion (el segundo parametro)
	move $a1, $v0

	jal pow

	# La solucion esta en $v0

	# Imprimir X^Y
	move	$a0, $v0
	li 	$v0, 1
	syscall

	# imprime el salto de linea
	la $a0, SaltoDeLinea
	li $v0, 4
	syscall

	lw	$ra, 20($sp)
	lw	$fp, 16($sp)
	addiu $sp, $sp, 32
	
	li $v0, 10
	syscall

pow:
	subu	$sp, $sp, 32
	sw	$ra, 20($sp)  # Guardar ra
	sw	$fp, 16($sp)  # Guardar fp
	addiu	$fp, $sp, 28    # Mover el fp

	# Guardar los argumentos
	sw	$a0, 0($fp)
	sw	$a1, 4($fp)

	# Cargar Y
	lw	$v0, 4($fp)

	# SI Y > 0 recursion
	bgtz	$v0, L2

	# Si Y <= 0 devolver 1
	li	$v0, 1
	j	L1

L2:
	# Cargar Y
	lw	$v1, 4($fp)

	# Restarle 1
	subu	$t1, $v1, 1
	move	$a1, $t1

	jal pow

	lw	$v1, 0($fp)
	mul	$v0, $v0, $v1

L1:
	lw	$ra, 20($sp)
	lw	$fp, 16($sp)
	addiu	$sp, $sp, 32
	jr	$ra
