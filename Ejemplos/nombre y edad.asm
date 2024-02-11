.model tiny
.code org 100h
	mostrar macro arg
		lea dx,arg
		call show
	endm
	
	main:
		mostrar cadN1
		lea di,cadNombre
	nombre:
		call leer
		cmp al,13
		je edad
		mov [di],al
		inc di
		jmp nombre
	edad:
		mostrar cadE1
		lea di,cadEdad
	edad2:
		call leer
		cmp al,13
		je casos
		cmp al,'0'
		jb edad2
		cmp al,'9'
		ja edad2
		mov [di],al
		inc di
		jmp edad2
	casos:
		lea di,cadEdad
	l1:
		cmp [di],'$'
		je PoI
		inc di
		jmp l1
	PoI:
		dec di
		mov cl,[di]
		sub cl,30
		div cl,2
		cmp ah,1
		je C1
		jmp C2
	C1:
		mostrar cadEdad
		mostrar cadNombre
		jmp fin
	C2:
		mostrar cadNombre
		mostrar cadEdad
	fin:
		int 20h
		
	cadN1	  db 10,13,"Ingrese su nombre: $"
	cadE1	  db 10,13,"Ingrese su edad: $"
	cadNombre db 50 dup('$')
	cadEdad	  db 10 dup('$')
	
	leer:
		mov ah,1
		int 21h
	ret
	
	show:
		mov ah,9
		int 21h
	ret
	end main