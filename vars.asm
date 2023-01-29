;All these values are customizable
SQUARE_SIZE dw 3D ; Number of pixels the width and height of each square are
LINE_COLOR equ  18D ; Color of the lines of the grid
FILLED_SQUARE_COLOR equ 30H; Color of filled Squares
NON_FILLED_SQUARE_COLOR equ 00H; Color of non filled squares

SCREEN_WIDTH equ 320
SCREEN_HEIGHT equ 200

;Amount of pixels between edge of screen to end of grid, (gridWidth != screenWidth), grid is calculated to fit the maximum number of squares according to square size
VERTICAL_OFFSET db ?; Here vertically, VERTICAL_OFFSET == SCREEN_HEIGHT % SQUARE_SIZE
HORIZONTAL_OFFSET db ?; Here horiontally, HORIZONTAL_OFFSET == SCREEN_WIDTH % SQUARE_SIZE


; Number of pixels in grid.
LEN_VERTICAL dw ?; Here vertically, LEN_VERTICAL == SCREEN_HEIGHT - VERTICAL_OFFSET
LEN_HORIZONTAL dw ?; Here horiontally, LEN_HORIZONTAL == SCREEN_WIDTH - HORIZONTAL_OFFSET

; Amount Squares that fit in grid in each direction
AMOUNT_OF_SQUARES_HORIZONTAL dw ?; Here horiontally, AMOUNT_OF_SQUARES_HORIZONTAL == SCREEN_WIDTH / SQUARE_SIZE
AMOUNT_OF_SQUARES_VERTICAL dw ?; Here vertically, AMOUNT_OF_SQUARES_VERTICAL == SCREEN_HEIGHT / SQUARE_SIZE

;Arrays that hold the state of the grid
;There are two because each iteration one is drawn and one is written to and at the and of the iteration they switch role
;Picked arbitrary size of 8000 not recomended to make square size less than 3 bad things will happen!
Board0 db 8000 dup (NON_FILLED_SQUARE_COLOR)
Board1 db 8000 dup (NON_FILLED_SQUARE_COLOR)


;A parameter for DrawSquare procedure tells the procedure what color to draw the square
SquareColor db 15D

;Holds current board that is shown: 0 | 1
CurrentBoard db 1D

Clock     equ es:6Ch  ;Adress of clock
LongDelay dw 1 ; Amount of ticks to wait in delay procedure

Palbuffer db 256*3 dup (?); Used to save initial pallet and restore it so that mouse ins't red and stays white

CurrentFile   dw ?;Holds address of string for bmp file to show

;File names for bmp files 
RulesScreen1  db 'rscreen1.bmp', 0
RulesScreen2  db 'rscreen2.bmp', 0
OpeningScreen db 'oscreen.bmp', 0



;Variables for changing screen to bmp
filehandle    dw ?
Header        db 54 dup (0)
Palette       db 256*4 dup (0)
ScrLine       db 320 dup (0)

ErrorMsg      db 'Error in open file', 13, 10,'$' ;Error msg to show when there is an error opening file

