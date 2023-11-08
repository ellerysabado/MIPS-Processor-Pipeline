.data
list:.word   4, 22, 18, 1, 9, 10, 11
size: .word 7

.text
.globl main

main:
    add     $t0, $zero,  $zero
    lui     $s0, 0x1001    
    nop
    nop
    nop
    ori     $s0, $s0, 0x0000 
    lui     $1, 4097
    nop 
    nop
    nop
    lw      $s1, 0($1)
    nop
    nop
    addi    $t7, $zero,  0
outer_loop:
    beq     $t0, $s1, exit
    nop
    nop
    sub     $t7, $s1,    $t0
    nop
    nop
    nop
    addi    $t7, $t7,    -1
    add     $t1, $zero,  $zero
    nop
    nop
    nop
inner_loop:
    beq     $t1, $t7,    continue
    nop
    nop
    sll     $t6, $t1,    2
    nop
    nop
    nop
    add     $t6, $s0,    $t6
    nop
    nop
    nop
    lw      $s2, 0($t6)
    lw      $s3, 4($t6)
    nop
    nop
    nop
    slt     $t2, $s3,    $s2
    nop
    nop
    nop
    beq     $t2,        $zero,  sorted
    nop
    nop
    sw      $s3,        0($t6)
    nop
    nop
    nop
    sw      $s2,        4($t6)
sorted:
    addi    $t1,        $t1,    1
    nop
    nop
    nop
    j       inner_loop
    nop
    nop
continue:
    addi    $t0,        $t0,    1
    nop
    nop
    nop
    j       outer_loop
    nop
    nop
exit: 

halt
