.section .data

input_a:
    .asciiz "Input A\n"
input_x:
    .asciiz "Input X\n"
new_line:
    .asciiz "\n"
    
print_y1:
    .asciiz "Y1 = "
print_y2:
    .asciiz ", Y2 = "
print_y:
    .asciiz "Y = "
  
.section .text
    .global __start


__start:
    li a0, 4
    la a1, input_a
    ecall
    
    li a0, 5
    ecall
    
    mv t1, a0
    
    li a0, 4
    la a1, input_x
    ecall
    
    li a0, 5
    ecall
    
    mv t2, a0
    
    li t0, 0

loop:
    li t3, 4
    ble t2, t3, less_or_equal_four

    li t5, 4
    sub s2, t2, t1
    j continue
    
less_or_equal_four:
    li t3, 4
    mul s2, t3, t2
    j continue

    
continue:
    li t3, 2
    rem t5, t2, t3
    bnez t5, odd_number
    li t3, 2 
    div t5, t2, t3
    add s3, t5, t1
    j result
    
odd_number:
    li s3, 7
    
result:
    li a0, 4
    la a1, print_y1
    ecall
    
    li a0, 1
    mv a1, s2
    ecall
    
    li a0, 4
    la a1, print_y2
    ecall
    
    li a0, 1
    mv a1, s3
    ecall
    
    li a0, 4
    la a1, new_line
    ecall
    
    add s4, s2, s3
    
    li a0, 4
    la a1, print_y
    ecall
    
    li a0, 1
    mv a1, s4
    ecall
    
    li a0, 4
    la a1, new_line
    ecall
    
    addi t2, t2, 1
    li t4, 9
    addi t0, t0, 1
    bne t0, t4, loop
    
    li a0, 10
    ecall 
