; ������� ������ ��21-17/1 ���������� 27

format PE Console

entry start

include 'win32ax.inc'

section '.data' data readable writeable
    x dd ?
    y dd ?
    z dd ? 
    result_format db 'z = -(X/Y +1)/Y^2 = %d %d/%d', 0 
    
section '.code' code readable writeable executable ; ������ ����
start:
    invoke printf, 'Enter the value for x: '
    invoke scanf, '%d', x
    invoke printf, 'Enter the value for y: '
    invoke scanf, '%d', y
       
    
    mov ecx, [y]  ; ecx = y        
    mov eax, [x]  ; eax = x
    cdq
    idiv ecx      ; eax = x/y
    inc eax       ; eax = x/y + 1
    mov ebx, [y]  ; eax = y
    imul ebx, [y] ; eax = y^2
    neg eax       ; eax = - x/y - 1                                                         
    cdq
    idiv ebx      ; eax = -(X/Y +1)/Y^2            
    mov [z], eax ; ��������� ��������� � z


    invoke printf, result_format, [z], edx, ebx
    invoke getch
    invoke ExitProcess, 0


section '.idata' import data readable ; ������ �������
    library kernel32, 'kernel32.dll',\
            msvcrt, 'msvcrt.dll'

    import kernel32, \
        ExitProcess, 'ExitProcess'

    import msvcrt,\
        printf, 'printf',\
        getch, '_getch',\
        scanf, 'scanf' 