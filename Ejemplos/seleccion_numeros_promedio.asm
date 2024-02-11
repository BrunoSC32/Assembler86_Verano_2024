
; REALIZAR UN PROGRAMA QUE MUESTRE SU NOMBRE COMPLETO Y AL FINALIZAR LA CADENA SU EDAD SI ES PAR Y AL INICIO SI ES IMPAR


;PROGRAMA PARA INGRESAR SOLO NUMEROS Y
;CUANDO SE PRESIONE CERO, PROMEDIAR LOS
;NUMEROS INGRESADOS. SE DEBERAN OMITIR
;CARACTERES FUERA DEL RANGO 0-9. 

org 100h 

;########################## 
;##					 	 ##
;##		 MACROS 		 ##
;##					 	 ##
;##########################


;IMPRIME CARACTER
PrintChar MACRO char
    
    PUSH AX
    PUSH DX

    MOV AH, 02h ;IMPRIMIR CARACTER
    MOV DL, char
    INT 21h
    
    POP DX
    POP AX
    
ENDM

;IMPRIME VARIABLE-STRING
PrintStr MACRO str
    
    PUSH AX
    PUSH DX
    
    MOV AH, 09h ;IMPRIMIR STRING
    MOV DX, OFFSET str
    INT 21h   
    
    POP DX
    POP AX
    
ENDM 

;################################## 
;##					 			 ##
;##	    PROGRAMA PRINCIPAL		 ##
;##					 			 ##
;##################################

MOV BX, 0
MOV CX, 0

PrintStr txtPregunta  

lectura:

    CALL InputCharNotEcho ; se guarda en AL
    
    CMP AL, '0'
    JE	cero	; AL = 0
    JB	menor0	; AL < 0
    CMP AL, '9'
    JA	mayor9	; AL > 9
    
    PrintChar AL
    MOV  AH,0
    SUB  AX, '0' ; ASCII NUM. - '0'
    PUSH AX	 ;se guarda en la pila el numero
    INC  CX	 ;contamos cuantos numeros hay
    JMP lectura 
    
cero: 

    PrintChar AL
    PrintStr txtCalculos1
    PrintStr txtCalculos2
    PrintStr txtPromedio
    MOV AX, 0  ;se coloca cero en AX
    MOV DX, CX ;se respalda el valor de CX
    JMP calcula_promedio

menor0:
mayor9:

    JMP lectura

calcula_promedio:
    
    POP BX	;se sacan de la pila uno a uno los numeros
    ADD AX, BX	;se van sumando y almacenan en AX
    
    LOOP calcula_promedio
    
    MOV BX, AX	;se respalda la suma total en BX
    DIV DL	;se divide AX/DL = promedio
    
fin:  
	   
    INT 20h ;FIN DEL PROGRAMA  

;################################## 
;##					 			 ##
;##	      PROCEDIMIENTOS		 ##
;##					 			 ##
;##################################

;LEE CARACTER SIN ECO (SE GUARDA EN AL)
InputCharNotEcho PROC
    
    MOV AH, 08h
    INT 21h 
    
RET
InputCharNotEcho ENDP
	   
;LEE CARACTER CON ECO (SE GUARDA EN AL)
InputChar PROC
    
    MOV AH, 01h
    INT 21h 
    
RET
InputChar ENDP

;########################## 
;##					 	 ##
;##		VARIABLES		 ##
;##					 	 ##
;##########################

txtPregunta DB 'Ingrese un caracter: $' 
txtCalculos1 DB 13,10,'Suma en BX | # Numeros en DX$'
txtCalculos2 DB 13,10,'BX/CX: Cociente en AL, Resto en AH$'
txtPromedio DB 13,10,'Promedio en AL$'