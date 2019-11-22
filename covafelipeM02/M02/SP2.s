.data
x: .word 4
y: .word 10
m: .word 0x

.text             # Comienzo de seccion de codigo de usuario

main:
lw $s0, y         # Cargamos en s0 el primer numero: 81 
lw $s1, x         # Cargamos en s1 el segundo numero: 45 

bucle:
div $s0, $s1 	# Dividimos s0 (dividendo) entre s1 (divisor) 
mfhi $t0           # El resto lo llevamos al registro t0 
beq $t0, $0, fin   # Si el resto es 0, vamos a "fin" 
move $s0, $s1
move $s1, $t0
b bucle           # Volvemos al inicio del bucle 

fin:
move $s2, $s1    # Ponemos en s2 el valor de s1, que es el mcd 
sw $s2, m 
jr $ra