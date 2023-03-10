;ax: X - Board coords
;dx: Y - Board coords
;bl: FILLED_SQUARE_COLOR | NON_FILLED_SQUARE_COLOR  state of square 
;Changes cell at (x,y) on current board to what is stored at bl
proc SetBoardAtCord
	doPush ax,bx,cx,dx
	;Board[x,y] == Board[Y*AMOUNT_OF_SQUARES_HORIZONTAL + X]
	push ax
	mov ax, dx
	mul [AMOUNT_OF_SQUARES_HORIZONTAL]
	mov dx, ax
	pop ax
	add dx,ax
	
	
	cmp [CurrentBoard], 0
	je setBoard0
setBoard1:
	mov di, offset Board1 
	jmp setBoardColor
setBoard0:
	mov di, offset Board0
setBoardColor:
	add di,dx
	mov [di], bl
	doPop dx,cx,bx,ax
ret
endp SetBoardAtCord



;ax: X - Board coords
;dx: Y - Board coords
;bl: FILLED_SQUARE_COLOR | NON_FILLED_SQUARE_COLOR
;Changes cell at (x,y) on opposite board to what is stored in bl
proc SetOtherBoardAtCord
	doPush ax,bx,cx,dx
	call SwapBoard
	call SetBoardAtCord
	call SwapBoard
	doPop dx,cx,bx,ax
ret
endp SetOtherBoardAtCord


;ax: X - Board coords
;dx: Y - Board coords
;Toggles Color of squares at (x,y) to opposite color
proc ToggleBoardAtCord
	doPush ax,bx,cx,dx
	call GetBoardAtCord
	cmp bl, FILLED_SQUARE_COLOR;
	je filledToggle 
;Moves here if not filled
notFilledToggle:
	mov bl, FILLED_SQUARE_COLOR
	jmp toggle
filledToggle:
	mov bl, NON_FILLED_SQUARE_COLOR
toggle:
	call SetBoardAtCord
	
	doPop dx,cx,bx,ax
ret
endp ToggleBoardAtCord




;ax: X - Board coords
;dx: Y - Board coords
;returns byte that is the color of the board at that coord inside bl, bh is 00H 
proc GetBoardAtCord
	doPush ax,cx,dx
	;Board[x,y] == Board[Y*AMOUNT_OF_SQUARES_HORIZONTAL + X]
	push ax
	mov ax, dx
	mul [AMOUNT_OF_SQUARES_HORIZONTAL]
	mov dx, ax
	pop ax
	add dx,ax
	
	;Stores inside di current Board address
	cmp [CurrentBoard], 0
	je getBoard0
getBoard1:
	mov di, offset Board1 
	jmp getBoardColor
getBoard0:
	mov di,offset Board0
getBoardColor:
	;Get board at index from earlier calculation 
	add di, dx
	xor bx, bx
	mov bl, [di]
	
	
	doPop dx,cx,ax
ret 
endp GetBoardAtCord

; Swaps current board to be next board
; 1 - [CurrentBoard] == OtherBoard
proc SwapBoard
	doPush ax,bx,cx,dx
	mov al, 1
	sub al, [CurrentBoard]
	mov [CurrentBoard], al
	doPop dx,cx,bx,ax
ret
endp SwapBoard
