;
;  Based on sample project found here,
;  http://www.randomterrain.com/atari-2600-memories-tutorial-andrew-davie-13.html
;

	processor 6502;
	include "vcs.h"
	include "macro.h"

PATTERN = $80
CHANGE_TIMER = 20

	SEG
	ORG $F000

Reset
	ldx #0
	lda #0
Clear	
	sta 0,x
	inx
	bne Clear

	lda #0
	sta PATTERN	; playfield pattern

	lda #$45
	sta COLUPF	; playfield color

	ldy #0		; timer counter

Frame
	; vertical blank setup

	lda #0
	sta VBLANK

	lda #2
	sta VSYNC

	sta WSYNC
	sta WSYNC
	sta WSYNC

	lda #0
	sta VSYNC

	; 37 scanlines of vertical blank
	ldx #0
VBlank	sta WSYNC
	inx
	cpx #37
	bne VBlank

	; timer logic to change the playfield pattern
	iny
	cpy #CHANGE_TIMER
	bne TimerSkip
	ldy #0

	inc PATTERN
TimerSkip

	lda PATTERN
	sta PF1		; set playfield pattern

	; 192 scanlines of background
	ldx #0
Background
	stx COLUBK	; rainbow color effect

	sta WSYNC
	inx
	cpx #192
	bne Background

	; resume vblank
	lda #%01000010
	sta VBLANK

	; 30 lines overscan
	ldx #0
Overscan
	sta WSYNC
	inx
	cpx #30
	bne Overscan

	jmp Frame

	ORG $FFFA

InterruptVectors
	.word Reset	; NMI
	.word Reset	; RESET
	.word Reset	; IRQ

END

