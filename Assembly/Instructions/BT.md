https://www.felixcloutier.com/x86/bt
# BT — Bit Test

|Opcode|Instruction|Op/En|64-bit Mode|Compat/Leg Mode|Description|
|---|---|---|---|---|---|
|0F A3 /r|BT r/m16, r16|MR|Valid|Valid|Store selected bit in CF flag.|
|0F A3 /r|BT r/m32, r32|MR|Valid|Valid|Store selected bit in CF flag.|
|REX.W + 0F A3 /r|BT r/m64, r64|MR|Valid|N.E.|Store selected bit in CF flag.|
|0F BA /4 ib|BT r/m16, imm8|MI|Valid|Valid|Store selected bit in CF flag.|
|0F BA /4 ib|BT r/m32, imm8|MI|Valid|Valid|Store selected bit in CF flag.|
|REX.W + 0F BA /4 ib|BT r/m64, imm8|MI|Valid|N.E.|Store selected bit in CF flag.|

## Instruction Operand Encoding [¶](https://www.felixcloutier.com/x86/bt#instruction-operand-encoding)

|Op/En|Operand 1|Operand 2|Operand 3|Operand 4|
|---|---|---|---|---|
|MR|ModRM:r/m (r)|ModRM:reg (r)|N/A|N/A|
|MI|ModRM:r/m (r)|imm8|N/A|N/A|

## Description [¶](https://www.felixcloutier.com/x86/bt#description)

Selects the bit in a bit string (specified with the first operand, called the bit base) at the bit-position designated by the bit offset (specified by the second operand) and stores the value of the bit in the CF flag. The bit base operand can be a register or a memory location; the bit offset operand can be a register or an immediate value:

- If the bit base operand specifies a register, the instruction takes the modulo 16, 32, or 64 of the bit offset operand (modulo size depends on the mode and register size; 64-bit operands are available only in 64-bit mode).
- If the bit base operand specifies a memory location, the operand represents the address of the byte in memory that contains the bit base (bit 0 of the specified byte) of the bit string. The range of the bit position that can be referenced by the offset operand depends on the operand size.

See also: **Bit(BitBase, BitOffset)** on page 3-11.

Some assemblers support immediate bit offsets larger than 31 by using the immediate bit offset field in combination with the displacement field of the memory operand. In this case, the low-order 3 or 5 bits (3 for 16-bit operands, 5 for 32-bit operands) of the immediate bit offset are stored in the immediate bit offset field, and the high-order bits are shifted and combined with the byte displacement in the addressing mode by the assembler. The processor will ignore the high order bits if they are not zero.

When accessing a bit in memory, the processor may access 4 bytes starting from the memory address for a 32-bit operand size, using by the following relationship:

Effective Address + (4 ∗ (BitOffset DIV 32))

Or, it may access 2 bytes starting from the memory address for a 16-bit operand, using this relationship:

Effective Address + (2 ∗ (BitOffset DIV 16))

It may do so even when only a single byte needs to be accessed to reach the given bit. When using this bit addressing mechanism, software should avoid referencing areas of memory close to address space holes. In particular, it should avoid references to memory-mapped I/O registers. Instead, software should use the MOV instructions to load from or store to these addresses, and use the register form of these instructions to manipulate the data.

In 64-bit mode, the instruction’s default operation size is 32 bits. Using a REX prefix in the form of REX.R permits access to additional registers (R8-R15). Using a REX prefix in the form of REX.W promotes operation to 64 bit operands. See the summary chart at the beginning of this section for encoding data and limits.

## Operation [¶](https://www.felixcloutier.com/x86/bt#operation)

CF := Bit(BitBase, BitOffset);

## Flags Affected [¶](https://www.felixcloutier.com/x86/bt#flags-affected)

The CF flag contains the value of the selected bit. The ZF flag is unaffected. The OF, SF, AF, and PF flags are undefined.

## Protected Mode Exceptions [¶](https://www.felixcloutier.com/x86/bt#protected-mode-exceptions)

|   |   |
|---|---|
|#GP(0)|If a memory operand effective address is outside the CS, DS, ES, FS, or GS segment limit.|
|If the DS, ES, FS, or GS register contains a NULL segment selector.|
|#SS(0)|If a memory operand effective address is outside the SS segment limit.|
|#PF(fault-code)|If a page fault occurs.|
|#AC(0)|If alignment checking is enabled and an unaligned memory reference is made while the current privilege level is 3.|
|#UD|If the LOCK prefix is used.|

## Real-Address Mode Exceptions [¶](https://www.felixcloutier.com/x86/bt#real-address-mode-exceptions)

|   |   |
|---|---|
|#GP|If a memory operand effective address is outside the CS, DS, ES, FS, or GS segment limit.|
|#SS|If a memory operand effective address is outside the SS segment limit.|
|#UD|If the LOCK prefix is used.|

## Virtual-8086 Mode Exceptions [¶](https://www.felixcloutier.com/x86/bt#virtual-8086-mode-exceptions)

|   |   |
|---|---|
|#GP(0)|If a memory operand effective address is outside the CS, DS, ES, FS, or GS segment limit.|
|#SS(0)|If a memory operand effective address is outside the SS segment limit.|
|#PF(fault-code)|If a page fault occurs.|
|#AC(0)|If alignment checking is enabled and an unaligned memory reference is made.|
|#UD|If the LOCK prefix is used.|

## Compatibility Mode Exceptions [¶](https://www.felixcloutier.com/x86/bt#compatibility-mode-exceptions)

Same exceptions as in protected mode.

## 64-Bit Mode Exceptions [¶](https://www.felixcloutier.com/x86/bt#64-bit-mode-exceptions)

|   |   |
|---|---|
|#SS(0)|If a memory address referencing the SS segment is in a non-canonical form.|
|#GP(0)|If the memory address is in a non-canonical form.|
|#PF(fault-code)|If a page fault occurs.|
|#AC(0)|If alignment checking is enabled and an unaligned memory reference is made while the current privilege level is 3.|
|#UD|If the LOCK prefix is used.|