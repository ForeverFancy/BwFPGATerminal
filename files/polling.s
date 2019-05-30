.text
j		_start				    # jump to _start

_start:
	lw 		$s0, backspace		# s0 is backspace
    lw		$v1, vga_addr		# v1 is the addr of vga
    and     $t3, $t3, $zero     # t3 is used to save the location of the current character.
	lw	    $t0, uart_addr      # t0 is the addr of uart

loop:
	lw	    $v0, 0($t0)         # v0 is the data
	# 检查valid 位
	lw      $t1, valid_mask
	and     $t2, $t1, $v0
	beq     $t2, $zero, loop

	# 数据有效，开始写入 vga_addr
	beq		$v0, $s0, back	

	addi	$t3, $t3, 4			# $t3 = $t3 + 1
    add		$t6, $t3, $v1		# $t6 = $t3 + $v1
    sw      $v0, 0($t6)
    
    # 设置 ready 位为 0
set:
	sw      $zero, 0($t0) 
	nop   
    j		loop				# jump to loop

back:
	# addi 	$t6, $t6, -4
	sw		$zero,0($t6)
	addi	$t3, $t3, -4
	add 	$t6, $t3, $v1
	j		set					# jump to set
	    
uart_addr:	.word	 0x00004404   # uart 的地址
vga_addr:    .word   0x000003FC   # vga 的地址
valid_mask:  .word   0x80000000   # valid 在 30 位
backspace: 	.word    0x10000008	  # backspace
#ready_word:  .word   0x80000000   # 离开后设置 ready 位为 1
