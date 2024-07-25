.global start

.data
	filename: .asciz "input.txt" 
	showDiffRows: .asciz "Количество различных строк: "
	showDiffCols: .asciz "Количество различных столбцов: " 
	newLine: .asciz "\n"
	rows: .word 0
	cols: .word 0
	buffer: .word 0
	trash: .word 0
	matrix: .word 0:100
	space: .asciz " "

.text
start:
	la a0, filename
    	li a1, 0
    	li a7, 1024
    	ecall
    	mv s0, a0
    	li t0, -1
	bne s0, t0, readRowsCols
	j error
	
readRowsCols:
	li s3, 1
	li s2, 1
	li s1, 0
	call readNumberFromFile
	mul s1, s1, s2
	la t0, rows
    	sw s1, 0(t0) 
    	
	li s3, 1
	li s2, 1
	li s1, 0
	call readNumberFromFile
	mul s1, s1, s2
	la t0, cols
    	sw s1, 0(t0) 
    	
    	lw a0, rows
    	li a7, 1
        ecall
        
        la a0, space
    	li a7, 4
        ecall
        
        lw a0, cols
    	li a7, 1
        ecall
        la a0, newLine
    	li a7, 4
        ecall
        
	lw t0, rows
	mul, s5, s1, t0
	li t3, 0
	la s6, matrix
	j readRows
	
readRows:
    	li t4, 0 
    	j readCols
readCols:
	li s3, 1
	li s2, 1
	li s1, 0
	call readNumberFromFile
	mul s1, s1, s2
	sw s1, 0(s6)
	addi s6, s6, 4
	addi t4, t4, 1
	lw t0, cols
	blt t4, t0, readCols
	addi t3, t3, 1
	lw t0, rows
    	blt t3, t0, readRows
    	
    	li t3, 0
    	la s6, matrix
	
	mv a0, s0
   	li a7, 57
    	ecall
	j printRows
	
readNumberFromFile:
	mv a0, s0
    	la a1, buffer
    	li a2, 1
    	li a7,  63
    	ecall
    	lw t0, buffer
    	li t1, 45
    	beq t0, t1, flagNeg
    	blt t0, t1, outReading
    	li t1, 10
    	li t2, 48
    	sub t0, t0, t2
    	mul s1, s1, s3
    	add s1, s1, t0
    	mul s3, s3, t1
    	j readNumberFromFile
    	
outReading:
	ret
	 	
flagNeg:
	li s2, -1
	j readNumberFromFile
	
printRows:
    	li t4, 0
    	j  printCols
printCols:
	lw a0, 0(s6)
        li a7, 1
        ecall
        
        la a0, space
        li a7, 4
        ecall
         
	addi s6, s6, 4
	addi t4, t4, 1
	lw t0, cols
	blt t4, t0, printCols
	addi t3, t3, 1 
	la a0, newLine
        li a7, 4
        ecall
        lw t0, rows
    	blt t3, t0, printRows
    	
    	mv s5, zero
    	mv t4, zero
    	mv t3, zero
    	mv t6, zero
    	li s1, 0
    	lw t0, cols
    	li t4, 1
    	bne t0, t4, countDiffRows
    	lw t0, rows
    	mv s5, t0
    	j printResultRows
    	
countDiffRows:
	lw t0, rows
	beq s1, t0, printResultRows
	li s7, 1
	li t1, 0
	li t3, 0
    	j findDifferentRows
    	
findDifferentRows:
	lw t0, cols
	li t4, 4
	mul t2, s1, t4
	mul t2, t2, t0
	add t2, t2, t1
	la s6, matrix
	add s6, s6, t2
	lw s2, 0(s6)
	mv t5, t2
	j findDifferentRowsInner
	
findDifferentRowsInner:
	la s6, matrix
	addi t5, t5, 4
	add s6, s6, t5
	lw s3, 0(s6)
	beq s3, s2, duplicateRows
	lw t0, cols
    	li s10, 4
    	mul t4, s1, s10
    	mul t4, t4, t0
    	li s10, 1
    	sub t0, t0, s10
    	mv t6, t5
    	sub t6, t6, t4
    	li t4, 4
    	div t6, t6, t4
    	bne t0, t6, findDifferentRowsInner
    	addi t1, t1, 4
    	div t6, t1, t4
    	bne t0, t6, findDifferentRows
    	bne s7, zero, incCounterRows
    	addi s1, s1, 1
    	j countDiffRows		
 	
duplicateRows:
	mv s7, zero
	lw t0, cols
    	li s10, 4
    	mul t4, s1, s10
    	mul t4, t4, t0
    	li s10, 1
    	sub t0, t0, s10
    	mv t6, t5
    	sub t6, t6, t4
    	li t4, 4
    	div t6, t6, t4
    	bne t0, t6, findDifferentRowsInner
    	addi t1, t1, 4
    	div t6, t1, t4
    	bne t0, t6, findDifferentRows
    	bne s7, zero, incCounterRows
    	addi s1, s1, 1
    	j countDiffRows	
	
incCounterRows:
	addi s5, s5, 1
	addi s1, s1, 1
    	j countDiffRows	  	

printResultRows:
	la a0, showDiffRows
        li a7, 4
        ecall
        
        mv a0, s5
        li a7, 1
        ecall
        
        la a0, newLine
        li a7, 4
        ecall
        
       	mv s5, zero
    	mv t4, zero
    	mv t3, zero
    	mv t6, zero
    	li s1, 0
    	lw t0, rows
    	li t4, 1
    	bne t0, t4, countDiffCols
    	lw t0, cols
    	mv s5, t0
    	j printResultCols
            
countDiffCols:
	lw t0, cols
    	mv t1, s1
    	li t4, 4
    	div t1, t1, t4
	beq t1, t0, printResultCols
	li s7, 1
	li t1, 0
	li t3, 0
    	j findDifferentCols
    	
findDifferentCols:
	lw t0, cols
	li t4, 4
	mul t2, t1, t4
	mul t2, t2, t0
	add t2, t2, s1
	la s6, matrix
	add s6, s6, t2
	lw s2, 0(s6)
	mv t5, t2
	j findDifferentColsInner
	
findDifferentColsInner:
	la s6, matrix
	lw t0, cols
    	li t4, 4
	mul t0, t0, t4
	add t5, t5, t0
	add s6, s6, t5
	lw s3, 0(s6)
	beq s3, s2, duplicateCols
	lw t0, rows
    	li s10, 1
    	sub t0, t0, s10
    	
    	mv t6, t5
    	sub t6, t6, s1
    	li t4, 4
    	div t6, t6, t4
    	lw t4, cols
    	div t6, t6, t4
    	bne t0, t6, findDifferentColsInner
    	addi t1, t1, 1
    	lw t0, rows
    	li s10, 1
    	sub t0, t0, s10
    	bne t0, t1, findDifferentCols
    	bne s7, zero, incCounterCols
    	addi s1, s1, 4
    	j countDiffCols		
 	
duplicateCols:
	mv s7, zero
	lw t0, rows
    	li s10, 1
    	sub t0, t0, s10
    	mv t6, t5
    	sub t6, t6, s1
    	li t4, 4
    	div t6, t6, t4
    	lw t4, cols
    	div t6, t6, t4
    	bne t0, t6, findDifferentColsInner
    	addi t1, t1, 1
    	lw t0, rows
    	li s10, 1
    	sub t0, t0, s10
    	bne t0, t1, findDifferentCols
    	bne s7, zero, incCounterCols
    	addi s1, s1, 4
    	j countDiffCols	
	
incCounterCols:
	addi s5, s5, 1
	addi s1, s1, 4
    	j countDiffCols		   	

printResultCols:
	la a0, showDiffCols
        li a7, 4
        ecall
        
        mv a0, s5
        li a7, 1
        ecall
        
        la a0, newLine
        li a7, 4
        ecall
        j exit	
			
error:
	li a0, -1
	li a7, 93
	ecall
	
exit:
	li a7, 8
	ecall	
	li a7, 10
	ecall
