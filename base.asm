include macros.asm

IDEAL
MODEL small
STACK 100h
DATASEG

include "vars.asm"

CODESEG
include "delay.asm"
include "fixmouse.asm"
include "initvars.asm"
include "board.asm"
include "drawing.asm"
include "game.asm"
include "bmpfile.asm"
start:
	mov ax, @data
	mov ds, ax
	
	mov ax ,0013H; Graphic mode register values
	int 10H; Interupt for setting graphic mode
	
	;Save pallete for later returning to original pallete
	call SavePal
	
	mov [CurrentFile], offset openingScreen
	call ShowBmp
	
;			  >Enter->Gamescreen 
;Home screen |
;	  	     >r->rules1->Enter->rules2->Enter->Home screen


waitKeyStartGame:
	xor ah,ah;Wait for key press
	int 16h
	
	cmp al, 'r'; if key is r show rules
	jne dontShowRules
	mov [CurrentFile], offset RulesScreen1
	call ShowBmp
waitKeyRules2:
	xor ah,ah
	int 16h
	cmp al,13D;if key is enter show rules2 screen
	jne waitKeyRules2
	mov [CurrentFile], offset RulesScreen2
	call ShowBmp	
waitKeyReturnToHomeScreen:
	xor ah, ah
	int 16h
	cmp al, 13D; if key is enter return to home screen
	jne waitKeyReturnToHomeScreen
	mov [CurrentFile], offset OpeningScreen
	call ShowBmp
	jmp waitKeyStartGame
	
	
	
dontShowRules:
	cmp al, 13D; if key is Enter start game
	jne waitKeyStartGame

	;Fix pallete so that mouse is white
	call RestorePal

	call InitVars
	
	

	
	call DrawGrid
	call DrawSquares; Draws board with NON_FILLED_COLOR
	
	xor ax, ax;Initialize mouse
	int 33H
	
	mov ax, 0001H; Show mouse
	int 33H
	


	
	
preGameLoop:

	mov ah,01H; Check for a keyboard press on any button
	int 16H
  jnz initMainLoop
	
	mov ax, 0005H
	xor bx, bx
	int 33H; Left button pressed interupt
	
	test bx, 0FFFFH
	jz noClick
	
	
	shr cx, 1;Divide cx by 2 because it comes twice the size
	mov bx, dx; Hold MouseY in bx instead of dx because div uses dx
	
	cmp cx, [LEN_HORIZONTAL];Check button press is in grid
	ja noClick
	
	cmp dx, [LEN_VERTICAL];Check button press is in grid
	ja noClick
	
	
	; Basically: MouseX_SCREEN_COORDS / SQUARE_SIZE == MouseX_BOARD_COORDS 
	mov ax, cx; Move cx into ax because div uses ax and cx holds MouseX
	xor dx, dx; mov 0 into dx because div uses dx 
	div [SQUARE_SIZE]; MouseX_SCREEN_COORDS / SQUARE_SIZE
	
	push ax; Push ax because div uses ax but ax current holds calculated value
	xor dx, dx; ; mov 0 into dx because div uses dx 
	mov ax, bx; Move MouseY into ax for div
	div [SQUARE_SIZE]; MouseY_SCREEN_COORDS / SQUARE_SIZE
	mov dx,ax; Return result of calculation into dx for ToggleBoardAtCord
	pop ax; Return result of calculation into ax for ToggleBoardAtCord
	
	
	
	push ax; Push ax for interupt
	mov ax, 0002H;Hide mouse pointer
	int 33H
	pop ax; Pop ax for toggle at cord
	call ToggleBoardAtCord
	call DrawSquares
	mov ax ,0001H;Show mouse pointer
	int 33H
	

	
noClick:
	jmp preGameLoop


initMainLoop:
	mov ax, 0002H;Hide mouse pointer
	int 33H
mainLoop:
	call ConwaysGameOfLife
	call SwapBoard
	call DrawSquares
	; call Delay
	ExitIfEsc
	
	
	mov	ah, 1;Check keyboard status
	int	16h
	jz mainLoop
	
	xor ah, ah; Read key
	int 16h
	
	
	cmp	al, 'p'; return to preGame if p pressed
	jne mainLoop 
	pIsPressed:
		mov ax ,0001H;Show mouse pointer because preGame uses mouse
		int 33H
		jmp preGameLoop
	
	
	jmp mainLoop

exit:
	mov ax, 0003H; Return to Text mode
	int 10H
	
	mov ax, 4c00h
	int 21h
END start





