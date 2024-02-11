org 100h                     

;============================

IMPRIMIRCADENA MACRO STR
    PUSH AX
    PUSH DX
    
    MOV AH, 9
    MOV DX, OFFSET STR
    INT 21H
    
    POP DX
    POP AX
ENDM 

TIMER MACRO SEG 
    LOCAL FIN, INICIO    

INICIO:
    
    
    MOV AH, 86H
    MOV CX, 00FH
    MOV DX, 4240H
    INT 15H
    
    DEC SEG
    CMP SEG, 0
    JE FIN
    
    JMP INICIO 
    
FIN:    
ENDM
   
;============================

inicio:  

    IMPRIMIRCADENA SALUDO
    IMPRIMIRCADENA SALTOLINEA
            
    MOV BX, 3        
            
    TIMER BX
    
    IMPRIMIRCADENA CONFIRMAR

fin:
    INT 20H
    
;============================    

SALUDO DB "HOLA, ESPERA 5 SEGUNDOS...$"
CONFIRMAR DB "ACCEDIENDO$"            
SALTOLINEA DB 10, 13, "$"