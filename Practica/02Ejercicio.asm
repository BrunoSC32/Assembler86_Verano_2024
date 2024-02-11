;capturar dos fechas (dia, mes, anio) y imprimir la
;diferencia 

;Bruno Salcedo Cadiz
;202000502
;Informatica

org 100h 

;=============================

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

;-------------------------------
  
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

;----------------------------
                              
imprimirCadena macro str
    push ax 
    push dx
    
    mov dx, offset str
    mov ah, 9
    int 21h
    
    pop dx
    pop ax
endm 

;-----------------------------

dosDigitos macro 
    push ax
    push cx
    
    mov ah, 1
    int 21h
    mov ah, 0  
    
    sub al, '0'
    
    mov cl, 10
    
    mul cl
    
    mov bl, al
    
    mov ah, 1
    int 21h
    mov ah, 0 
    
    sub al, '0'
    
    add bl, al 
    
    pop cx
    pop ax

endm

;-----------------------------

impCaracter macro char
    push ax
    push dx
    
    mov ah, 2
    mov dl, char
    int 21h
    
    pop dx
    pop ax
    
endm 

;-----------------------------

acomodarFecha macro
    
    pop ax
    pop bx
    
    shl bx, 7
    
    or bx, ax
    
    pop ax
    
    shl ax, 11
    
    or bx, ax
    
endm 

;-----------------------------

mayorMenor macro a1, a2
    local fin
    
    mov ax, a1
    mov bx, a2
    
    cmp ax, bx
    jae fin
    
    xchg ax, bx
    
    fin:
endm    

;=============================

inicio:  

    mov ax, 0
    mov bx, 0
    mov cx, 0
                           
    imprimirCadena mensaje1 
    
    mov cx, 3 
    mov si, 6
    
capFecha1: 

    
    dosDigitos
    push bx
    
    mov [fecha1+si], bx
    
    impCaracter 45
                  
    sub si, 2
    loop capFecha1     
    
    acomodarFecha  
    
    
    mov [fecha1], bx   
    
    imprimirCadena saltoLinea
    
    imprimirCadena mensaje2
    
    mov bx, 0
    mov ax, 0 
    mov cx, 3 
    mov si, 6
    
capFecha2:

    dosDigitos
    push bx  
    
    mov [fecha2+si], bx
    
    impCaracter 45
    
    sub si, 2
    loop capFecha2
     
    acomodarFecha 
    
    mov [fecha2], bx   
    
compararFechas:

    mov ax, [fecha1+2]
    mov bx, [fecha2+2]    
                      
    mayorMenor ax, bx
    sub ax, bx 
    imprimirCadena saltoLinea
    imprimirCadena mensaje3
     
    imprimirDigitos ax 
    
    mov ax, [fecha1+4]
    mov bx, [fecha2+4]
    
    mayorMenor ax, bx
    sub ax, bx
    imprimirCadena saltoLinea
    imprimirCadena mensaje4
     
    imprimirDigitos ax   
    
    mov ax, [fecha1+6]
    mov bx, [fecha2+6]
    
    mayorMenor ax, bx
    sub ax, bx
    imprimirCadena saltoLinea
    imprimirCadena mensaje5
     
    imprimirDigitos ax
    
  

                       

fin:
    int 20h
    
;=============================

convertirDias proc
    
    dosDigitos
    push ax
    
    
    
ret
endp convertirDias    


;=============================

; acomode, anio, mes, dia
fecha1 dw 0, 0, 0, 0
fecha2 dw 0, 0, 0, 0

mensaje1 db 'Ingrese la primera fecha: $'
mensaje2 db 'Ingrese la segunda fecha: $' 
mensaje3 db 'Anios de diferencia: $'
mensaje4 db 'Meses de diferencia: $'
mensaje5 db 'Dias de diferencia: $'

saltoLinea db 10, 13, '$'    