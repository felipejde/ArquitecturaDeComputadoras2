.data
x: .word 0x0
y: .word 0x11
z: .word 0x1
w: .word 0x5	
v: .word 0x3
vt: .word 23
n: .word 0xef1
a: .word 0

.text
main:
#x = y+z
lw $s1, y
lw $s2, z
add $s3, $s1, $s2
sw $s3, x

#x=(z+w)+(z+(y+(w-v))
lw $s3,z
lw $s2,w
lw $s1,y
lw $s0,v
sub $s4, $s2, $s0 #s4 tiene w-v
add $s5, $s1, $s4 # s5 tiene y + s4
add $s6, $s3, $s5 #s6 tiene z+ s5
add $s7, $s3, $s7 #s7 tiene z+w
add $s0, $s7, $s6 #resultado total
sw $s0, x #x ya es igual a todo lo anterior

#x = (w-z)-(x+23)
lw $s0, w
lw $s1, z
lw $s2, x
lw $s3, vt
sub $s7, $s0, $s1 #w-z
add $s5, $s2, $s3 # x+23
sub $s4, $s7, $s5
sw $s4, x

#a =v+0xef1
lw $s1, v
lw $s2, n
add $s3, $s1, $s2
sw $s3, a
jr $ra