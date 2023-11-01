    .data
    result_msg: .asciiz "The final result: "
    .text
    .globl main
main:
    # Load immediate value into $t0
    lui $t0, 0x000f      # Load the upper 16 bits of the immediate value (15)
    ori $t0, $t0, 0x000f # Load the lower 16 bits of the immediate value

    # Load immediate value into $t1
    lui $t1, 0x0017      # Load the upper 16 bits of the immediate value (23)
    ori $t1, $t1, 0x0003 # Load the lower 16 bits of the immediate value

    # Perform various bitwise operations
    slt $t2, $t0, $t1    # Set $t2 to 1 if $t0 < $t1, 0 otherwise
    and $t3, $t0, $t1    # $t3 = $t0 AND $t1
    or $t4, $t0, $t1     # $t4 = $t0 OR $t1
    xor $t5, $t0, $t1    # $t5 = $t0 XOR $t1
    sll $t6, $t0, 2      # $t6 = $t0 shifted left logical by 2 bits
    srl $t7, $t1, 2      # $t7 = $t1 shifted right logical by 2 bit
    sra $t8, $t0, 2      # $t8 = $t0 shifted right arithmetic by 2 bits
    nor $t9, $t0, $t1    # $t9 = NOR of $t0 and $t1

#exit the program
    halt
