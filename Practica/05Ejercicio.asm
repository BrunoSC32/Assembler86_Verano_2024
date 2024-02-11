
;Bruno Salcedo Cadiz
;202000502
;Informatica

org 100h

;===============================================

nDigitos macro 
    local cicloDigitos, primerDigito, finDigitos
    
  push ax
  push cx  

cicloDigitos:

  mov ah, 1
  int 21h
  
  
  cmp al, 20h
  je finDigitos
  
  
  mov ah, 0
  
  sub al, '0' 
  
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

  jmp cicloDigitos

finDigitos:
    
  pop ax
  pop cx

  nop
endm  

;*********************

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

;******************* 

imprimirCadena macro cadena 
    push ax
    push dx
    
    mov ah, 9
    mov dx, cadena
    int 21h
    
    pop ax
    pop dx
    
endm       

;*******************
                    
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

;******************* 

                    
base macro reg 
    local binario, octal, decimal, hexadecimal, finMacro
    
    cmp reg, 'a'
    je binario
    
    cmp reg, 'b'
    je octal
    
    cmp reg, 'c'
    je decimal
    
    cmp reg, 'd'
    je hexadecimal 
    
binario:    
    convertirBase bx, 2                  
    jmp finMacro
    
octal: 
      
    convertirBase bx, 8
    jmp finMacro
decimal: 
       
    convertirBase bx, 10
    jmp finMacro
hexadecimal: 
   
    convertirBase bx, 16
    jmp finMacro
    
finMacro:
endm    

;*******************

inicio:

    xor ax, ax  
    xor bx, bx 
    
    mov si, offset menu1
    imprimirCadena si                                                 

    nDigitos 
    
    push bx
    xor bx, bx 
    
    nDigitos
    
    call salto 
    
    mov si, offset menu2
    imprimirCadena si
    
    mov ah, 1
    int 21h

    operacion 
    
    call salto
                     
    mov si,offset menu3                     
    imprimirCadena si 
    call salto
    
    mov si,offset menu4                     
    imprimirCadena si 
    call salto
    
    mov si,offset menu5                     
    imprimirCadena si
    call salto
    
    mov si,offset menu6                     
    imprimirCadena si
    call salto   
    
    mov si,offset menu7                     
    imprimirCadena si
    call salto

    mov ah, 8
    int 21h
    
    xor dx, dx
    
    base al 


fin: int 20h 

;-----------------
 
menu1 db "Introduce dos numeros: $"
menu2 db "Selecciona la operacion (+ - * /): $"
menu3 db "Selecciona el sistema numerico: $"
menu4 db "a) binario$"
menu5 db "b) octal$"
menu6 db "c) decimal$"
menu7 db "d) hexadecimal$"
menu8 db "El numero es: $"    


;-----------------

                                   
salto proc
    mov ah, 2
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h
    ret
salto endp    