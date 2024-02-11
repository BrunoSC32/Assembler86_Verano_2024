
;Bruno Salcedo Cadiz
;202000502
;Informatica

org 100h 

;--------------------------------------

imprimirCadena macro str
    push ax
    push dx
        
    mov ah, 9
    mov dx, offset str
    int 21h
    
    pop dx 
    pop ax
    
endm   

;--------------------------------------

imprimirChar macro char
    push ax
    push dx
    
    mov ah, 2
    mov dl, char
    int 21h
    
    pop dx
    pop ax 
endm    
;--------------------------------------  

enter macro 
    push ax
    
    mov ah, 8
    int 21h
    
    pop ax
    
endm   
;--------------------------------------     

inicio:       
        
     enter

ciclo:
    call capturar
    
    cmp al, 13
    je paso1
    
    call numero     
               
    call mayuscula
    
    call minuscula

    call especial 
    
    jmp ciclo
    
paso1:
    
    imprimirCadena saltoLinea 
    
    enter
    
    mov si, 0    

imprimirNum:       

    mov dl,[numeros+si] 
    
    cmp dl, '$'
    je paso2

    imprimirChar dl
    
    inc si
    
    jmp imprimirNum

paso2:

    imprimirCadena saltoLinea 
    
    enter
    
    mov si, 0
             
imprimirMayus:  

    mov dl,[mayus+si] 
    
    cmp dl, '$'
    je paso3

    imprimirChar dl
    
    inc si
    
    jmp imprimirMayus             
             
paso3:

    imprimirCadena saltoLinea 
    
    enter
    
    mov si, 0
    
imprimirMinus:  

    mov dl,[minus+si] 
    
    cmp dl, '$'
    je paso4

    imprimirChar dl
    
    inc si
    
    jmp imprimirMinus 
    
paso4:

    imprimirCadena saltoLinea 
    
    enter
    
    mov si, 0
    
imprimirCarac:  

    mov dl,[especiales+si] 
    
    cmp dl, '$'
    je fin

    imprimirChar dl
    
    inc si
    
    jmp imprimirCarac     
        

fin: int 20h

;********************

numeros db 50 DUP ('$')
mayus db 50 DUP ('$')
minus db 50 DUP ('$')
especiales db 50 DUP ('$') 

indices dw offset numeros,offset mayus, offset minus, offset especiales
;numeros, mayus, minus, especiles

;********************

imprime proc
    mov ah, 2
    mov dl, al
    int 21h
    ret
imprime endp    

;--------------------

capturar proc
    
    mov ah, 1
    int 21h
    ret
    
capturar endp 

;--------------------

numero proc
    
    cmp al, '0'
    jae confirmoN 
    jmp finNumero 
    
confirmoN:
    cmp al, '9'
    jbe guardarNumero
    
finNumero:    
    ret
    
numero endp

;--------------------

mayuscula proc
    cmp al, 'A'
    jae confirmoMa
    jmp finMayus
    
confirmoMa:
    cmp al, 'Z'
    jbe guardarMayus
    
finMayus:
    ret
    
mayuscula endp            

;--------------------

minuscula proc
    cmp al, 'a'
    jae confirmoMi
    jmp finMinus
    
confirmoMi:
    cmp al, 'z'
    jbe guardarMinus
    
finMinus:
    ret
    
minuscula endp            

;--------------------

especial proc
    cmp al, 14
    jae confirmoEsp
    jmp finEsp
    
confirmoEsp:
    cmp al, 47
    jbe guardarEspeciales
    
finEsp:
    ret
    
especial endp  

;--------------------

guardarNumero proc
    mov si, offset indices
    mov di, offset numeros 
    mov di, [si]
    
    mov [di], al
    inc di
    mov [si], di
    ret
guardarNumero endp 

;--------------------

guardarMayus proc
    mov si, offset indices
    mov bx, 2
    add si, bx
    mov di, offset mayus 
    mov di, [si]
    
    mov [di], al
    inc di
    mov [si], di
    ret 
guardarMayus endp

;--------------------  

guardarMinus proc
    mov si, offset indices
    mov bx, 4
    add si, bx
    mov di, offset minus 
    mov di, [si]
    
    mov [di], al
    inc di
    mov [si], di
    ret 
guardarMinus endp

;-------------------- 

guardarEspeciales proc
    mov si, offset indices
    mov bx, 6
    add si, bx
    mov di, offset especiales 
    mov di, [si]
    
    mov [di], al
    inc di
    mov [si], di
    ret 
guardarEspeciales endp 

;--------------------
  
mayor proc 
    mov ax, [indices]
    sub ax, offset numeros
    mov bx, [indices + 2]
    sub bx, offset mayus
    mov cx, [indices + 4]
    sub cx, offset minus
    mov dx, [indices + 6] 
    sub dx, offset especiales
    
    jmp comparar
    
    jmp comparar
    
    jmp comparar
    
    ret
    
mayor endp    
    
;--------------------    
    
comparar proc
    
    cmp ax, bx
    jae noIntercambiar_ax_bx
    xchg ax, bx
    
noIntercambiar_ax_bx:

    cmp bx, cx
    jae noIntercambiar_bx_cx
    xchg bx, cx
    
noIntercambiar_bx_cx:
    
    cmp cx, dx
    jae noIntercambiar_cx_dx
    xchg cx, dx           

noIntercambiar_cx_dx:
   
    ret
comparar endp

;=============================


saltoLinea db 13, 10, '$'