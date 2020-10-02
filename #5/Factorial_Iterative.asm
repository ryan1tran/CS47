.include "./cs47_macro.asm"

.data
msg1: .asciiz "Enter a number ? "
msg2: .asciiz "Factorial of the number is "
charCR: .asciiz "\n"

.text
.globl main
main:	print_str(msg1)
	read_int($t0)
	
# Write body of the iterative
# factorial program here
# Store the factorial result into 
# register $s0
#
# DON'T IMPLEMENT RECURSIVE ROUTINE 
# WE NEED AN ITERATIVE IMPLEMENTATION 
# RIGHT AT THIS POSITION. 
# DONT USE 'jal' AS IN PROCEDURAL /
# RECURSIVE IMPLEMENTATION.
	
	addi $t1, $zero, 1	# sets $t1 as 1
	addi $t2, $zero, 1	# sets $t2 as 1
	L1: bgt $t2, $t0, L2	# if $t1 > $t0, goto L2
	mult $t1, $t2		# multiplies $t1 and $t2
	mfhi $t3		# takes higher 32 bits of multiplication
	mflo $t4		# takes lower 32 bits of multiplication
	move $t1, $t4		# moves $t4 to $t1
	addi $t2, $t2, 1	# adds 1 to $t2
	j L1			# goto L1
	
	L2: move $s0, $t1	# moves $t1 to $s0
	
	print_str(msg2)
	print_reg_int($s0)
	print_str(charCR)
	
	exit
	
