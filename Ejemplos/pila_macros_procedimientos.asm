
;USO DE MACROS,PROCEDIMIENTOS Y PILA

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

PrintStr txtPregunta  

CALL InputChar ; se guarda en AL

PrintStr txtResultado 

PrintChar AL		
	    
INT 20h ;FIN DEL PROGRAMA  

;################################## 
;##					 			 ##
;##	      PROCEDIMIENTOS		 ##
;##					 			 ##
;##################################
	   
;LEE CARACTER (SE GUARDA EN AL)
;PARA LEER SIN ECO: MOV AH,08h
InputChar PROC
    
    MOV AH, 01h
    INT 21h 
    
RET
InputChar ENDP

;########################## 
;##					 	 ##
;##		VARIABLES		 ##
;##						 ##
;##########################

txtPregunta DB 'Ingrese un caracter: $'
txtResultado DB 13,10,'Usted ingreso: $'