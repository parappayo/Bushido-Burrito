;
;  colors.asm
;
;  Jason's first Atari 2600 ROM!
;  We're going to play with the playfield
;  and colors.  Wooooo..
;
;  build using dasm:
;    dasm colors.asm -f3

	processor 6502
	org $F000

VSYNC	= $00
VBLANK	= $01
WSYNC	= $02

COLUPF	= $08
COLUBK	= $09

CTRLPF	= $0A
PF0	= $0D
PF1	= $0E
PF2	= $0F

Main
	; set up the stack
	ldx #$FF
	txs

	jsr Init

	; use $81 as our looping color var
	lda #$01
	sta $81

mloop	jsr StartVFrame

	; use $80 as our color var
	lda $81
	sta $80

	inc $81
	; limit to 128 colors
;	cmp #$80
;	bne skip1
;	lda #$0
;	sta $81
;skip1

	ldy #$D2	; 210 horiz lines (?)
hloop	
	lda $80
	sta COLUPF	; set playfield color
	inc $80		; color++
	; limit to 128 colors
;	cmp #$80
;	bne skip2
;	lda #$0
;	sta $80
;skip2

	; draw one solid horizontal line
	sta WSYNC
	lda #$FF 
	sta PF0
	sta PF1
	sta PF2

	dey
	bne hloop
	jmp mloop

Init
	cld	; clear BCD math bit
	sei	; disable interrupts

	; clear PIA stuff
	ldx #$00
	ldy #$04
inLoop	stx $00,Y
	iny
	cpy #$20
	bne inLoop 

	; clear horiz motion regs
	stx $2B

	; clear input port switches (?)
	stx $0281
	stx $0283
	ldx #$00

	; set playfield properties
	lda #$01	; reflect
	sta CTRLPF

	rts

StartVFrame
	; start the vertical sync process
	ldy #$FF
	sty WSYNC
	sty VBLANK
	sty VSYNC

	; use the PIA timer to wait for
	; the vertical sync to finish
	lda #$2A
	sta $0295
wait1	ldy $0284
	bne wait1

	; stop vertical sync
	sty WSYNC
	sty VSYNC

	; we still need to generate more lines
	; of vertical blanking before starting
	; the next frame
	lda #$19
	sta $0296
wait2	ldy $0284
	bne wait2

	; stop vertical blanking
	sty WSYNC
	sty VBLANK

	rts

; pad rom to 4,098 bytes
	org $FFFC
	.word Main
	.word Main

