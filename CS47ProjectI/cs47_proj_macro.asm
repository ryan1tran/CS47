# Add you macro definition here - do not touch cs47_common_macro.asm"
#<------------------ MACRO DEFINITIONS ---------------------->#
	.macro	add_logical($num, $ber)
	or	$a0, $zero, $num
	or	$a1, $zero, $ber
	ori	$a2, $zero, '+'
	jal au_logical
	.end_macro
	
	.macro	sub_logical($num, $ber)
	or	$a0, $zero, $num
	or	$a1, $zero, $ber
	ori	$a2, $zero, '-'
	jal au_logical
	.end_macro
