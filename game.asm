;Runs rules on all cells in grid
proc ConwaysGameOfLife
	doPush ax,bx,cx,dx
	
	mov cx,[AMOUNT_OF_SQUARES_HORIZONTAL] 
conwaysGameOfLifeLoopX:
	push cx
	mov cx,[AMOUNT_OF_SQUARES_VERTICAL]
	conwaysGameOfLifeLoopY:
		pop ax; put outer cx in ax
		push ax; return cx to stack
		dec ax; dec to include zero and exclude [AMOUNT_OF_SQUARES_HORIZONTAL]
		mov dx, cx; put inner cx in dx
		dec dx; dec to include zero and exclude [AMOUNT_OF_SQUARES_VERTICAL]
		
		call ConwaysGameOfLifeSingleCell
		loop conwaysGameOfLifeLoopY
	pop cx
	loop conwaysGameOfLifeLoopX
	
	doPop dx,cx,bx,ax
ret
endp ConwaysGameOfLife

;ax: X - Board coords
;dx: Y - Board coords
;Runs the rules of life on (x,y) in current board and writes results to other board
proc ConwaysGameOfLifeSingleCell
	doPush ax,cx,dx
	xor bx, bx; Holds amount of neighbours
	
	dec dx;y-1
	dec ax;x-1
	call AddneighboursToBx; x-1, y-1
	
	inc dx;y
	call AddneighboursToBx; x-1, y
	
	inc dx;y+1
	call AddneighboursToBx; x-1, y+1
	sub dx, 2; y-1
	inc ax; x
	call AddneighboursToBx; x, y-1
	
	
	inc dx;y
	;x, y isn't included beacuse a cell isn't a neighbor of itself
	inc dx;y+1
	
	call AddneighboursToBx; x, y+1
	sub dx, 2; y-1
	inc ax; x+1
	call AddneighboursToBx; x+1, y-1
	
	inc dx
	call AddneighboursToBx; x+1, y
	
	inc dx
	call AddneighboursToBx; x+1, y+1
	
	dec dx;y
	dec ax;x
	
	push bx
	call GetBoardAtCord
	cmp bl, FILLED_SQUARE_COLOR; Check if cell is filled or not and apply rules accordingly
	jne squareNotFilled
squareFilled:
	pop bx
	
	cmp bx, 2; Rule 1: Cell with less than 2 neighbours dies of lonelyness
	jb makeSquareDead
	cmp bx, 3; Rule 2: Cell with more than 3 neighbours dies of overpopulation
	ja makeSquareDead
	jmp makeSquareAlive; Rule 3: Cell with 2 or 3 neighbours lives on
squareNotFilled:
	pop bx
	cmp bx,3; Rule 4: Dead cell with exactly 3 neighbours comes back to life
	je makeSquareAlive
	jmp makeSquareDead; Dead cell stays dead
	

makeSquareDead:
	mov bl, NON_FILLED_SQUARE_COLOR
	call SetOtherBoardAtCord
	jmp exitConwaysGameOfLifeSingleCell
makeSquareAlive:
	mov bl, FILLED_SQUARE_COLOR
	call SetOtherBoardAtCord

exitConwaysGameOfLifeSingleCell:
	doPop dx,cx,ax
ret
endp ConwaysGameOfLifeSingleCell



;ax - X Board coords
;dx - Y Board chords
;Increments bx if the point at those coordinates is alive
;Coordinates come incremented or decremented from ConwaysGameOfLifeSingleCell
;So it also checks if those coordinates are inside grid and if they aren't it uses the cell from the other side of the board making the game cyclic
proc AddneighboursToBx
	doPush cx, ax, dx
;Check decremented/incremented ax and dx are in board 
;dec 0 == FFFFH
	cmp ax,0FFFFH ; if(ax == -1) ax = [AMOUNT_OF_SQUARES_HORIZONTAL]-1
	jne dontMakeAxLast
	mov ax, [AMOUNT_OF_SQUARES_HORIZONTAL]
	dec ax
dontMakeAxLast:
	cmp dx,0FFFFH; if(dx == -1) dx = [AMOUNT_OF_SQUARES_VERTICAL]-1
	jne dontMakeDxLast
	mov dx, [AMOUNT_OF_SQUARES_VERTICAL]
	dec dx
dontMakeDxLast:
	cmp ax, [AMOUNT_OF_SQUARES_HORIZONTAL]; if(ax == [AMOUNT_OF_SQUARES_HORIZONTAL]) ax = 0
	jnae dontMakeAxZero
	xor ax, ax
dontMakeAxZero:
	cmp dx, [AMOUNT_OF_SQUARES_VERTICAL]; if(dx == [AMOUNT_OF_SQUARES_VERTICAL]) dx = 0
	jnae dontMakeDxZero
	xor dx, dx
dontMakeDxZero:
	push bx
	call GetBoardAtCord
	cmp bl, FILLED_SQUARE_COLOR
	pop bx
	je addNeighbor
	jmp dontAddNeighbor
addNeighbor:
	inc bx
dontAddNeighbor:
	doPop dx, ax, cx	
ret
endp AddneighboursToBx

