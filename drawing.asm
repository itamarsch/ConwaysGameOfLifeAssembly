;
; Board coords - coordinates according to squares. 
; Each square has its own coordinate top left is (0, 0)
;
; Screen coords - coordinates according to pixels on screen
;
;
;

; bx: X - Screen coords
; dx: Y - Screen coords
; al: Color
; Draws pixel at the coordinates of x,y with the color 
proc ColorPixel
	doPush ax,bx,cx,dx,es
	push ax
	mov ax, 0A000H; Initialize Segement for coloring
	mov es, ax
	
	mov ax, 0000H
	
	;n * 320 == n * ( 256 + 64) == n * (2^6 + 2^8) == n*2^6 + n*2^8
	mov ax, dx; Store y for calculation
	shl dx, 6; n * 2^6
	shl ax, 8; n * 2^8
	add ax, dx
	add ax, bx; n*2^6 + n*2^8
	
	mov di,ax
	pop ax
	mov [es:di], al
	doPop es,dx,cx,bx,ax
	
ret
endp ColorPixel

;dx: Y for line - Screen coords
;al: Color
;Draws horizontal line from 0 to LEN_HORIZONTAL go to vars file for explanation for LEN_HORIZONTAL
proc DrawLineHorizontal
	doPush ax,bx,cx,dx
	mov cx, [LEN_HORIZONTAL]
	
loopForLineHoriz:
	mov bx,cx
	dec bx; Decrement bx to include 0
	call ColorPixel
	
	loop loopForLineHoriz
	doPop dx,cx,bx,ax
ret
endp DrawLineHorizontal


;bx: X for line - screen coords
;al: Color
;Draws vertical line from 0 to LEN_VERTICAL go to vars file for explanation for LEN_VERTICAL
proc DrawLineVertical
	doPush ax,bx,cx,dx
	mov cx, [LEN_VERTICAL]

loopForLineVert:
	mov dx,cx
	dec dx
	call ColorPixel
	
	loop loopForLineVert
	doPop dx,cx,bx,ax
ret
endp DrawLineVertical


;Draws grid based on square size
proc DrawGrid
	doPush ax,bx,cx,dx
	mov cx,[AMOUNT_OF_SQUARES_VERTICAL]; Amount of lines to draw
	mov dx, 0000H
	inc cx; Inc because zero is not included in loop
	mov al, LINE_COLOR
	
drawGridLoopHoriz:
	call DrawLineHorizontal
	add dx,[SQUARE_SIZE]
	loop drawGridLoopHoriz
	
	
	mov cx,[AMOUNT_OF_SQUARES_HORIZONTAL]
	mov bx, 0000H
	inc cx
	mov al, LINE_COLOR
drawGridLoopVert:
	call DrawLineVertical
	add bx,[SQUARE_SIZE]
	loop drawGridLoopVert
	
	
	;Draw bottom right corner because it is not included in the lines
	mov bx, [LEN_HORIZONTAL]
	mov dx, [LEN_VERTICAL]
	call ColorPixel
	
	doPop dx,cx,bx,ax
ret
endp DrawGrid



;ax: X - Board coords
;dx: Y - Board coords
;SquareColor: Color of square
;Draws a square at coordinates in the color of whatever is stored in SquareColor
proc DrawSquare
	doPush ax,bx,cx,dx


	push dx
	mul [SQUARE_SIZE]; Convert ax(X value) from board coords to screen coords by multiplication
	pop dx
	inc ax; inc to not include left line

	push ax; Push calculated ax because we need it for multiplication
	mov ax,dx
	mul [SQUARE_SIZE]; Convert dx (Y value) from board coords to screen coords by multiplication
	mov dx,ax
	inc dx; inc for not including upper line
	pop ax; Return calculated ax from stack to ax




	mov cx, [SQUARE_SIZE]; Amount of loops for outer loop
	dec cx; Dec for not including line
outerLoopDrawSquare:
	push cx
	mov cx, [SQUARE_SIZE]
	dec cx; Dec for not including line
	mov bx, ax
	innnerLoopDrawSquare:
		push ax
		mov al, [SquareColor]; Color for pixels
		call ColorPixel
		pop ax
		inc bx
		loop innnerLoopDrawSquare
	pop cx
	inc dx
	loop outerLoopDrawSquare


	doPop dx,cx,bx,ax
ret
endp DrawSquare


;Draws all squares in screen according to board
proc DrawSquares
	doPush ax,bx,cx,dx
	mov cx, [AMOUNT_OF_SQUARES_HORIZONTAL]
	
outerDrawSquares:
	push cx
	mov ax,cx
	dec ax
	mov cx, [AMOUNT_OF_SQUARES_VERTICAL]
	innerDrawSquares:
		mov dx,cx
		dec dx
		call GetBoardAtCord
		
		mov [SquareColor], bl
		call DrawSquare
	
		loop innerDrawSquares
	pop cx
	loop outerDrawSquares
	doPop dx,cx,bx,ax
ret
endp DrawSquares
