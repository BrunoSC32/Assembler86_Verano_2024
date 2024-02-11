
;IMPRESION DE UN NUMERO DE 16 BITS (0-65535).

org 100h

MOV AX, 1989 ;NUMERO 
MOV DX, 0
MOV CX, 0

dividir:

    MOV  BX, 10  ;se dividira el numero entre 10
    DIV  BX	 ;DX=resto, AX=cociente 
    
    PUSH DX	;se guarda en la pila solo el resto
    INC  CX	;se cuenta los numeros apilados
    
    CMP  AX, 0	;cociente = 0 ?
    JE	 imprimir_pila
    MOV  DX, 0	;el nuevo numero sera solo el cociente
		;por lo tanto se elimina el resto y
		;queda solamente [DX:AX] = [00:AX]
    JMP  dividir

imprimir_pila:
    
    
	DX
    ADD  DL, '0'
    MOV  AH, 02h
    INT  21h
    LOOP imprimir_pila
    
INT 20h