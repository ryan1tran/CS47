.include "./cs47_macro.asm"

.data
msg1: .asciiz "Enter a +ve number : "
msg2: .asciiz "Enter another +ve number : "
msg3: .asciiz "LCM of "
s_is: .asciiz "is"
s_and: .asciiz "and"
s_space: .asciiz " "
s_cr: .asciiz "\n"

.text
.globl main
main:
	print_str(msg1)
	read_int($s0)
	print_str(msg2)
	read_int($s1)
	
	move $v0, $zero
	move $a0, $s0
	move $a1, $s1
	move $a2, $s0
	move $a3, $s1
	jal  lcm_recursive
	move $s3, $v0
	
	print_str(msg3)
	print_reg_int($s0)
	print_str(s_space)
	print_str(s_and)
	print_str(s_space)
	print_reg_int($s1)
	print_str(s_space)
	print_str(s_is)
	print_str(s_space)
	print_reg_int($s3)
	print_str(s_cr)
	exit

#------------------------------------------------------------------------------
# Function: lcm_recursive 
# Argument:
#	$a0 : +ve integer number m
#       $a1 : +ve integer number n
#       $a2 : temporary LCM by increamenting m, initial is m
#       $a3 : temporary LCM by increamenting n, initial is n
# Returns
#	$v0 : lcm of m,n 
#
# Purpose: Implementing LCM function using recursive call.
# 
#------------------------------------------------------------------------------
lcm_recursive:
	# Store frame
	addi	$sp, $sp, -20
	sw   	$fp, 20($sp)
	sw   	$ra, 16($sp)
	sw   	$a0, 12($sp)
	sw   	$s0,  8($sp)
	addi 	$fp, $sp, 20
	
	# Body
	beq $a2, $a3, lcm_equals	# if (m == n), goto lcm_equals
	bgt $a2, $a3, lcm_check_less	# if (m > n), goto lcm_check_less
	add $a2, $a2, $a0		# else m += m
	j lcm_call
	
lcm_check_less:
	add $a3, $a3, $a1		# else n += n
	
lcm_call:	
	jal lcm_recursive		# jump to start
	
lcm_equals:
	move $v0, $a2			# move $a2 to $v0
	
lcm_ret:
	# Restore frame
	lw   	$fp, 20($sp)
	lw   	$ra, 16($sp)
	lw   	$a0, 12($sp)
	lw   	$s0,  8($sp)
	addi 	$sp, $sp, 20
	
	jr $ra				# jump to caller 
	
