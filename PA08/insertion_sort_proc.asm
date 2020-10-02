.text
#-------------------------------------------
# Procedure: insertion_sort
# Argument: 
#	$a0: Base address of the array
#       $a1: Number of array element
# Return:
#       None
# Notes: Implement insertion sort, base array 
#        at $a0 will be sorted after the routine
#	 is done.
#-------------------------------------------
insertion_sort:
	# Caller RTE store (TBD)
	addi	$sp, $sp, -12 
	sw	$fp, 12($sp)
	sw	$ra, 8($sp)
	addi	$fp, $sp, 12

	# Implement insertion sort (TBD)
	add	$t0, $a0, $zero			# copies $a0 to $t0
	addi	$t1, $zero, 1 			# $t1 = i = 1
insertion_loop:
	bge	$t1, $a1, insertion_sort_end	# if i >= n, go to insertion_sort_end
	add	$t2, $t1, $zero			# $t2 = j = i
	
insertion_while:
	ble 	$t2, $zero, insertion_next	# if j <= 0, go to insertion_next
	
	mul	$t7, $t2, 4			# sets $t7 as j * 4
	addi	$t2, $t2, -1			# j = j-1; to get j-1's mul
	mul	$t8, $t2, 4			# sets $t8 as j-1 * 4
	addi	$t2, $t2, 1			# j = j+1; resets earlier subtraction
	
	add	$t0, $a0, $t8			# sets $t0 to address of [j-1]
	lw	$t4, 0($t0)			# load j-1th digit into $t4
	add	$t0, $a0, $t7			# sets $t0 to address of [j]
	lw	$t5, 0($t0)			# load jth digit into $t5
	bgt	$t4, $t5, insertion_swap	# if [j-1] > [j], go to insertion_swap
	j	insertion_next
	
insertion_swap:
	sw	$t4, 0($t0)			# stores [j-1] to [j]'s previous location
	add	$t0, $a0, $t8			# sets $t0 to address of [j-1]
	sw	$t5, 0($t0)			# stores [j] to [j-1]'s previous location
	addi	$t2, $t2, -1			# j = j-1
	j	insertion_while
	
insertion_next:
	addi	$t1, $t1, 1			# i = i+1
	j	insertion_loop
	
insertion_sort_end:
	move	$a0, $t0			# move sorted array into $a0
	
	# Caller RTE restore (TBD)
	lw	$fp, 12($sp)
	lw	$ra, 8($sp)
	addi	$sp, $sp, 12
	
	# Return to Caller
	jr	$ra
