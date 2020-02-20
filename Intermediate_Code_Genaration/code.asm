.model small

.stack 100h

.data
a2 dw ?
a3 dw ?
b3 dw ?
x3 dw ?
a4 dw ?
b4 dw ?
s0 dw ?
t1 dw ?
t2 dw ?

.code 





main PROC NEAR

	mov ax,   1
	mov a4, ax
	mov ax,   2
	mov b4, ax
	call f
	mov ax,   f
	mov b4, ax
	mov ax,   b4
	call PRINT_DECIMAL
	mov dx,0
	mov ah,4ch
	int 21h

main ENDP


f PROC NEAR

	mov ax,   2
	mov bx, a2
	mul bx
	mov s0, ax
	mov dx,s0
	
	pop bp
	ret 1


f ENDP

g PROC NEAR

	mov ax,   f
	add ax, a3
	mov t1 , ax
	mov ax,   t1
	add ax, b3
	mov t2 , ax
	mov ax,   t2
	mov x3, ax
	mov dx,x3
	
	pop bp
	ret 2


g ENDP



PRINT_DECIMAL PROC NEAR

	push ax
	push bx
	push cx
	push dx
	or ax,ax
 	jge enddif
	push ax
	mov dl,'-'
	mov ah,2
	int 21h
	pop ax
	neg ax
enddif:
	xor cx,cx
	mov bx,10d
repeat:
	xor dx,dx
	div bx
	 push dx
	inc cx
	or ax,ax
	jne repeat
	mov ah,2
print_loop:
	pop dx
	or dl,30h
	int 21h
	loop print_loop
	pop dx
	pop cx
	pop bx
	pop ax
	ret

PRINT_DECIMAL ENDP
