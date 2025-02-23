; ������� ������ ��21-17/1 ������� 24 ������� 2

format PE console 4.0

entry start

include 'win32a.inc'

define  stringBuf  512

section '.data' data readable writable
	charPrint         db   '%c', 0
    messegeString         db   'Enter string: ', 10, 0
    inputString       db   stringBuf dup(0)
    longWordOffset   dd   0
    stringLen         dd   0

section '.code' code readable executable

findLongWord:
    cld ; DF (���� �����������) = 0
    mov   ax, ds
    mov   es, ax
    lea   edi, [inputString]
    mov   al, 0
    mov   ecx, stringBuf
    repnz scasb

    ; ����������� ����� ������
    mov   eax, stringBuf
    sub   eax, ecx
    mov   [stringLen], eax    
    mov   ecx, eax
    mov   ebx, ecx ; ������� ������ ����� (������������ �������� ECX)

    mov   edx, 0   ; ����� ����������� �����
    lea   edi, [inputString]
    findWord:
      mov   al,  32 ; ������
      repnz scasb
      
      ; �������� ����� �����
      mov   eax, ebx
      sub   eax, ecx
      dec   eax ; ������� �������� ������  
      cmp   eax, edx ; � ���� ZF
      jle   notSetNewLen ; ������� ���� SF != OF ��� ZF = 1 (a <= b), ���� ������� ����� �� ������ 
      ; ���� ������
      mov   edx, eax ; ����� ������������ ����� �����
      ; ��������� �������� �������� ������������ ������ 
      mov   eax, [stringLen]
      sub   eax, ebx
      mov   [longWordOffset], eax
      notSetNewLen:
      mov   ebx, ecx    
      
      cmp   ecx, 0
      jne   findWord
    ret  

printLongWord:
    cld
    mov   eax, [longWordOffset]
    mov   eax, [longWordOffset]
    lea   esi, [inputString+eax]
    ; ����� �� ����� ������
    mov   eax, [stringLen]
    sub   eax, [longWordOffset]
    mov   ecx, eax
    dec   ecx  ; �� �������� ����� ������ 
    printEachSymbol:
      lodsb ; ��������� ������� ������ � al
      cmp al,  32
      je printEnd ; ���� ������ - ����� �����
      push ecx
      cinvoke printf, charPrint, eax
      pop ecx
      loop printEachSymbol     
    printEnd:
    mov   eax, 10
    cinvoke printf, charPrint, eax  
    ret
    
start:
    
    cinvoke printf, messegeString
    cinvoke gets, inputString
    call    findLongWord
    call    printLongWord
    invoke getch
    invoke ExitProcess, 0

section '.idata' import data readable
 
        library msvcrt,'MSVCRT.DLL',\
                kernel32,'KERNEL32.DLL'
 
        import kernel32,\
            ExitProcess, 'ExitProcess',\
               sleep,'Sleep'
 
        import msvcrt,\
               gets,'gets',\
               printf,'printf', \
               getch, '_getch' 