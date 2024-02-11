
;EL SALTO INCONDICIONAL (JMP) Y
;SALTOS CONDICIONALES (JE,JA,JB)
;APLICADOS A NUMEROS SIN SIGNO 

 
org 100h 

MOV AH, 7 ;numero para evaluar

CMP AH, 5 ;se compara AH con 5

JE  igual ;jump if equal (igual)
JA  mayor ;jump if above (por encima) JAE
JB  menor ;jump if below (por debajo) JBE
; JG JGE -- MAYOR O IGUAL JL JLE --- MENOR O igual (SIGNO)

igual:
	
    MOV AH, 02h        
    MOV DL, 'E'
    INT 21h
    JMP fin ;saltar siempre a fin

mayor:
	
    MOV AH, 02h        
    MOV DL, 'A'
    INT 21h 
    JMP fin ;saltar siempre a fin 
    
menor:	 

    MOV AH, 02h        
    MOV DL, 'B'
    INT 21h
    JMP fin 
    JMP fin ;saltar siempre a fin 
    
fin:

    int 20h ;fin del programa