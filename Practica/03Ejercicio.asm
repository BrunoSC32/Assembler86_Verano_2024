
;Bruno Salcedo Cadiz
;202000502
;Informatica

org 100h
;=================================

capturar macro
    
    mov ah, 1
    int 21h
    mov ah, 0
    
endm

;---------------------------------

imprimirCadena macro str
    push ax
    push dx
        
    mov ah, 9
    mov dx, offset str
    int 21h
    
    pop dx 
    pop ax
    
endm

;---------------------------------

imprimirChar macro char
    push ax
    push dx
        
    mov ah, 2
    mov dl, char
    int 21h
    
    pop dx
    pop ax
    
endm


;---------------------------------

digitosHex macro
    local cicloDigitos, convertirLetra, continuar, primerDigito, finDigitos

cicloDigitos:    
    
   capturar
   
   cmp al, 13
   je finDigitos
   
   
   cmp al,'9'
   jbe continuar
   
convertirLetra:

    call convertirHex   
    
continuar: 
                                   
    sub al, '0'  
    
    cmp bx, 0
    je primerDigito
    
    xchg bx, ax
    
    mov cx, 16
    mul cx
    
    add ax, bx
    
    xchg ax, bx
    
    jmp cicloDigitos
    
primerDigito:

    mov bx, ax
    
    jmp cicloDigitos
    
finDigitos:

nop
endm 

;---------------------------------

operacion macro 
    
    cmp al, 2Ah
    je multiplicacion
    
    cmp al, 2Bh
    je suma
    
    cmp al, 2Dh
    je resta
    
    cmp al, 2Fh
    je division
    
multiplicacion:

    pop ax 
    mul bx
    
    mov bx, ax
    jmp finOperacion

suma: 
    pop ax
    add bx, ax 
    
    jmp finOperacion

resta:
    pop ax
    
    cmp bx, ax
    
    ja restabx
    
    xchg ax, bx
    
restabx:
    
    sub bx, ax 
    
    jmp finOperacion
    
    
division:

    pop ax
    
    div bx  
    
    mov bx, ax

finOperacion:                                                   
endm 

;--------------------------------------------

 
convertirBase macro num, base
    local ciclo, sig1, letras, finMacro
    push ax
    push bx
    push cx
    
    mov ax, num
    mov bx, base
    mov cx, 0
    
ciclo:
    cmp ax, 0
    je sig1
    div bx
    push dx
    
    mov dx, 0
    inc cx
    jmp ciclo
    
sig1:
    mov ah, 2
    cmp cx, 0
    je finMacro
    
    pop dx
    dec cx
    
    cmp dl, 9
    ja letras
    
    add dl, 30h
    int 21h
    
    jmp sig1
    
letras:
    sub dl, 10
    add dl, 'A'
    int 21h
    jmp sig1
    
finMacro:
    pop ax
    pop bx
    pop cx
    
endm
                        
;=================================                                 
inicio: 

    imprimirCadena mensaje1 
    
    digitosHex
      
    
    push bx
    
    imprimirCadena saltoLinea
    
    imprimirCadena mensaje2   
    
    mov bx, 0
    
    digitosHex
    
    push bx
    
    imprimirCadena saltoLinea
    
    imprimirCadena mensaje3
    
    capturar
    
    pop bx
    
    operacion
    
    mov [resul], bx 
    
    imprimirCadena saltoLinea
    
    imprimirCadena mensaje4
    
    convertirBase bx, 16 
    
    imprimirCadena saltoLinea
    
    imprimirCadena mensaje4
    
    mov bx, [resul]
    
    xor dx, dx
    
    convertirBase bx, 2 
    

fin:
    int 20h
    
    
;=================================

convertirHex proc
    
    cmp al, 'A'
    je A
    cmp al, 'B'
    je B
    cmp al, 'C'
    je C
    cmp al, 'D'
    je D
    cmp al, 'E'
    je E
    cmp al, 'F'
    je F
    
A:
    mov al, 58
    jmp finHex
B:
    mov al, 59
    jmp finHex
C:
    mov al, 60
    jmp finHex
D:
    mov al, 61
    jmp finHex
E:
    mov al, 62
    jmp finHex
F:
    mov al, 63
    jmp finHex
    
finHex:
ret
endp convertirHex                               

;=================================

mensaje1 db 'Ingrese el primer numero: $'
mensaje2 db 'Ingrese el segundo numero: $'
mensaje3 db 'Ingrese la operacion(+ - * /): $'
mensaje4 db 'Resultado en hexadecimal: $'  
mensaje5 db 'Resultado en binario: $' 

saltoLinea db 10,13,'$'

resul dw 0