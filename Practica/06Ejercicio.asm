
;Bruno Salcedo Cadiz
;202000502
;Informatica

org 100h
;==================================  
imprimirChar macro char    
    push ax
    push dx
    
    mov ah, 2  
    mov dl, 32
    int 21h
    mov dl, char
    int 21h
    mov dl, 32
    int 21h
    
    pop dx
    pop ax
endm
                                   
;----------------------------------                                   

imprimirDigitos macro num
    local cicloDiv, impr, finImpr  
    pusha
    
    mov ax, num
    mov bx, 10 
    mov cx, 0
    mov dx, 0
    
cicloDiv:    
    
    div bx
    
    push dx
    inc cx
    
    mov dx, 0
    
    cmp ax, 0
    je impr
    
    jmp cicloDiv
    
impr:
    
    pop dx
    imprimirNum dl
    
    loop impr    
    
finImpr:
    popa

endm

;----------------------------------

imprimirCadena macro str
    push ax
    push dx    
    
    mov ah, 9
    mov dx, offset str
    int 21h
    
    pop dx
    pop ax
endm 

;----------------------------------

imprimirNum macro num    
    push ax
    push dx
    
    mov ah, 2
    mov dl, num
    add dl, '0'
    int 21h
    
    pop dx
    pop ax
endm

;----------------------------------

capturar macro
    
    mov ah, 1
    int 21h
    mov ah, 0
endm    

;----------------------------------

nDigitos macro 
    local cicloDigitos, primerDigito, finDigitos
             
    mov ax, 0         
    mov bx, 0
    mov cx, 0

cicloDigitos:
    
    capturar
    
    cmp al, 13
    je finDigitos
    
    sub al, '0'
    
    cmp bx, 0
    je primerDigito 
    
    xchg ax, bx
    
    mov cx, 10
    mul cx
    
    add ax, bx
    
    xchg ax, bx
    
    jmp cicloDigitos
    
primerDigito:

    mov bx, ax
    jmp cicloDigitos 
    
finDigitos:
endm

;----------------------------------

burbuja macro
    
    pop ax
    pop bx
    pop cx
    
    cmp ax, bx
    jae verificarB_C
    
    xchg ax, bx
    
verificarB_C:
    
    cmp bx, cx
    jae continuar
    
    xchg bx, cx
    
    cmp ax, bx
    jae continuar
    
    xchg ax, bx

continuar:
    
endm 

;----------------------------------

sumar macro num 

cicloSuma: 
    mov al, [num]       
    
    add al, bl
    
    mov [suma+bx], al
    
    inc bl 
    
    cmp bl, 10
    je finSuma
    
    jmp cicloSuma
    
finSuma:
endm        
    
;----------------------------------

multiplicar macro num
    
cicloMulti:
 
    mov al, [num]       
    
    mul bl
    
    mov [multi+bx], al
    
    inc bl 
    
    cmp bl, 10
    je finMulti
    
    jmp cicloMulti
    
finMulti:
endm 

;----------------------------------


    
    
;==================================

inicio: 
    
    imprimirCadena mensaje1

    nDigitos
    push bx
    
    imprimirCadena saltoLinea
    
    imprimirCadena mensaje2
    
    nDigitos
    push bx
    
    imprimirCadena saltoLinea
    
    imprimirCadena mensaje3 
    
    nDigitos
    push bx
    
    burbuja
    
    mov [num], al
    mov [num + 1], bl
    mov [num + 2], cl
    
    mov bx, 1
    sumar num
    
    mov al, [num+1]
    mov bx, 1
    multiplicar num+2
    
    imprimirCadena saltoLinea 
     
    mov bx, 1
     
tablaSuma:

    imprimirCadena saltoLinea 
    
    imprimirNum [num]
    imprimirChar 43
    imprimirNum bl
    imprimirChar 61 
    mov cl, [suma+bx]
    imprimirDigitos cx
    
    cmp bl, 9
    je paso1
    
    inc bl
    jmp tablaSuma 
    
paso1:

    mov bx, 1 
    imprimirCadena saltoLinea   
    
tablaMulti:
    
    imprimirCadena saltoLinea   
    
    imprimirNum [num+2]
    imprimirChar 42
    imprimirNum bl
    imprimirChar 61 
    mov cl, [multi+bx]
    imprimirDigitos cx
    
    cmp bl, 9
    je fin
    
    inc bl
    jmp tablaMulti        
    
    

fin:
    int 20h
    
;==================================



;==================================

mensaje1 db "Ingrese el primer numero $"
mensaje2 db "Ingrese el segundo numero $"
mensaje3 db "Ingrese el tercer numero $"

suma db 10 dup("$") 
resta db 10 dup("$")
multi db 10 dup("$")

num db 0, 0, 0

saltoLinea db 10, 13, "$"    