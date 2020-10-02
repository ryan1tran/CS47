.include "./cs47_proj_macro.asm"
.text
.globl au_logical
# TBD: Complete your project procedures
# Needed skeleton is given
#####################################################################
# Implement au_logical
# Argument:
# 	$a0: First number
#	$a1: Second number
#	$a2: operation code ('+':add, '-':sub, '*':mul, '/':div)
# Return:
#	$v0: ($a0+$a1) | ($a0-$a1) | ($a0*$a1):LO | ($a0 / $a1)
# 	$v1: ($a0 * $a1):HI | ($a0 % $a1)
# Notes:
#####################################################################
au_logical:
# TBD: Complete it
	addi	$sp, $sp, -76
	sw	$fp, 76($sp)
	sw	$ra, 72($sp)
	sw	$s0, 68($sp)
	sw	$s1, 64($sp)
	sw	$s2, 60($sp)
	sw	$a0, 56($sp)
	sw	$a1, 52($sp)
	sw	$a2, 48($sp)
	sw	$t0, 44($sp)
	sw	$t1, 40($sp)
	sw	$t2, 36($sp)
	sw	$t3, 32($sp)
	sw	$t4, 28($sp)
	sw	$t5, 24($sp)
	sw	$t6, 20($sp)
	sw	$t7, 16($sp)
	sw	$t8, 12($sp)
	sw	$t9, 8($sp)
	addi	$fp, $sp, 76
	
	ori	$s0, $a0, 0
	ori	$s1, $a1, 0
	ori	$s2, $a2, 0
	
	beq	$s2, '+', addition
	beq	$s2, '-', subtract
	beq	$s2, '*', multiply
	beq	$s2, '/', divide
	j end
	
addition:	# addition/subtract uses t0, t1, t2, t3, t4, t5, t7, t8, t9
	ori	$t0, $zero, 1	# $t0 is counter
	ori	$t4, $zero, 0	# $t4 is Cin
	ori	$t5, $zero, 0	# $t5 is sum
	
addition_loop:
	and	$t1, $a0, $t0	# $t1 is $t0th bit of $s0
	and	$t2, $a1, $t0	# $t2 is $t0th bit of $s1
	
	xor	$t3, $t1, $t2	# A xor B  |  $t3 is sum of $t0th bits
	xor	$t3, $t3, $t4	# (A xor B) xor Cin  |  adds Cin to $t3
	or	$t5, $t5, $t3	# $t5 is current sum
	
	and	$t7, $t1, $t2	# A.B
	xor	$t8, $t1, $t2	# A xor B
	and	$t9, $t4, $t8	# Cin.(A xor B)
	or	$t4, $t9, $t7	# Cin.(A xor B) + A.B  |  $t4 is Cout
		
	sll	$t4, $t4, 1	# shift $t4 left once
	sll	$t0, $t0, 1	# shift $t0 left once
	beqz	$t0, add_end	# if $t0 is 0, jump to add_end
	
	j addition_loop
	
add_end:
	ori	$v0, $t5, 0
	ori	$v1, $t4, 0
	j end
	
subtract:
	not	$a1, $a1
	
	ori	$t0, $zero, 1	# $t0 is counter
	ori	$t4, $zero, 1	# $t4 is Cin
	ori	$t5, $zero, 0	# $t5 is sum
	
	j addition_loop
	
multiply:
	ori	$t0, $zero, 0x80000000	# set $t0 to 1000...0000
	and	$t1, $s0, $t0		# first bit of $s0
	and	$t2, $s1, $t0		# first bit of $s1
	
	beqz	$t1, first_positive	# if $t1 = 0, goto first_positive
	sub_logical($zero, $s0)		# else twos_complement $s0
	ori	$s0, $v0, 0		# store value back into $s0
	
first_positive:
	beqz	$t2, next		# if $t2 = 0, goto complement_second
	sub_logical($zero, $s1)		# else twos_complement $s1
	ori	$s1, $v0, 0		# store value back into $s1
	
next:
	ori	$t9, $zero, 1		# set $t9 to 1 (placeholder/signs are opposite)
	beq	$t1, $t2, sign_equal	# if $t1 = $t2, goto sign_equal
	j multiply_start

sign_equal:
	ori	$t9, $zero, 0		# else set $t9 to 0 (both +)

multiply_start:
	ori	$t0, $zero, 1	# $t0 is the bit location
	ori	$t1, $zero, 0	# $t1 is shamt
	ori	$t5, $zero, 0	# $t5 is lo
	ori	$t6, $zero, 0	# $t6 is hi	
	
multiply_loop:
	and	$t3, $s0, $t0	# $t3 is $t0th bit of $s1
	beqz	$t3, skip	# if $t3 = 0, goto skip
	
	sllv	$t4, $s1, $t1	# shift $s1 by shamt
	add_logical($t5, $t4)	# add shifted value to lo
	ori	$t5, $v0, 0	# store new value in lo
	
	add_logical($t6, $v1)	# add Cin to hi
	ori	$t6, $v0, 0	# store new value in hi
	sub_logical(31, $t1)	# subtract 31 by shamt
	srlv	$t3, $s1, $v0	# shift right to get hi value
	srl	$t3, $t3, 1	# shift right once more because shifting by 32 - shamt doesn't work?
	add_logical($t6, $t3)	# add value to hi
	ori	$t6, $v0, 0	# store new value in hi
	
skip:
	sll	$t0, $t0, 1	# shift bit location left once
	add_logical($t1, 1)	# add 1 to shamt
	or	$t1, $zero, $v0	# store new shamt
	beqz	$t0, multiply_sign_check	# if bit location is 0, goto multiply_sign_check
	j multiply_loop
	
multiply_sign_check:
	beqz	$t9, multiply_end	# if signs are equal, goto multiply_end
	sub_logical($zero, $t5)		# else twos_complement lo
	ori	$t5, $v0, 0		# store new value in lo
	not	$t6, $t6		# inverse hi
	add_logical($t6, $v1)		# add cout of lo to hi
	ori	$t6, $v0, 0		# store new value in hi
	
multiply_end:
	ori	$v0, $t5, 0		# store lo in $v0
	ori	$v1, $t6, 0		# store hi in $v1
	j end
	
divide:
	ori	$t0, $zero, 0x80000000	# set $t0 to 1000...0000 (32 bit)
	and	$t1, $s0, $t0		# first bit of $s0
	and	$t2, $s1, $t0		# first bit of $s1
	
	beqz	$t1, dividend_positive	# if $t1 = 0, goto dividend_positive
	sub_logical($zero, $s0)		# else twos_complement $s0
	ori	$s0, $v0, 0		# store value back into $s0
	ori	$t8, $zero, 1		# sets $t8 to 1 (dividend is negative)
	
dividend_positive:
	beqz	$t2, divide_start	# if $t2 = 0, goto divide_start
	sub_logical($zero, $s1)		# twos_complement $s1
	ori	$s1, $v0, 0		# store value back into $s1
	ori	$t9, $zero, 1		# sets $t9 to 1 (divisor is negative)
	
divide_start:
	ori	$t0, $zero, 1		# $t0 is counter
	ori	$t4, $s1, 0		# $t4 is divisor
	ori	$t5, $s0, 0		# $t5 is dividend/quotient
	ori	$t6, $zero, 0		# $t6 is remainder
	
divide_loop:
	sll	$t6, $t6, 1		# shift remainder left once
	ori	$t2, $zero, 0x80000000	# last bit
	and	$t2, $t5, $t2		# retrieves last bit of dividend
	srl	$t2, $t2, 31		# shifts last bit to lsb
	or	$t6, $t6, $t2		# inserts last bit of dividend into first bit of remainder
	
	sll	$t5, $t5, 1		# shifts dividend left once
	
	sub_logical($t6, $t4)			# difference between remainder and divisor
	blt	$v0, $zero, divide_loop_repeat	# if < 0, goto divide_loop_repeat
	ori	$t6, $v0, 0			# else difference is new remainder
	or	$t5, $t5, 1			# sets first bit of dividend as one
	
divide_loop_repeat:
	sll	$t0, $t0, 1		# increment counter
	beqz	$t0, divide_sign_check	# if = 0, goto divide_sign_check
	j	divide_loop
	
divide_sign_check:
	beq	$t8, $t9, signs_equal	# if both are same sign, goto sign_equal
	beqz	$t8, other_case		# else if not same sign and $t8 = 0, goto other_case
	sub_logical($zero, $t5)		# else 2's complement quotient
	ori	$t5, $v0, 0		# store
	sub_logical($zero, $t6)		# 2's complement remainder
	ori	$t6, $v0, 0		# store
	j divide_end
	
signs_equal:
	beqz	$t8, divide_end		# if both are = 0, goto divide_end
	sub_logical($zero, $t6)		# else 2's complement remainder
	ori	$t6, $v0, 0		# store
	j divide_end
	
other_case:
	sub_logical($zero, $t5)		# 2's complement quotient
	ori	$t5, $v0, 0		# store
	
divide_end:
	ori	$v0, $t5, 0		# store lo in $v0
	ori	$v1, $t6, 0		# store hi in $v1
	
end:
	lw	$fp, 76($sp)
	lw	$ra, 72($sp)
	lw	$s0, 68($sp)
	lw	$s1, 64($sp)
	lw	$s2, 60($sp)
	lw	$a0, 56($sp)
	lw	$a1, 52($sp)
	lw	$a2, 48($sp)
	lw	$t0, 44($sp)
	lw	$t1, 40($sp)
	lw	$t2, 36($sp)
	lw	$t3, 32($sp)
	lw	$t4, 28($sp)
	lw	$t5, 24($sp)
	lw	$t6, 20($sp)
	lw	$t7, 16($sp)
	lw	$t8, 12($sp)
	lw	$t9, 8($sp)
	addi	$sp, $sp, 76
	jr 	$ra
