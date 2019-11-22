x: .word 10
y: .word 5
z: .word 0
w: .word 0
	
aux: .word 1
lw $s4, x
lw $s5, y

While :
	blt $s4, $s5, fin #si a es mayor que b, no se puede dividir
	lw $s0, z
	lw $s1, aux
	add $s2, $s0, $s1
	sw $s2, z #z+1
	sub $s6, $s4, $s5 #x -=y
	sw $s6, x 
	b While

fin:
#z ya tiene el cociente
lw $s1,z
lw $s2,y
mul $s0, $s1, $s2
sub $s5, $s0, $s7
sw $s5, w #se guarda w
