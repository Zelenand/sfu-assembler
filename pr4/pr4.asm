; ������� ������ ��21-17/1 ������� 24 �������� ���������

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
    tickets ticket ?,?,?,?
			ticket ?,?,?,?
			ticket ?,?,?,?
			ticket ?,?,?,?
			ticket ?,?,?,?
    structOutput db '%s, %s, %s, %d',10,0
    i dd 0
	sizeOf dd 64
    n dd 5

    readFileName db 'in',0
    writeFileName db 'out',0
    wMode db 'w',0
    rMode db 'r',0
    readFile dd 0
    writeFile dd 0
    size dd 0

section '.code' code readable writeable executable

start:
    invoke fopen, readFileName, rMode
    mov [ds:readFile], eax

    mov eax, [ds:n]
    imul [ds:sizeOf]

    mov ecx, 1
    invoke fread, tickets, ecx, eax, [ds:readFile]
    invoke fclose, [ds:readFile]

    mov [ds:i], 0
    loop1:
        mov eax, [ds:i]
        imul [ds:sizeOf]
        mov edx, eax
        add edx, tickets.cost
        push eax
        mov eax, 99
        add eax, [edx]
        mov [edx], eax
        pop eax

        inc [ds:i]
        mov edx, [ds:i]
        cmp edx, 5
        jne loop1

    ; ������ ���������� ���� ��� ������ � ����
    mov eax, [ds:n]
    imul [ds:sizeOf]
    mov ecx, 1
    mov [ds:i], 0
    loop2:
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

    mov eax, [ds:n]
    imul [ds:sizeOf]
    mov ecx, 1
    invoke fopen, writeFileName, wMode
    mov [ds:writeFile], eax
    invoke fwrite, tickets, ecx, eax, [ds:writeFile]
    invoke fclose, [ds:writeFile]

    invoke getch
    invoke ExitProcess, 0

section '.idata' data import readable
  library kernel, 'kernel32.dll',\
        msvcrt, 'msvcrt.dll'
  
  import kernel,\
     ExitProcess, 'ExitProcess'

      
  import msvcrt,\
      printf, 'printf',\
      getch, '_getch', scanf, 'scanf', fopen, 'fopen', fwrite, 'fwrite', fclose, 'fclose', fread, 'fread' 