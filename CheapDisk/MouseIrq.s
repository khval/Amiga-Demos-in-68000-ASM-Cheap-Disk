	move.l	$6c.w,saveirq3+2
	move.l	#irq3,$6c.w

;====================================================================
irq3:	movem.l	d0-d7/a0-a6,-(a7)
	move	$dff01e,d0
	and	$dff01c,d0
	btst	#5,d0
	beq.w	NoPlay
	bsr	mots_control
NoPlay:	movem.l	(a7)+,d0-d7/a0-a6
saveirq3:
	jmp	$0
;====================================================================
mots_control:
	lea	Pointeur,a3
	move.b	$dff00a,d0
	move.b	d0,d2

	move.b	lasty,d1
	sub.b	d1,d0
	ext	d0
	add.w	d0,mousey
	move.b	d2,lasty

	move.b	$dff00b,d0
	move.b	d0,d2
	move.b	lastx,d1
	sub.b	d1,d0
	ext	d0
	add.w	d0,mousex
	move.b	d2,lastx
	cmp.w	#$1bf,mousex
	bls	paslimite
	move.w	#$1bf,mousex
paslimite:
	cmp.w	#$80,mousex
	bhs	paslimite2
	move.w	#$80,mousex
paslimite2:
	cmp.w	#$29,mousey
	bge	paslimite3
	move.w	#$29,mousey
paslimite3:
	cmp.w	#$4C,mousey
	bls	paslimite4
	move.w	#$4C,mousey
paslimite4:
	move.b	mousey+1,(a3)	;Adrsp0
	move.b	mousey,d0
	lsl.b	#2,d0
	move.w	mousex,d1
	ror.w	#1,d1
	bpl.w	pasneg
	or.w	#1,d0
pasneg:
	move.b	d1,1(a3)	;Adrsp0+1
	move.w	mousey,d1
	add.w	#13,d1
	move.b	d1,2(a3)	;Adrsp0+2
	lsr.w	#8,d1
	lsl.w	#1,d1
	or.b	d1,d0
	move.b	d0,3(a3)	;Adrsp0+3
	rts

mousex:		dc.w	$41
mousey:		dc.w	$40
lastx:		dc.b	0
lasty:		dc.b	0

Pointeur:
	dc.w	$4040,$5000
	blk.l	16,-1
	dc.l	0
