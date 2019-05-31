# BwFPGATerminal

This is a project designed for the COD final lab of USTC using FPGA.

## 项目简介

利用 uart 协议与 FPGA 进行通信，传输字符数据，FPGA 中的 CPU 通过 Memory-Mapped-I/O 和 polling 的方法获取数据，并传输给 VGA 模块，再由 VGA 模块进行显示，使得屏幕上可以出现键盘输入的字符，电脑接收 FPGA 回传的数据，使得输入的数据可以回显至电脑屏幕上，并且对 CPU 进行改进，支持了全部的基本 31 条 MIPS 指令。

## 一些实现细节

### uart 协议

uart 是一种串口传输协议，主要用于异步通信。
> 起始位：先发出一个逻辑”0”的信号，表示传输字符的开始。
> 资料位：紧接着起始位之后。资料位的个数可以是4、5、6、7、8等，构成一个字符。通常采用ASCII码。从最低位开始传送，靠时钟定位。
> 奇偶校验位：资料位加上这一位后，使得“1”的位数应为偶数(偶校验)或奇数(奇校验)，以此来校验资料传送的正确性。
> 停止位：它是一个字符数据的结束标志。可以是1位、1.5位、2位的高电平。 由于数据是在传输线上定时的，并且每一个设备有其自己的时钟，很可能在通信中两台设备间出现了小小的不同步。因此停止位不仅仅是表示传输的结束，并且提供计算机校正时钟同步的机会。适用于停止位的位数越多，不同时钟同步的容忍程度越大，但是数据传输率同时也越慢。
> 空闲位：处于逻辑“1”状态，表示当前线路上没有资料传送。
> 波特率：是衡量资料传送速率的指标。表示每秒钟传送的符号数（symbol）。一个符号代表的信息量（比特数）与符号的阶数有关。例如传输使用256阶符号，每8bit代表一个符号，资料传送速率为120字符/秒，则波特率就是120baud，比特率是120*8=960bit/s。这两者的概念很容易搞错。

使用状态机实现接收 uart 数据，并且也使用 uart 将数据回传给电脑，使电脑屏幕可以回显输入的字符。

### Memory-Mapped-I/O

为了更好的实现模块化，使得设计更加清晰，本次设计将原本位于 CPU 内部的 Memory 抽象了出来，成为一个独立的单元。但对于 CPU 来说仍然是一块完整的内存，`uart_mem` 和 `vga_mem` 分别对应特定的地址段，对这些地址段的操作即对 I/O 设备进行操作。

### VGA 显示模块

- 显示的每个字符的大小是 8*16,支持 ascii 码 32-127, ascii码的字模全部都预存在 ROM 之中，支持回车，空格，退格。
- 显示器的分辨率是 640*480，这样每行可以显示 80 个字符，每列 30 个字符。
- `vga_mem`中存放的是每个位置中应该显示的字符的 ascii 码，然后 VGA 根据当前扫描的行和列确定当前位置，从`Mem`中取出该位置的字符的 ascii 码。再根据 ROM 中的字模进行渲染。

### Polling I/O

uart_receiver 接收好电脑传来的数据之后会将`uart_mem`中的数据最高位(`ready`位)设置为 1 ，同时停止接收到来的串口数据，CPU 检测到 ready 位为 1 之后，认为数据有效，会将数据加载到`vga_mem`中，然后将 ready 位清零，uart_receiver 可以继续接收数据。Polling I/O 主要由汇编实现，代码如下：

```mips
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

# ready_word:  .word   0x80000000   # 离开后设置 ready 位为 1
# 128-32 is cursor
```

### CPU 改进

原本支持的指令：

- R型中的： ADD, SUB, AND, SLT, OR, XOR, NOR
- I型中的： ADDI, ORI, ANDI, XORI, SLTI,
- 存取指令： LW, SW
- 跳转指令： BEQ, BNE, J

添加的指令：

- R型中的： ADDU, SUBU, SLTU, SLLV, SRLV, SRAV, SLL, SRL, SRA 
- I型中的： ADDIU, SLTIU, LUI
- 跳转指令： JR, JAL

检测添加指令是否正确的脚本：

```mips
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

```

## 项目代码

项目的全部代码见`/file`文件夹。

## 参考文献

[1. About uart](https://baike.baidu.com/item/UART/4429746?fr=aladdin)

[2. MIPS ISA](https://blog.csdn.net/yixilee/article/details/4316617)

