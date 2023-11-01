.data
list:.word   4, 22, 18, 1, 9, 10, 11
size: .word 7

.text
.globl main

main:
    add     $t0, $zero,  $zero
    lui     $s0, 0x1001             
    ori     $s0, $s0, 0x0000 
    lw      $s1, size
    addi    $t7, $zero,  0
outer_loop:
    beq     $t0, $s1, exit
    sub     $t7, $s1,    $t0
    addi    $t7, $t7,    -1
    add     $t1, $zero,  $zero
inner_loop:
    beq     $t1, $t7,    continue
    sll     $t6, $t1,    2
    add     $t6, $s0,    $t6
    lw      $s2, 0($t6)
    lw      $s3, 4($t6)
    slt     $t2, $s3,    $s2
    beq     $t2,        $zero,  sorted
    sw      $s3,        0($t6)
    sw      $s2,        4($t6)
sorted:
    addi    $t1,        $t1,    1
    j       inner_loop
continue:
    addi    $t0,        $t0,    1
    j       outer_loop
exit:
    halt    

