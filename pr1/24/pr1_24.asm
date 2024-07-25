; ������� ������ ��21-17/1 ���������� 24

format PE Console
entry start

include 'win32ax.inc'

section '.data' data readable writeable ; ������ ������
    x dd ?
    y dd ?
    z dd ? 
    result_format db 'z =  X^3 / (X-Y) = %d %d/%d', 0 
    
section '.code' code readable writeable executable ; ������ ����
start:
    invoke printf, 'Enter the value for x: '
    invoke scanf, '%d', x
	invoke printf, 'Enter the value for y: '
    invoke scanf, '%d', y
       
            
    mov eax, [x]  ; eax = x
    imul eax, [x] ; eax = x^2
    imul eax, [x] ; eax = x^3
    mov ebx, [x]  ; ebx = x 
    sub ebx, [y]  ; ebx = x-y                                                                 
    cdq
    idiv ebx      ; eax = x^3/(x-y)         
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
        scanf, 'scanf'
 