;capturar caracteres y guardar las mayusculas en 
;un cadena y el resto en otra, imprimir cada array
;en una columna 

;Bruno Salcedo Cadiz
;202000502
;Informatica

org 100h                    

;===========================

capturar macro 
    
    mov ah, 1
    int 21h  
    mov ah, 0
        
endm 

;---------------------------

saltoLinea macro
    pusha
    
    mov ah, 2
    mov dl, 10
    int 21h
    mov dl, 13
    int 21h
    
    popa
endm    
    
;---------------------------

espacio macro
    pusha
    
    mov ah, 2
    mov dl, 32
    int 21h
    
    popa
endm                        

;---------------------------

imprimir macro char
    
    mov ah, 2 
    mov dl, char
    int 21h
    mov ah, 0
    mov dl, 0

endm    
    
;===========================

inicio: 

    mov cx, 0 
    mov si, 0

ciclo:
    
    mov si, 0
    
    capturar
    
    espacio
    
    cmp al, 13
    je imprimirCol 
    
    call comprobarMayus
    
    cmp bl, 1
    je guardarMayuscula
    
    cmp bl, 0
    je guardarCaracter
    
guardarMayuscula:

    call guardarMayus
    jmp ciclo
    
guardarCaracter:
    
    call guardarCarac
    jmp ciclo        
    
imprimirCol:

    saltoLinea    
   
   mov si, [indices]
   mov di, [indices+2]
   dec si
   dec di

cicloImprimir: 

    saltoLinea

    cmp si, -1
    je finSi
    
    mov dl, [mayusculas+si]
    imprimir dl
    dec si
    
finSi:

    cmp di, -1
    je finDi
    
    mov dl, [caracteres+di]
    imprimir dl
    dec di
    
finDi:

    cmp si, -1
    jne cicloImprimir
    cmp di, -1
    jne cicloImprimir
    
    jmp        

fin:
    int 20h
    
;===========================

guardarMayus proc 
    
    mov si, [indices]
    
    mov [mayusculas+si], al
    
    inc si
    
    mov [indices], si
    
    ret
endp guardarMayus        

;---------------------------

guardarCarac proc        
    
    mov si, [indices+2]
    
    mov [caracteres+si], al
    
    inc si
    
    mov [indices+2],si
    
    ret
endp guardarCarac    
    
;---------------------------     
                            
comprobarMayus proc
    
    cmp al, 'A'
    jb noEsMayus
    
    cmp al, 'Z'
    ja  noEsMayus
    
    jmp esMayus
    
noEsMayus:
    
    mov bl, 0 
    
    jmp finMayus
    
esMayus:
    
    mov bl, 1
    
finMayus: 
    
    ret
endp comprobarMayus                                          
                            
;===========================

mayusculas db 100 dup('-')
caracteres db 100 dup('-')

indices dw 0, 0 ;id_mayusculas, id_caracteres    