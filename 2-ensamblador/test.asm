ISEVEN:
LOADI R1 1 
AND R0 R1
JZ EVEN
LOADI R2 0
JMP END

EVEN:
LOADI R2 1

END:
HALT