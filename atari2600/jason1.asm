;  Test ROM for Atari 2600
;  to compile with using dasm,
;    dasm jason1.asm -f3

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

main
	; set up the stack
	ldx #$FF
	txs

	; one-timer init code
	jsr Init 

	; set colors
	lda #$C8
	sta COLUBK
	lda #$64
	sta COLUPF

	lda #$01	; set playfield reflect
	sta CTRLPF 
	lda #$01	; redundant?
	sta $E0		; a var in RAM 

	; this is the main loop
loop2	jsr StartVSync 
	jsr StopVSync 
	jsr StopVBlank
	; now starting a new frame
	ldy #$D2	; loop 210 times
loop1	sta WSYNC
	; starting a new horiz line
	lda $E0		; fetch var from RAM
	rol $E0		; var *= 2
	sta PF0		; drawing the playfield 
	sta PF1 
	sta PF2 	; still drawing, done!
	dey
	bne loop1
	jmp loop2

Init
	cld	; clear BCD math bit
	sei	; disable interrupts

	; messing with input port switches
	ldx #$00
	stx $0281
	stx $0283

	; clear memory $04 through $1F
	ldy #$04
loop3	stx $00,Y
	iny
	cpy #$20
	bne loop3

	stx $2B	; clear all horiz motion regs 
	rts

StartVSync
	ldy #$FF
	sty WSYNC 
	sty VBLANK
	sty VSYNC

        ; set the PIA timer
	lda #$2A
	sta $0295

	rts

StopVSync
	; wait for PIA timer
	ldy $0284
	bne StopVSync 

	sty WSYNC 
	sty VSYNC

        ; set the PIA timer
	lda #$19
	sta $0296

	rts

StopVBlank
	; wait for PIA timer
	ldy $0284
	bne StopVBlank

	sty WSYNC 
	sty VBLANK 
	rts

; pad rom to 4,098 bytes
	org $FFFC
	.word main
	.word main
