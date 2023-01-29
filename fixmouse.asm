proc SavePal 
;Palbuffer: a buffer that will hold current RGB values of palette.
;Saves current palette in Palbuffer.
doPush ax,dx,di,cx

	xor al, al
	mov dx, 3C7h	;send to this port first palette cell to read.
	out dx, al      ;Read from index 0


	mov di, offset Palbuffer
	mov dx, 3C9h 	;Palette port, in this case to read.
	mov cx, 256*3
	
copypal1:	
		in al, dx						;in - read from port, out - write to port
		mov [di], al
		inc di
	loop copypal1
	
	
doPop cx,di,dx,ax	
ret
endp SavePal



proc RestorePal
;Palbuffer: a 256*3 buffer with saved RGB values of a 256 color palette.
;Changes program palette to the one in the Palbuffer.
doPush ax,dx,si,cx

	
	xor al, al
	mov dx, 3c8h	;send to this port from which palette cell to start writing.
	out dx, al      ;Write from index 0

	mov si, offset Palbuffer
	mov dx, 3C9h 	;Palette port, in this case to write to.
	mov cx, 256*3
	
restorepal1:
	mov al, [si]	
	out dx, al
	inc si
	loop restorepal1
		
doPop cx,si,dx,ax	
ret
endp RestorePal
