format PE GUI 4.0
entry inicio

include 'Win32a.inc'

ventana_1	equ		1
salir_btn	equ		1000

section '.data' data readable writeable

Ist  dd 0
pWnd dd 0
Wnd2 dd 0


monto dd 0

unidades dd 0

decimales dd 0

;boliviano, euro, dolar

boliviano dd 1, 14, 13 

euro dd 747, 1, 108 

dolar dd 691, 92, 1


miMoneda dd 0

indiceMoneda dd 0


monedaBoliviano db 'Boliviano', 0
monedaEuro db 'Euro', 0
monedaDolar db 'Dolar', 0

mensajeBoliviano db ' Bolivianos', 0
mensajeEuro db ' Euros', 0
mensajeDolar db ' Dolares estadounidenses', 0

mensajeMoneda dd mensajeBoliviano, mensajeEuro, mensajeDolar

mensaje dd 0
 
cadUnidades db 100 dup(0)
cadDecimales db 100 dup(0)
formato db '%d', 0

dot db '.', 0

cambio db 100 dup(0)
section '.code' code readable executable
macro MonedaOrigen coin{ ; verifica que moneda es
	local .bol, .eur, .dol, .fin

	cmp coin, 0
	je .bol
	
	cmp coin, 1
	je .eur
	
	cmp coin, 2
	je .dol
	
	.bol:	
	mov eax, boliviano
	mov [miMoneda], eax
	mov edi, mensajeMoneda
	mov [mensaje], edi
	jmp .fin
	
	.eur:
	mov eax, euro
	mov [miMoneda], eax
	jmp .fin
	
	.dol:
	mov eax, dolar
	mov [miMoneda], eax
	jmp .fin
	
	.fin:
}

macro calcularCambio{
	
	mov edi, 0
	mov ecx, 0
	mov esi, 0
	
	mov edi,[indiceMoneda]

	mov esi,[miMoneda]
	mov ecx,[esi+edi]
	
	mov eax,[monto]
	
	imul ecx
	
	mov [monto], eax
}

macro convertirDecimal{

	mov ebx, 100
	mov eax, [monto]
	div ebx
	
	mov [unidades], eax
	mov [decimales], edx
	
	invoke wsprintf,cadUnidades,formato,[unidades]
	invoke wsprintf,cadDecimales,formato,[decimales]
	
	invoke lstrcpy,cambio,cadUnidades
	
	invoke lstrcat,cambio,dot
	invoke lstrcat,cambio,cadDecimales  ; guarda en cambio

	
}

macro convertir{
	
	invoke GetDlgItemInt,[pWnd],1001,0,FALSE
	mov [monto], eax
	
	calcularCambio
	
	convertirDecimal
	
	mov ebx,[monto]
	mov esi,[mensaje]
	
	
	invoke SetDlgItemText,[pWnd],1002,cambio,FALSE
	
 }

macro MonedaConvertir coin{
	local .bol, .eur, .dol, .fin

	cmp coin, 0
	je .bol
	
	cmp coin, 1
	je .eur
	
	cmp coin, 2
	je .dol
	
	.bol:	
	mov eax, 0
	mov [indiceMoneda], eax
	jmp .fin
	
	.eur:
	mov eax, 4
	mov [indiceMoneda], eax
	jmp .fin
	
	.dol:
	mov eax, 8
	mov [indiceMoneda], eax
	jmp .fin
	
	.fin:
 }

;///////////////////////////////////////////////////// inicio
inicio:
	invoke GetModuleHandle,0
	mov [Ist],eax
	invoke DialogBoxParam,eax,ventana_1,0,DlgProc,0 
fin:
	invoke ExitProcess,0



proc DlgProc,hWnd,uMsg,wParam,lParam
	push edi esi ebx
	
	mov eax,[uMsg]
	cmp	eax,WM_COMMAND
	je	jCOMMAND
	cmp	eax,WM_INITDIALOG
	je	jINITDIALOG
	cmp	eax,WM_CLOSE
	je	jCLOSE
	xor eax,eax
	jmp finish

jINITDIALOG:
	mov eax,[hWnd]
	mov [pWnd],eax
	
	invoke SendDlgItemMessage, [pWnd], 5002, CB_ADDSTRING, 0, monedaBoliviano
	invoke SendDlgItemMessage, [pWnd], 5002, CB_ADDSTRING, 0, monedaEuro
	invoke SendDlgItemMessage, [pWnd], 5002, CB_ADDSTRING, 0, monedaDolar
	
	invoke SendDlgItemMessage, [pWnd], 5001, CB_ADDSTRING, 0, monedaBoliviano
	invoke SendDlgItemMessage, [pWnd], 5001, CB_ADDSTRING, 0, monedaEuro
	invoke SendDlgItemMessage, [pWnd], 5001, CB_ADDSTRING, 0, monedaDolar

	mov eax,1
	jmp finish
	
jCOMMAND:
	mov eax,[wParam]
	
	cmp eax, 1003
	je eBtnEnviar
	
		
	cmp eax, 1100
	je tabla
	
	
	cmp	eax,salir_btn
	je	salir
	xor eax,eax
	jmp finish
	
salir:
	invoke SendMessage,[hWnd],WM_CLOSE,0,0
	mov eax,1
	jmp finish 
	
tabla:                                           
    invoke DialogBoxParam,[Ist],2,0,DlgProcDos,0 
    mov eax,1                                    
    jmp finish                                   

	
eBtnEnviar:
	invoke SendDlgItemMessage, [pWnd], 5001, CB_GETCURSEL, 0, 0
	mov [indice], eax	
	
	invoke SendDlgItemMessage, [pWnd], 5002, CB_GETCURSEL, 0, 0
	mov [indice+4], eax
	
	mov eax,[indice]
	
	MonedaOrigen eax
	
	MonedaConvertir eax 
	
	invoke GetDlgItemInt,[pWnd],1001,0,FALSE
	mov [monto], eax
	
	calcularCambio
	
	convertirDecimal 100, resultado
	
	nombreMoneda
	
	invoke SetDlgItemText,[pWnd],1002,cambio,FALSE
	
finEnviar:
	mov eax, 1
	jmp finish

jCLOSE:	
	invoke EndDialog,[hWnd],0
	mov eax,1
	
finish:
	pop ebx esi edi
	ret
endp















;segunda ventana 
proc DlgProcDos,hWnd,uMsg,wParam,lParam
	push edi esi ebx
	
	mov eax,[uMsg]
	cmp	eax,WM_COMMAND
	je	.jCOMMAND
	cmp	eax,WM_INITDIALOG
	je	.jINITDIALOG
	cmp	eax,WM_CLOSE
	je	.jCLOSE
	xor eax,eax
	jmp .finish

.jINITDIALOG:
	mov eax,[hWnd]
	mov [Wnd2],eax
	mov eax,1
	jmp .finish
	
.jCOMMAND:
	mov eax,[wParam]
	jmp .finish
	


.jCLOSE:	
	invoke EndDialog,[hWnd],0
	mov eax,1
	
.finish:
	pop ebx esi edi
	ret
endp



section '.idata' import data readable writeable
  ;importamos solo los procedimientos basicos para abrir una ventana
  ;library kernel, 'KERNEL32.DLL',\
;  user,   'USER32.DLL'
;
;  import  kernel,\
;	  GetModuleHandle,'GetModuleHandleA',\
;	  ExitProcess,	  'ExitProcess'
;
;  import  user,\
;	  DialogBoxParam, 'DialogBoxParamA',\
;	  EndDialog,	  'EndDialog',\
;	  SendMessage,	  'SendMessageA'
  ;otra forma para importar los procedimientos importando archivos INC
  library kernel32,'KERNEL32.DLL',user32,'USER32.DLL',gdi32,'GDI32.DLL'
  include 'api\kernel32.inc'
  include 'api\user32.inc'
  include 'api\gdi32.inc'

section '.rsrc' resource from 'ComboBox.res' data readable
