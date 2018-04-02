	.align 2
	#.comm ISR_Table, 128   

	.text
	.align 2
	.global crtp_init
	.ent	crtp_init
crtp_init:
	.set noreorder

	la    $gp, __gp				#initialize global pointer
	la    $sp, __stack_end		#initialize stack pointer

# CLEAR BSS
	la    $5,  __bss_start		
	la    $4,  __bss_end		
$BSS_CLEAR:
	sw    $0, 0($5)
	slt   $3, $5, $4
	bnez  $3, $BSS_CLEAR
	addiu $5, $5, 4

# CLEAR SBSS
	la    $5,  __sbss_start		
	la    $4,  __sbss_end		
$SBSS_CLEAR:
	sw    $0, 0($5)
	slt   $3, $5, $4
	bnez  $3, $SBSS_CLEAR
	addiu $5, $5, 4
	
# COPY DATA
	la	  $6, __rom_data_start
	la    $5,  __data_start		
	la    $4,  __data_end		
$DATA_COPY:
	lw    $3, 0($6)
	sw    $3, 0($5)
	slt   $3, $5, $4	
	addiu $6, $6, 4
	bnez  $3, $DATA_COPY
	addiu $5, $5, 4

# COPY SDATA
	la	  $6, __rom_sdata_start
	la    $5,  __sdata_start		
	la    $4,  __sdata_end		
$SDATA_COPY:
	lw    $3, 0($6)
	sw    $3, 0($5)
	slt   $3, $5, $4	
	addiu $6, $6, 4
	bnez  $3, $SDATA_COPY
	addiu $5, $5, 4

    # jal kinit_sections
    # nop
    jal kinit_heap
    nop

# JUMP TO MAIN
	jal   main
	nop
$L1:
	j $L1

	.end crtp_init


###################################################
   .global interrupt_service_routine
   .ent interrupt_service_routine
interrupt_service_routine:
   .set noreorder
   .set noat

   #Registers $26 and $27 are reserved for the OS
   #Save all temporary registers
   #Slots 0($29) through 12($29) reserved for saving a0-a3
   addi  $29, $29, -104  #adjust sp
   sw    $1,  16($29)    #at
   sw    $2,  20($29)    #v0
   sw    $3,  24($29)    #v1
   sw    $4,  28($29)    #a0
   sw    $5,  32($29)    #a1
   sw    $6,  36($29)    #a2
   sw    $7,  40($29)    #a3
   sw    $8,  44($29)    #t0
   sw    $9,  48($29)    #t1
   sw    $10, 52($29)    #t2
   sw    $11, 56($29)    #t3
   sw    $12, 60($29)    #t4
   sw    $13, 64($29)    #t5
   sw    $14, 68($29)    #t6
   sw    $15, 72($29)    #t7
   sw    $24, 76($29)    #t8
   sw    $25, 80($29)    #t9
   sw    $31, 84($29)    #lr
   mfc0  $26, $14        #C0_EPC=14 (Exception PC)
   addi  $26, $26, -4    #Backup one opcode
   sw    $26, 88($29)    #pc
   mfhi  $27
   sw    $27, 92($29)    #hi
   mflo  $27
   sw    $27, 96($29)    #lo

#    lui   $6,  0x2000
# _ISR_TEST_STATUS:
#    lw    $6,  0x08($6)   #IRQ_STATUS
#    beq   $0, $6, _ISR_DONE
#    add  $4, $0, $0
#    addi $5, $0, 1

# _ISR_BIT_LOOP:
#    and  $8, $6, $5  # mask lowest bit
#    beq  $5, $8, _ISR_BIT_FOUND
#    srl  $6, $6, 1
#    addi $4, $4, 1
#    j  _ISR_BIT_LOOP
#    nop

# _ISR_BIT_FOUND:
#    sw    $4, 100($29)
#    jal   kir_handler #OS_InterruptServiceRoutine #$4 = IR-Number
#    addi  $5,  $29, 0
#    lw    $4, 100($29)

#    addi $5, $0, 1
#    sll  $5, $5, $4
#    lui   $6,  0x2000
#    sw    $5,  0x10($6)   #IRQ_CLEAR
#    sw    $0,  0x10($6)   #IRQ_CLEAR


#    j  _ISR_TEST_STATUS
#    nop
    jal   kir_handler
    nop

_ISR_DONE:
   #Restore all temporary registers
   lw    $1,  16($29)    #at
   lw    $2,  20($29)    #v0
   lw    $3,  24($29)    #v1
   lw    $4,  28($29)    #a0
   lw    $5,  32($29)    #a1
   lw    $6,  36($29)    #a2
   lw    $7,  40($29)    #a3
   lw    $8,  44($29)    #t0
   lw    $9,  48($29)    #t1
   lw    $10, 52($29)    #t2
   lw    $11, 56($29)    #t3
   lw    $12, 60($29)    #t4
   lw    $13, 64($29)    #t5
   lw    $14, 68($29)    #t6
   lw    $15, 72($29)    #t7
   lw    $24, 76($29)    #t8
   lw    $25, 80($29)    #t9
   lw    $31, 84($29)    #lr
   lw    $26, 88($29)    #pc
   lw    $27, 92($29)    #hi
   mthi  $27
   lw    $27, 96($29)    #lo
   mtlo  $27
   addi  $29, $29, 104   #adjust sp

isr_return:
   ori   $27, $0, 0x1    #re-enable interrupts
   jr    $26
   mtc0  $27, $12        #STATUS=1; enable interrupts

   .end interrupt_service_routine
   .set at


###################################################
   .global OS_AsmInterruptEnable
   .ent OS_AsmInterruptEnable
OS_AsmInterruptEnable:
   .set noreorder
   mfc0  $2, $12
   jr    $31
   mtc0  $4, $12            #STATUS=1; enable interrupts
   #nop
   .set reorder
   .end OS_AsmInterruptEnable

   
# ###################################################
#    .global OS_RegisterInterrupt
#    .ent OS_RegisterInterrupt
# OS_RegisterInterrupt:
#    .set noreorder
#    # $4 = Handler
#    # $5 = Flags
#    andi	$8, $5, 0x001F
#    sll	$9, $8, 2
#    sw	$4, ISR_Table($9)
   
#    lui	$9, 0x2000
#    ori	$12, $0, 1
#    sll	$12, $12, $8
#    nor	$12, $0, $12
   
#    srl	$10, $5, 16
#    andi	$10, $10, 1
#    sll	$10, $10, $8
#    lw	$11, 0x14($9) # Invert
#    and	$11, $11, $12
#    or	$11, $11, $10
#    sw	$11, 0x14($9) # Invert
   

#    srl	$10, $5, 17
#    andi	$10, $10, 1
#    sll	$10, $10, $8
#    lw	$11, 0x1C($9) # Edge
#    and	$11, $11, $12
#    or	$11, $11, $10
#    sw	$11, 0x1C($9) # Edge
   
#    jr    $31
#    nop
#    .set reorder
#    .end OS_RegisterInterrupt