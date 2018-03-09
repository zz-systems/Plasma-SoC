
	.global 	_reset_vector
	.global 	_interrupt_vector
	.set 		noreorder

	.section	.vector.reset
_reset_vector:
	la		$26, crtp_init
	jr		$26
	nop
	
	.section	.vector.interrupt	
_interrupt_vector:
	la		$26, interrupt_service_routine
	jr		$26
	nop

	.set reorder
