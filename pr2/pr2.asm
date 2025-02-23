; ������� ������ ��21-17/1 ������� 24

format PE console

entry start

include 'win32a.inc'

section '.data' data readable writeable
  resStr db 'y = %0.2f', 13, 10, 0
  enterXStr db 'enter X: ', 0
  enterAStr db 'enter A: ', 0
  spaceStr db ' %f', 0 
  
  y1Str db 'y1 = %0.2f', 13, 10, 0
  y2Str db 'y2 = %0.2f', 13, 10, 0
  counterStr db 'counter: %0.2f', 13, 10, 0
  xStr db 'x: %0.2f', 13, 10, 0
  aStr db 'a: %0.2f', 13, 10, 0
  
  X dd 0.0
  A dd 0.0 
  y dd 0.0
  y1 dd 0.0
  y2 dd 0.0
  two dd 2.0
  three dd 3.0
  nine dd 9.0
  counter dd 0.0  
    
  NULL = 0

section '.code' code readable executable

start:
    
     
    push dword enterAStr
    call [printf]
    add esp, 4

    ; ���� ����� A 
    push A
    push dword spaceStr
    call [scanf]
    add esp, 8
    
    push dword enterXStr
    call [printf]
    add esp, 4

    ; ���� ����� X   
    push X
    push dword spaceStr
    call [scanf]
    add esp, 8
    
    mov ecx, 0
    
iter_loop:
     
    finit

    push ecx
     
     
    fld dword [three]
    fld dword [X]
    fprem
    fld dword [two]
     
    fcomip st0, st1
     
    
    jne else1
    fld dword [A]
    fmul dword [X]
    fstp dword [y1]
    jmp end_if1
    
else1: 
    fld dword [nine]
    fstp dword [y1]
    
end_if1:  
    fld dword [X]
    fld dword [A]
    fcomip st0, st1
    
    jbe else2
    fld dword [A]
    fsub dword [X]
    fstp dword [y2]
    jmp after_calculation

else2:
    fld dword [two]
    fadd dword [A]

    fstp dword [y2]


after_calculation:
    ;call [getch]
    
    fld dword [y1]    ; ��������� ��������� � ���� FPU
    sub esp, 8            ; ������� ����� ��� ���������� �������� �������� �� �����
    fstp qword [esp]      ; ��������� ��������� �� ��������� ����� �� �����
    push y1Str           ; ��������� ������ ������ � ����
    call [printf]           ; ������� ������� printf
    add esp, 12           ; �������� ����
    
    fld dword [y2]    ; ��������� ��������� � ���� FPU
    sub esp, 8            ; ������� ����� ��� ���������� �������� �������� �� �����
    fstp qword [esp]      ; ��������� ��������� �� ��������� ����� �� �����
    push y2Str           ; ��������� ������ ������ � ����
    call [printf]           ; ������� ������� printf
    add esp, 12           ; �������� ����
    
    fld dword [y1]
    fmul dword [y2]
    fstp dword [y]
    
    fld dword [y]    ; ��������� ��������� � ���� FPU
    sub esp, 8            ; ������� ����� ��� ���������� �������� �������� �� �����
    fstp qword [esp]      ; ��������� ��������� �� ��������� ����� �� �����
    push resStr           ; ��������� ������ ������ � ����
    call [printf]           ; ������� ������� printf
    add esp, 12           ; �������� ����
    
    
    fld1
    fadd dword [X]
    fstp dword [X]
    
    pop ecx
    inc ecx
    cmp ecx, 10
    jl iter_loop
    
    jmp finish  
   
  finish:
    call [getch]
    push NULL
    call [ExitProcess]

section '.idata' import data readable
  library kernel, 'kernel32.dll', \
    msvcrt, 'msvcrt.dll'
    
  import kernel, \
    ExitProcess, 'ExitProcess'
    
  import msvcrt, \
    printf, 'printf', \
    getch, '_getch', \
    scanf, 'scanf' 