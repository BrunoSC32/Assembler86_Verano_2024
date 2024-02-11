
;Bruno Salcedo Cadiz
;202000502
;Informatica

org 100h
inicio:

    mov dx, offset setNombre
    call imprimir

nombre:

    call capturar 
    
    
    cmp al, 13
    je verificarN
                
    xor bx, bx
    mov bx, 0                
    call guardar 
    
    jmp nombre

verificarN:

    mov si, offset nombres 
    call tamanio
    
    cmp di, 3
    jb errorNombre 
    
    cmp di, 12
    ja errorNombre
    
    jmp sig1
    
errorNombre:     

    mov dx, offset errorNombres
    call imprimir
    jmp fin
    
sig1:        

    call salto
    

    mov dx, offset setApellido
    call imprimir 
       
apellido:
    call capturar
    
    cmp al, 13
    je verificarA
    
    xor bx, bx
    mov bx, 2
    call guardar
    
    jmp apellido
    
verificarA:

    mov si, offset apellidos
    mov bx, 2
    call tamanio
    
    cmp di, 4
    jb errorApellido 
    
    jmp sig2
    
errorApellido:
    
    mov dx, offset errorApellidos
    call imprimir
    jmp fin    

sig2:

    call salto

    mov dx, offset setCI
    call imprimir

ci:
    call capturar
    
    cmp al, 13
    je verificarCI
    
    xor bx,bx
    mov bx, 4
    call guardar
    
    jmp CI
    
verificarCI:

    mov si, offset cis
    mov bx, 4
    call tamanio
    
    cmp di, 7
    jne errorCI
 
    jmp sig3
    
errorCI:
    
    mov dx, offset errorCIs 
    call imprimir
    jmp fin     
    
sig3: 
    call salto

    mov dx, offset setCelular
    call imprimir

celular:
    call capturar
    
    cmp al, 13
    je verificarCel
    
    xor bx, bx
    mov bx, 6
    call guardar
    
    jmp celular
    
verificarCel:

    mov bh, [celulars]
    sub bh, 30h
    cmp bh, 7
    je sig4
    
    cmp bh, 4
    je sig4
    
    cmp bh, 3
    je sig4
 
    jmp errorCelular
    
errorCelular:

    mov dx, offset errorCelulars
    call imprimir
    jmp fin
        
sig4:
    call salto

    mov dx, offset setPais
    call imprimir   

pais:
    call capturar
    
    cmp al, 13
    je verificarPais
    
    xor bx, bx
    mov bx, 8
    call guardar
    
    jmp pais
    
verificarPais: 
    
    mov bl, [paises]
    mov bh, [paises + 1]
    
    cmp bl, 'b'
    je confirmar
    
    cmp bl, 'B'
    je confirmar
     
    jmp errorPais
     
confirmar: 

    cmp bh, 'o'
    je sig5
    
    jmp errorPais
    
errorPais:
    mov dx, offset errorPaises
    call imprimir
    jmp fin    

sig5:

    call salto

    mov dx, offset setCorreo
    call imprimir

correo:
    call capturar
    
    cmp al, 13
    je verificarCorreo
    
    xor bx, bx
    mov bx, 10
    call guardar
    
    jmp correo
    
verificarCorreo:       
                          
    call recorrerCorreos
                 
    cmp bl, '@'
    jne errorCorreo
    jmp sig6
    
errorCorreo:                     
    mov dx, offset errorCorreos
    call imprimir
    jmp fin
    
sig6:                  
    call salto

    mov dx, offset setPassword
    call imprimir
    
password:  
    call capturarPassword
    
    cmp cl, 13
    je verificarPassword
    
    xor bx, bx
    mov bx, 12
    call guardarPassword
    
    jmp password
    
verificarPassword:
    
    call recorrerPassword
    
    cmp bl, 'A'
    jae fin
    
    cmp bl, 'Z'
    jbe fin
    
    cmp bl, 'A'
    jae fin
    
    cmp bl, 'Z'
    jbe fin
    
    jmp errorPassword
    
errorPassword:
    mov dx, offset errorPassword
    call imprimir
    jmp fin
        

fin: int 20h
 
;************************* 

indices dw offset nombres, offset apellidos, offset cis, offset celulars, offset paises, offset correos, offset passwords 
 
nombres db 20 DUP ('$') 
apellidos db 20 DUP ('$')
cis db 20 DUP ('$')
celulars db 20 DUP ('$') 
paises db 20 DUP ('$')
correos db 20 DUP ('$') 
passwords db 20 DUP ('$')

setNombre db "Ingrese su nombre: $"
setApellido db "Ingrese su apellido: $"
setCI db "Ingrese su ci: $"
setCelular db "Ingrese su celular: $"
setPais db "Ingrese su Pais: $"
setCorreo db "Ingrese su correo electronico: $"
setPassword db "Ingrese su password: $"

errorNombres db "Nombre debe tener menos de 12 caracteres y mas de 2 $"
errorApellidos db "Apellido debe tener mas de 3 caracteres $" 
errorCIs db "El ci boliviano contiene 7 numeros, su ci es incorrecto $"
errorCelulars db "El numero que introdujo no corresponde con uno boliviano $"
errorPaises db "La creacion de cuenta esta solo disponible parala region de Bolivia $"
errorCorreos db "Correo invalido                      $" 
errorPasswords db "Su contrasenia debe contener por lo menos una mayuscula y numero $"

;*************************

capturar proc
    mov ah, 1
    int 21h
    ret
capturar endp    

;-------------------------  

guardar proc
    
    mov si, offset indices
    add si, bx
    mov di, [si]
    mov [di], al
    inc di
    mov [si], di
    ret
guardar endp 

;-------------------------  

imprimir proc
    mov ah, 9
    int 21h
    ret
imprimir endp 

;------------------------- 

salto proc   
    xor dx, dx
        
    mov ah, 2
    mov dl, 13
    int 21h 
    
    mov dl, 10 
    int 21h
    
    ret
salto endp 

;------------------------- 

tamanio proc
    mov di, [indices + bx]
    sub di, si       
    ret
tamanio endp 

;------------------------- 

recorrerCorreos proc
    
    mov cx, [indices + 10]
    sub cx, offset correos
    mov si, 0
     
cicloCorreos:
    
    mov bl, [correos + si]
    
    cmp bl, '@'
    je finRecorrerCorreos
         
    inc si
    
    loop cicloCorreos
 
finRecorrerCorreos:    
    ret     
    
recorrerCorreos endp 

;------------------------- 

recorrerPassword proc
    mov cx, [indices + 12]
    sub cx, offset passwords
    mov si, 0
     
cicloPassword:
    
    mov bl, [passwords + si]
    
    cmp bl, 'A'
    jae finRecorrerPassword
    
    cmp bl, 'Z'
    jbe finRecorrerPassword
    
    cmp bl, '0'
    jae finRecorrerPassword
    
    cmp bl, '9'
    jbe finRecorrerPassword
         
    inc si
    
    loop cicloPassword
 
finRecorrerPassword:    
    ret     
    
recorrerPassword endp

;------------------------- 

capturarPassword proc 
    mov ah, 8
    int 21h
    mov cl, al
    cmp cl, 13
    je finpassword
    mov ah, 2
    mov dl, 2Ah
    int 21h
    
finpassword:    
    ret
capturarPassword endp

;------------------------- 

guardarPassword proc
    
    mov si, offset indices
    add si, bx
    mov di, [si]
    mov [di], cl
    inc di
    mov [si], di
    ret
guardarPassword endp 