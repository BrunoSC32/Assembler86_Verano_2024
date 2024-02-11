.model tiny
.code org 100h
	mostrar macro arg
		lea dx,arg
		call show
	endm
	comparar macro arg1,arg2
		lea si,arg1
		lea di,arg2
		siguiente:
			mov al.[si]
			cmp al,0
			je esIgual
			cmp al,[di]
			jne terminar
			inc di
			inc si
			jmp siguiente
		esIgual:
			xor ax,ax
			jmp fin
		terminar:
			mov al,1
		fin:
			endm
	main:
	login:
		call clear
		mov cx,opt
		push cx
	t1:
		call clear
		lea si,nombre
		mostrar MsgBienvenido
		mostrar cadNombre
	s2:
		call leer
		cmp al,13
		je s1
		mov [si],al
		inc si
		jmp s2
	s1: 
		lea si,pass
		mostrar cadPass
	s4:
		call leer
		cmp al,13
		je s3
		mov [si],al
		inc si
		jmp s4
	s3:
		pop cx
		dec cx
		push cx
		comparar nombre,nombreDb
		cmp al,0
		je case1
		cmp cx,0
		je fin
		mostrar errorUsuario
		mostrar otra
	z1:
		dec time
		mov ah,86h
		mov cx,000Fh
		mov dx,4240h
		int 15h  
		cmp time,0
		jne z1
		jmp t1
	case1:
		mostrar autorizado
		jmp f2
	fin:
		mostrar ban
	f2:
		int 20h
		
	MsgBienvenido db 10,13,"**********************"
				  db 10,13,"     BIENVENIDO       "
				  db 10,13,"**********************$"
	cadNombre 	  db 10,13,"Ingrese su ID: $"
	cadPass		  db 10,13,"Ingrese su password: $"
	autorizado    db 10,13,"Esta autorizado para"
				  db 10,13,"Entrar al Sistema $"
	errorUsuario  db 10,13,"Error de usuario$"
	otra		  db 10,13,"Vuelva a Intentarlo$"
	ban			  db 10,13,"Usted queda BLOQUEADO$"
	nombre		  db 50 dup('$')
	pass		  db 50 dup('$')
	nombreDb	  db 'Alex',0
	passDb		  db '12345',0
	opt			  equ 3
	time		  equ 5
	
	clear:
		mov al,3
		int 21h
	ret
	leer:
		mov ah,1
		int 21h
	ret
	leerSinEcho:
		mov ah,7
		int 21h
	ret
	mostrarAsterisco:
		mov ah,2
		mov dl,'*'
		int 21h
	ret
	show:
		mov ah,9
		int 21h
	ret
	end main
	
	
;REALIZAR UN PROGRAMA DE ACCESO QUE INGRESE A UN JUEGO DE TAL MANERA QUE SI LAS CREDENCIALES SEAN INCORRECTAS
;TENGA UN TIEMPO DE INACTIVIDAD DE 5 SEG EN LOS CUALES NO ME PERMITA REALIZAR NINGUNA OPERACION--- RELOJ --- V- 125MS 1m
;Y A LOS 3 INTENTOS ERRONEOS LA CUENTA SEA BANEADA 