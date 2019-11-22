# Ejercicio 2
# Leer n, calcular el n-esimo fibonaci

.data
SaltoDeLinea: .asciiz	"\n"
.text
main:
	subu $sp, $sp, 32
	sw	$ra, 20($sp)
	sw	$fp, 16($sp)
	addiu $fp, $sp, 28

	# Constante
	li 	$t9, 1

	# leer n
	li $v0, 5
	syscall

	# Guardar n en la funcion (el primer parametro)
	move $a0, $v0

	jal fib

	# La solucion esta en $v0

	# Imprimir el n-esimo fibonaci
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

fib:
	subu	$sp, $sp, 32
	sw	$ra, 20($sp)  # Guardar ra
	sw	$fp, 16($sp)  # Guardar fp
	addiu	$fp, $sp, 28    # Mover el fp

	# Guardar n
	sw	$a0, 0($fp)

	# Cargar n
	lw	$v0, 0($fp)

	# SI n > 1 recursion
	bgt	$v0, $t9, L2

	# Si n == 1 devolver 1
	beqz	$v0, fib0
	li	$v0, 1
	j	L1

fib0:
	# Si n == 0 devolver 0
	li 	$v0, 0
	j L1

L2:
	# Cargar n
	lw	$v1, 0($fp)

	# Calcular fib(n-1)
	subu	$t1, $v1, 1
	move	$a0, $t1
	jal fib

	# Guardar fib(n-1)
	sw	$v0, 4($fp)

	# calcular fib(n-2)
	lw	$v1, 0($fp)
	sub $v1, $v1, 2
	move $a0, $v1
	jal fib

	# Cargar fib(n-1) y fib(n) y sumarlos
	lw	$v1, 4($fp)
	add	$v0, $v0, $v1

L1:
	lw	$ra, 20($sp)
	lw	$fp, 16($sp)
	addiu	$sp, $sp, 32
	jr	$ra
