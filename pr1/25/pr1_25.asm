; ������� ������ ��21-17/1 ���������� 25

format PE Console

entry start

include 'win32ax.inc'

section '.data' data readable writeable ; ������ ������
    x dd ?
    y dd ?
    z dd ? 
    result_format db 'z = X^3 -2X^2*Y+1 = %d', 0 
    
section '.code' code readable writeable executable ; ������ ����
start:
    invoke printf, 'Enter the value for x: '
    invoke scanf, '%d', x
    invoke printf, 'Enter the value for y: '
    invoke scanf, '%d', y
       
       
       
    mov ebx, [x]  ; ebx = x
    imul ebx, [x] ; ebx = x^2
    imul ebx, [x] ; ebx = x^3
    inc ebx       ; ebx = x^3 + 1
    mov eax, [x]  ; eax = x
    imul eax, [x] ; eax = x^2
    imul eax, [y] ; eax = x^2*y
    imul eax, [y] ; eax = x^2*y
    imul eax, 2   ; eax = 2x^2*y
    neg eax       ; eax = -2x^2*y
    add eax, ebx  ; eax = X^3 -2X^2*Y+1     
    mov [z], eax ; ��������� ��������� � z

    invoke printf, result_format, [z]
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