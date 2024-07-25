; ������� ������ ��21-17/1 ���������� 26

format PE Console

entry start

include 'win32ax.inc'

section '.data' data readable writeable ; ������ ������
    x dd ?
    y dd ?
    z dd ? 
    result_format db 'z = -3X + Y^2 + 1 = %d', 0 
    
section '.code' code readable writeable executable ; ������ ����
start:
    invoke printf, 'Enter the value for x: '
    invoke scanf, '%d', x
    invoke printf, 'Enter the value for y: '
    invoke scanf, '%d', y
       
       
       
    mov ebx, [x]  ; ebx = x
    imul ebx, 3   ; ebx = 3x
    neg ebx       ; ebx = -3x
    inc ebx       ; ebx = -3x + 1
    mov eax, [y]  ; eax = y
    imul eax, [y] ; eax = y^2
    add eax, ebx  ; eax = -3X + Y^2 + 1      
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