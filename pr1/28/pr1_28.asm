; ������� ������ ��21-17/1 ���������� 28

format PE Console

entry start

include 'win32ax.inc'

section '.data' data readable writeable ; ������ ������
    x dd ?
    y dd ?
    z dd ? 
    result_format db 'z = 1+X^2/3Y = %d %d/%d', 0 
    
section '.code' code readable writeable executable ; ������ ����
start:
    invoke printf, 'Enter the value for x: '
    invoke scanf, '%d', x
    invoke printf, 'Enter the value for y: '
    invoke scanf, '%d', y
       
            
    mov ebx, [y]  ; ebx = y
    imul ebx, 3 ; eax = 3y
    mov eax, [x]  ; eax = x
    imul eax, [x] ; eax = x^2                                                                 
    cdq
    idiv ebx      ; eax = X^2/3Y
    inc eax       ; eax = 1+X^2/3Y            
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