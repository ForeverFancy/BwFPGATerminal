# Lab6

### PB17000215 张博文

## CPU 改进

原本支持的指令：
- R型中的： ADD, SUB, AND, SLT, OR, XOR, NOR
- I型中的： ADDI, ORI, ANDI, XORI, SLTI,
- 存取指令： LW, SW
- 跳转指令： BEQ, BNE, J

添加的指令：
- R型中的： ADDU, SUBU, SLTU, SLLV, SRLV, SRAV, <!--SLL, SRL, SRA> 
- I型中的： ADDIU, SLTIU, <!--LUI>
- 跳转指令： JR, JAL