doPush macro r1,r2,r3,r4,r5,r6,r7,r8,r9
        irp register,<r9,r8,r7,r6,r5,r4,r3,r2,r1>
                ifnb <register>
                        push register
                endif
        endm
endm

doPop macro r1,r2,r3,r4,r5,r6,r7,r8,r9
        irp register,<r9,r8,r7,r6,r5,r4,r3,r2,r1>
                ifnb <register>
                        pop register
                endif
        endm
endm


ExitIfESC macro	;exit if esacped is pressed in keyboard
	local label1
	in al, 64h
	xor al, 10b
	jz label1
	in al, 60h
	xor al, 1
	je exit
	label1:
endm	