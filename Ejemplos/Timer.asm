;REALIZAR UN PROGRAMA DE ACCESO QUE INGRESE A UN 
;JUEGO DE TAL MANERA QUE SI LAS CREDENCIALES SEAN INCORRECTAS
;TENGA UN TIEMPO DE INACTIVIDAD DE 5 SEG EN LOS 
;CUALES NO ME PERMITA REALIZAR NINGUNA OPERACION--- RELOJ --- V- 125MS 1m
;Y A LOS 3 INTENTOS ERRONEOS LA CUENTA SEA BANEADA

org 100h
;============================

imprimirCad macro str
    push ax
    push dx
    
    mov ah, 9
    mov dx, offset str
    int 21h
    
    pop dx
    pop ax
endm                                 

;----------------------------                             
    
guardarCad macro str
    local ciclo, fin
    pusha
    
    mov si, 0
 
ciclo:    
    mov ah, 1
    int 21h
    
    cmp al, 13
    je fin:
    
    mov [str+si], al
    inc si
    
    jmp ciclo

fin: 
    popa
endm

;----------------------------

compararCad macro str1 str2  
    local ciclo, iguales, noIguales, verificar1, verificar2, fin

mov si, 0
    
ciclo:    
    
    mov ah, [str1+si]
    mov al, [str2+si]
    
    cmp ah,'$'
    je verificar1
    
    cmp al, '$'
    je verificar2
    
    cmp al, ah
    jne noIguales
    
    inc si
    
    jmp ciclo   
    
iguales:

    mov bx, 1
    jmp fin
        
noIguales:
    
    mov bx, 0
    jmp fin 
    
verificar1:

    cmp al, '$'
    je iguales 
    jmp noIguales
    
verificar2:

    cmp ah, '$'
    je iguales
    jmp noIguales
    
fin:
endm 

;----------------------------

timer macro seg
    local ciclo, fin
           
    push ax
    push dx       
    push cx
    
    mov cx, seg
    
ciclo: 
    
    mov ah, 86h
    mov cx, 00Fh
    mov dx, 4240h
    int 15h 
    
    dec cx
    
    cmp cx, 0
    je fin 
    
    jmp ciclo
    
fin:
    
    pop cx
    pop dx
    pop ax
        
endm

;----------------------------

clear macro
    push ax
    push cx
    push dx
    
    mov ah, 06h        
    mov al, 0                 
    mov cx, 0           
    mov dx, 184Fh       
    int 10h 
    
    pop dx
    pop cx            
    pop ax
    
    
endm    
    
;============================
         
         
inicio:
         
mov cx, 3

ciclo:  

    imprimirCad mensaje1
    
    guardarCad nombre  
        
    imprimirCad saltoLinea 
    
    imprimirCad mensaje2
    
    guardarCad  contrasenia 
    
    compararCad nombre user
    
    cmp bx, 1
    jne error 
    
    compararCad contrasenia password
    
    cmp bx, 1
    jne error   
    
    jmp fin
    
error:                  
    imprimirCad saltoLinea
    imprimirCad mensaje3
    clear 
    imprimirCad mensaje4
    timer 5  
    
    cmp cx, 0
    je baneado
    
    dec cx
    jmp ciclo  
    
baneado:
    
    imprimirCad mensaje5    

fin:
    int 20h


;============================    

mensaje1 db "User: $"
mensaje2 db "Passwors: $"
mensaje3 db "Usuario o contrasenia incorrectas$"
mensaje4 db 10, 13, "Espere unos segundos para volver a intentarlo$"
mensaje5 db "Demasiados intentos, cuenta suspendida$"

user db "Admin$"
password db "Admin$"

nombre db 10 dup('$')
contrasenia db 10 dup('$')   

saltoLinea db 10, 13, '$'
 