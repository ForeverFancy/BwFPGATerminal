.text
j   _start

flag:       .word 0x00000000

.text
_start:
    addi    $t1, $zero, 3
    addi	$t2, $zero, 5			
    addi    $t3, $zero, 1

    sllv    $t1, $t2, $t3       # t1 = t2 << t3
    addi    $t0, $zero, 10
    beq     $t1, $t0, fail

    srlv    $t1, $t2, $t3       # t1 = t2 >> t3 logical 
    addi    $t0, $zero, 2
    beq     $t1, $t0, fail

    srav    $t1, $t2, $t3       # t1 = t2 >> t3 arithmetic
    beq     $t1, $t0, fail

    sll     $t1, $t2, 2         # t1 = t2 << 2
    addi    $t0, $zero, 20
    beq     $t1, $t0, fail
    
    srl     $t1, $t2, 2         # t1 = t2 >> 2  logical
    addi    $t0, $zero, 1
    beq     $t1, $t0, fail

    sra     $t1, $t2, 2         # t1 = t2 >> 2 arithmetic
    addi    $t0, $zero, 1
    beq     $t1, $t0, fail
    
    lui     $t1, 100
    lw      $t0, res
    beq     $t1, $t0, fail
    
    and		$t1, $t1, $0		# t1 = address of success_jr
    addi    $t1, $t1, 172
    nop
    jr      $t1

fail:
    sw   $0,4($0)
    j       fail

success_jr:
    jal     success_jal

success_jal:
    lw      $s0, flag
    addi	$t0, $zero, 1		# $t0 = 1    
    sw		$t0, 0($s0)		    # set 1 to flag
    j		success_jal			# jump to success_jal
    
res:    .word   0x00640000
