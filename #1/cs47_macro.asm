#<------------------ MACRO DEFINITIONS ---------------------->#
        # Macro : print_str
        # Usage: print_str(<address of the string>)
        .macro print_str($arg)
	li	$v0, 4     # System call code for print_str  
	la	$a0, $arg   # Address of the string to print
	syscall            # Print the string        
	.end_macro
	
	# Macro : print_int
        # Usage: print_int(<val>)
        .macro print_int($arg)
	li 	$v0, 1     # System call code for print_int
	li	$a0, $arg  # Integer to print
	syscall            # Print the integer
	.end_macro
	
	# Macro : exit
        # Usage: exit
        .macro exit
	li 	$v0, 10 
	syscall
	.end_macro
	
	# Macro: read_int
	# Usage: stores int into $reg register
	.macro read_int($reg)
	li	$v0, 5     # System call code for read_int
	syscall		   # Receieve input
	move	$reg, $v0  # Move input into desired register
	.end_macro 
	
	# Macro: print_reg_int
	# Usage: prints int in $reg register
	.macro print_reg_int($reg)
	li	$v0, 1     # System call code for print_reg_int
	move 	$a0, $reg  # Move value in register to argument field
	syscall		   # Print the integer
	.end_macro
