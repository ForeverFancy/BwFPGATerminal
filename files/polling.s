.text
j		_start				    # jump to _start

_start:
	lw 		$s0, backspace		# s0 is backspace
	lw		$s1, del			# s1 is del
	lw		$s2, vertical_tab	# s2 is vertical tab 
	lw 		$s3, enter			# s3 is enter
	addi	$s6, $zero, 128		# s6 is the cursor
    lw		$v1, vga_addr		# v1 is the addr of vga
    andi    $t3, $zero, 4     	# t3 is used to save the location of the current character.
	add 	$t6, $t3, $v1
	sw 		$s6, 0($t6)			# show the cursor
	and 	$s4, $s4, $zero
	lw	    $t0, uart_addr      # t0 is the addr of uart

loop:
	lw	    $v0, 0($t0)         # v0 is the data
	# 检查valid 位
	lw      $t1, valid_mask
	and     $t2, $t1, $v0
	beq     $t2, $zero, loop

	# 数据有效，开始写入 vga_addr
	beq		$v0, $s0, back	
	beq 	$v0, $s1, back
	beq		$v0, $s2, etr
	beq 	$v0, $s3, etr

	sw      $v0, 0($t6)
	addi	$t3, $t3, 4			# $t3 = $t3 + 1
    add		$t6, $t3, $v1		# $t6 = $t3 + $v1
    sw 		$s6, 0($t6)
	
    # 设置 ready 位为 0
set:
	sw      $zero, 0($t0) 
	nop   
    j		loop				# jump to loop

back:
	# addi 	$t6, $t6, -4
	add		$t6, $t3, $v1		# $t6 = $t3 + $v1
	sw		$zero,0($t6)		# remove the cursor
	addi	$t3, $t3, -4
	add		$t6, $t3, $v1
	sw 		$s6, 0($t6)
	j		set					# jump to set

etr:
	add		$t6, $t3, $v1
	sw 		$zero, 0($t6)
	slt		$s5, $t3, $s4
	bne		$s5, $zero, change	    # if $s5 != zero then target
	addi 	$s4, $s4, 320
	j		etr						# jump to enter

change:
	add 	$t3, $s4, $zero
	addi 	$t3, $t3, 4
	add		$t6, $t3, $v1		# $t6 = $t3 + $v1
	sw 		$s6, 0($t6)
	j		set					# jump to set
	    
uart_addr:	.word	 0x00004404   # uart 的地址
vga_addr:    .word   0x000003FC   # vga 的地址
valid_mask:  .word   0x80000000   # valid 在 30 位
backspace: 	.word    0x80000008	  # backspace
del:		.word	 0x8000007F	  # del
vertical_tab: .word    0x8000000D  # vertical tab
enter: 		.word    0x8000000A	  # enter
full:		.word 	 0x00000910	

#ready_word:  .word   0x80000000   # 离开后设置 ready 位为 1
# 97 is cursor
