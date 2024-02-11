
;IMPRESION DE UN NUMERO DE 8 BITS EN HEXADECIMAL.

org 100h

MOV DL, 255 ;NUMERO  
MOV CX, 0
MOV BL, DL ;respaldo del numero
    
nibble_alto:

    AND DL, 0F0h
    SHR DL, 4
    JMP imprimir

nibble_bajo:
    
    AND BL, 0Fh
    MOV DL, BL
    INC CX
    JMP imprimir

imprimir:
    
    CMP CX, 2
    JE	fin
    CMP DL, 9
    JA	usar_letras
    ADD DL, '0'
    JMP lanzar_interrupcion
    
usar_letras:
    
    SUB DL, 10
    ADD DL, 'A'
	
lanzar_interrupcion:
      
    MOV AH, 02h
    INT 21h
    JMP nibble_bajo 
    
fin:	
    
    INT 20h