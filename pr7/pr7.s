.global _start
_start:
	mov r2, #0
	mov r5, #0
	mov r6, #0
	b loop
loop:
    ldr r1, =0xff201000
	ldrb r4, [r1]
	cmp r4, #10
	beq stop
	
	cmp r6, #1
		cmpeq r4, #32
		moveq r5, #1
	cmp r5, #1
		cmpne r4, #32
		movne r4, #0
		movne r6, #1
		
	cmp r4, #65
	strltb r4, [r1]
	blt loop
		cmpge r4, #90
		addle r4, r4, #32
	strb r4, [r1]
	b loop
	
stop: b stop
	
.data
	buffer: .space 256
	
	
	