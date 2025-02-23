; ������� ������ ��21-17/1 ������� 24 ������� 1

format PE Console
entry start
include 'win32a.inc'

section '.data' data readable writeable
	rows dd 0
    columns dd 0
    row dd 0
    column dd 0
    maxSize dd 100
    maxSum dd 0
    sum dd 0
    maxIndex dd 0
    curIndex dd 0
    matrix rb 400
    inputFormat db "%5d", 0
    outputFormat db "%d ", 0
    newline db 10, 0 
    errorMessage db "Input error", 0
    primeErrorMessage db "Element is not Prime error", 0
    matrixMessage db "Matrix:", 10, 0
    promptRows db "Enter number of rows: ", 0
    promptColumns db "Enter number of columns: ", 0
    promptElement db "Enter element at row %d, column %d: ", 0
    maxSumMessage db "Maximum sum of elements: %d", 10, 0
    maxRowMessage db "Row with the maximum sum of elements: ", 0

section '.code' code readable writeable executable
start:
     call inputMatrix

inputMatrix:
    invoke printf, promptRows
    invoke scanf, inputFormat, rows
    cmp [rows], 0
    jbe error
    
    invoke printf, promptColumns
    invoke scanf, inputFormat, columns  
    cmp [columns], 0
    jbe error
    
    mov eax, [rows]
    imul eax, [columns]
    cmp eax, [maxSize]
    jg error
    
    mov esi, matrix
    mov [row], 1
    jmp outerLoop
    
outerLoop:
    mov [column], 1
    jmp innerLoop
innerLoop:
    invoke printf, promptElement, [row], [column]
    invoke scanf, inputFormat, esi
    jmp checkPrime
    
checkPrime:
  cmp dword [esi], 1
  jbe primeError
  cmp dword [esi], 2
  je continueInput
  mov ebx, 2
  jmp divideLoop
    
divideLoop:
    xor edx, edx
    mov eax, dword [esi]
    idiv ebx 
    cmp edx, 0 
    je primeError
    inc ebx         
    cmp ebx, dword [esi] 
    jb divideLoop
    jmp continueInput
    
continueInput:
    add esi, 4 
    inc [column]
    mov eax, [column]
    cmp eax, [columns]
    jbe innerLoop
    
    inc [row]
    mov eax, [row]
    cmp eax, [rows]
    jbe outerLoop
    
    mov esi, matrix
    mov [row], 1
    invoke printf, matrixMessage
    jmp printLoop 
    
printLoop:
    mov [column], 1
    jmp printLoopInner
    
printLoopInner:
    invoke printf, outputFormat, dword [esi]
    add esi, 4
    inc [column]
    mov eax, [column]
    cmp eax, [columns]
    jbe printLoopInner
    invoke printf, newline
    
    inc [row]
    mov eax, [row]
    cmp eax, [rows]
    jbe printLoop

    mov esi, matrix
    mov [row], 1
    jmp sumLoop
    
sumLoop:
    mov [column], 1
    mov [curIndex], esi
    mov [sum], 0
    jmp sumLoopInner
    
sumLoopInner:
    mov eax, [sum]
    add eax, dword [esi]
    mov [sum], eax
    add esi, 4
    inc [column]
    mov eax, [column]
    cmp eax, [columns]
    jbe sumLoopInner
    mov eax, [sum]
    cmp eax, [maxSum]
    jg updateSum
    jmp incRow
    
updateSum:
  mov eax, [sum]
  mov [maxSum], eax
  mov eax, [curIndex]
  mov [maxIndex], eax
  jmp incRow

incRow:
  inc [row]
  mov eax, [row]
  cmp eax, [rows]
  jbe sumLoop
  invoke printf, maxRowMessage
  mov [column], 1
  mov esi, [maxIndex] 
  jmp printResult
  
printResult:
  invoke printf, outputFormat, dword [esi]
  add esi, 4
  inc [column]
  mov eax, [column]
  cmp eax, [columns]
  jbe printResult
  invoke printf, newline
  invoke printf, maxSumMessage, [maxSum]
  jmp exit  
    
error:
  invoke printf, errorMessage
  jmp exit
  
primeError:
  invoke printf, primeErrorMessage
  jmp exit
     
exit:
  invoke getch
  invoke ExitProcess, 0

section '.idata' data import readable
    library kernel, 'kernel32.dll',\
            msvcrt, 'msvcrt.dll'

import kernel,\
            ExitProcess, 'ExitProcess'

import msvcrt,\
            printf, 'printf',\
            getch, '_getch',\
            scanf, 'scanf',\
            atoi, 'atoi',\
            strcat, 'strcat',\
            sprintf, 'sprintf'
 