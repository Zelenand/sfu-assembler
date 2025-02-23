; ������� ������ ��21-17/1 ������� 24 �������������� ������

format PE Console

entry start

include 'win32a.inc'

section '.data' data readable writeable

    struct ticket
        destination db 20 dup(0)
        departure db 20 dup(0)
        date db 20 dup(0)
        cost dd 0
    ends
    tickets ticket 'krasnoyarsk','moscow','10.01.2024',100
			ticket 'moscow','krasnoyarsk','11.01.2024',200
			ticket 'spb','moscow','12.01.2024',250
			ticket 'moscow','spb','13.01.2024',300
			ticket 'spb','krasnoyarsk','14.01.2024',350
	structOutput db '%s, %s, %s, %d',10,0
	i dd 0
	sizeOf dd 64
    n dd 5
    size dd 0

    writeFileName db 'in',0
    wMode db 'w',0
    file_d dd 0

section '.code' code readable writeable executable

start:
    mov [ds:i], 0
	loop2:
        ; ������ �������� � ������ ���������
        mov eax, [ds:i]
        imul [ds:sizeOf]
        mov [ds:size], eax

        mov ebx, [ds:size]
        add ebx, tickets.destination
        mov ecx, [ds:size]
        add ecx, tickets.departure
        add eax, tickets.date
        mov edx, [ds:size]
        add edx, tickets.cost

        invoke printf, structOutput, ebx, ecx, eax, [edx]

        inc [ds:i]
        mov edx, [ds:i]
        cmp edx, 5
        jne loop2
    invoke fopen, writeFileName, wMode
    mov [ds:file_d], eax
    mov eax, [ds:n]
    imul [ds:sizeOf]
    mov ecx, 1
    invoke fwrite, tickets, ecx, eax, [ds:file_d]
    invoke fclose, [ds:file_d]


    invoke getch
    invoke ExitProcess, 0

section '.idata' data import readable
  library kernel, 'kernel32.dll',\
        msvcrt, 'msvcrt.dll'
  
  import kernel,\
     ExitProcess, 'ExitProcess'

      
  import msvcrt,\
      printf, 'printf',\
      getch, '_getch', scanf, 'scanf', fopen, 'fopen', fwrite, 'fwrite', fclose, 'fclose' 