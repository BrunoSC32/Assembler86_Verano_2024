
;Bruno Salcedo Cadiz
;202000502
;Informatica

org 100h

;==================================

imprimirCadena macro str
    push ax
    push dx
           
    mov dx, offset str       
    mov ah, 9
    int 21h
    
    pop dx
    pop ax
    
endm    
;---------------------------------- 

nDigitos macro  
    local cicloDigitos, primerDigito, finDigitos
    
    
cicloDigitos:

    mov ah, 1
    int 21h
    mov ah, 0
    
    cmp al, 13
    je finDigitos
        
    mov ah, 0
    
    sub al, '0'
    
    add si, ax
    
    cmp bx, 0
    je primerDigito
    
    xchg bx, ax
    
    mov cx, 10
    mul cx
    
    add ax, bx
    
    xchg ax, bx
    
    jmp cicloDigitos
    
primerDigito:
    
    mov bx, ax
    
    jmp cicloDigitos:
    
finDigitos:
            
endm    

;----------------------------------

esPar macro num
    
    mov dx, 0
    
    mov ax, num
    
    mov cx, 2
    
    div cx 
    
    cmp dx, 0
    je par
    
    jmp impar
par:
    mov bx, 1 
    jmp finPar
    
impar:
    mov bx, 0
    
finPar:            
endm 

;----------------------------------
esPrimo macro num
    local cicloPrimo, noPrimo, primo, finPrimo     
    
    
    mov bp, 2

cicloPrimo:  

    mov ax, num
    
    mov cx, bp 
    
    cmp bp, ax
    je primo
    
    div cx
    
    cmp dx, 0
    je noPrimo
    
    xor dx, dx
    
    inc bp
    jmp cicloPrimo
    
noPrimo:

    mov bx, 0
    jmp finPrimo
    
primo: 

    mov bx, 1

finPrimo:
endm      
        
;==================================

inicio:

    mov ax, 0
    mov bx, 0
    mov cx, 0
    mov dx, 0 
    mov si, 0

ciclo:
    
    nDigitos
    
    mov di, bx
    
    esPar si
    
    cmp bx, 1
    je imprimirPar 
    
    esPrimo di
    
    cmp bx, 1
    je imprimirPrimo
    
imprimirPar:
    
    imprimirCadena flecha
    imprimirCadena numeroPar
    imprimirCadena saltoLinea
    mov bx, 0
    mov di, 0
    mov si, 0   
    jmp ciclo 
        
imprimirPrimo:
    
    imprimirCadena flecha
    imprimirCadena numeroPrimo
    imprimirCadena saltoLinea 
    mov bx, 0
    mov di, 0
    mov si, 0
    jmp ciclo  

fin:
    int 20h
    
;==================================


  
    
;==================================  

numeroPar db " la suma es par $"
numeroPrimo db " es primo $" 

flecha db 10, 13
           db "  /\  ", 10, 13
           db "  ||  ", 10, 13, "$"
           
saltoLinea db 10, 13, "$"            