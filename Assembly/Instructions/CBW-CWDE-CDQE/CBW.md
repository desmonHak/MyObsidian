https://www.felixcloutier.com/x86/cbw:cwde:cdqe


# [[CBW]]/[[CWDE]]/[[CDQE]] — Convert Byte to Word/Convert Word to Doubleword/Convert Doubleword toQuadword

|Opcode|Instruction|Op/En|64-bit Mode|Compat/Leg Mode|Description|
|---|---|---|---|---|---|
|98|CBW|ZO|Valid|Valid|AX := sign-extend of AL.|
|98|CWDE|ZO|Valid|Valid|EAX := sign-extend of AX.|
|REX.W + 98|CDQE|ZO|Valid|N.E.|RAX := sign-extend of EAX.|

## Instruction Operand Encoding [¶](https://www.felixcloutier.com/x86/cbw:cwde:cdqe#instruction-operand-encoding)

|Op/En|Operand 1|Operand 2|Operand 3|Operand 4|
|---|---|---|---|---|
|ZO|N/A|N/A|N/A|N/A|

## Description [¶](https://www.felixcloutier.com/x86/cbw:cwde:cdqe#description)

Double the size of the source operand by means of sign extension. The CBW (convert byte to word) instruction copies the sign (bit 7) in the source operand into every bit in the AH register. The CWDE (convert word to double-word) instruction copies the sign (bit 15) of the word in the AX register into the high 16 bits of the EAX register.

CBW and CWDE reference the same opcode. The CBW instruction is intended for use when the operand-size attribute is 16; CWDE is intended for use when the operand-size attribute is 32. Some assemblers may force the operand size. Others may treat these two mnemonics as synonyms (CBW/CWDE) and use the setting of the operand-size attribute to determine the size of values to be converted.

In 64-bit mode, the default operation size is the size of the destination register. Use of the REX.W prefix promotes this instruction (CDQE when promoted) to operate on 64-bit operands. In which case, CDQE copies the sign (bit 31) of the doubleword in the EAX register into the high 32 bits of RAX.

## Operation [¶](https://www.felixcloutier.com/x86/cbw:cwde:cdqe#operation)

IF OperandSize = 16 (* Instruction = CBW *)
    THEN
        AX := SignExtend(AL);
    ELSE IF (OperandSize = 32, Instruction = CWDE)
        EAX := SignExtend(AX); FI;
    ELSE (* 64-Bit Mode, OperandSize = 64, Instruction = CDQE*)
        RAX := SignExtend(EAX);
FI;

## Flags Affected [¶](https://www.felixcloutier.com/x86/cbw:cwde:cdqe#flags-affected)

None.

## Exceptions (All Operating Modes) [¶](https://www.felixcloutier.com/x86/cbw:cwde:cdqe#exceptions--all-operating-modes-)

#UD If the LOCK prefix is used.