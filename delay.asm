proc Delay

; [Clock],es:6ch : Current Clock ticks
; [LongDelay]: Number of clock ticks to wait until the procedure returns.
; Performs a time delay according to the value in [LongDelay]
	doPush ax,cx,es
	mov ax, 40h
	mov es, ax
	mov ax, [Clock]
	
FirstTick: 
	cmp ax, [Clock]		;Starting delay only when firt tick occurs.
	je FirstTick
	
	mov cx, [LongDelay] ;4 = 0.55*4 = approx 2 seconds. 1 tick = 0.55 sec
	
DelayLoop:
	mov ax, [Clock]		;getting timer status
Tick:
	cmp ax, [Clock]		;checking if it has changed meaning there was a tick.
	je Tick				;didnt change? wait until it changes.
	loop DelayLoop
	doPop es,cx,ax
ret
endp delay