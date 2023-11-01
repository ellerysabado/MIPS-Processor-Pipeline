# beq, bne, j, jal, jr
.data
out: .asciiz "Done!"
.text

# Jump to begin
jal begin
add $t2, $t1, $t1
bne $t1, $t2, compare

begin:
    addi $t1, $0, 12
    j loop

compare:
    sll $t1, $t1, 1
    beq $t1, $t2, loop
    jr $0

loop:
    addi $v0, $0, 4
    la $a0, out
    j done

done:
    syscall
     #Exit program
     halt
