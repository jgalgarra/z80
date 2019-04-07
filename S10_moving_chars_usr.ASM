; Programa para imprimir en pantalla.

AppFilename             equ "S4_movingchars"            ;
AppFirst                equ $8000                       ; First byte of code (uncontended memory)

                        zeusemulate "48K","ULA+"        ; Set the model and enable ULA+


; Start planting code here. (When generating a tape file we start saving from here)

                        org AppFirst                    ; Start of application

AppEntry                ld a,2                          ; 2 = upper screen.
                        call CHANOPEN                   ; open channel.
principio               ld a,10                         ; row 10 = middle of screen.
                        ld (xcoord),a                   ; set initial x coordinate.
                        xor a
                        ld (ycoord),a
                        ld b,10
bucle                   push bc
                        call setxy                      ; set up our x/y coords.
                        ld hl,(text)
                        ld a,(text)                     ; want an X here.
                        rst 16                          ; display it.
                        call delay                      ; want a delay.
                        call setxy                      ; set up our x/y coords.
                        ld a,32                         ; ASCII code for space.
                        rst 16                          ; delete old X
                        call setxy                      ; set up our x/y coords.
                        ld hl,xcoord                    ; vertical position.
                        dec (hl)                        ; move it up one line.
                        ld de,(ycoord)                  ;
                        inc de
                        ld (ycoord), de
                        ld a,(ycoord)
                        pop bc
                        djnz bucle                        ;
                        jp principio
                        ret                             ;
delay                   ld b,10                         ; length of delay.
delay0                  halt                            ; wait for an interrupt.
                        djnz delay0                     ; loop.
                        ret                             ; return.
setxy                   ld a,22                         ; ASCII control code for AT.
                        rst 16                          ; print it.
                        ld a,(xcoord)                   ; vertical position.
                        rst 16                          ; print it.
                        ld a,(ycoord)                   ; y coordinate.
                        rst 16                          ; print it.
                        ret                             ;

xcoord                  defb 0                          ;
ycoord                  defb 15                         ;

CHANOPEN                equ 5633                        ;
PRINT                   equ 8252                        ;

Cuadradito              defb $7F,$41,$41,$41,$41,$41,$7F,$00
text                   defb "X"
textend                equ  $



; Stop planting code after this. (When generating a tape file we save bytes below here)
AppLast                 equ *-1                         ; The last used byte's address

; Generate some useful debugging commands

                        profile AppFirst,AppLast-AppFirst+1 ; Enable profiling for all the code

; Setup the emulation registers, so Zeus can emulate this code correctly

Zeus_PC                 equ AppEntry                    ; Tell the emulator where to start
Zeus_SP                 equ $FF40                       ; Tell the emulator where to put the stack

; These generate some output files

                        ; Generate a SZX file
                        output_szx AppFilename+".szx",$0000,AppEntry ; The szx file

                        ; If we want a fancy loader we need to load a loading screen
;                        import_bin AppFilename+".scr",$4000            ; Load a loading screen

                        ; Now, also generate a tzx file using the loader
                        output_tzx AppFilename+".tzx",AppFilename,"",AppFirst,AppLast-AppFirst,1,AppEntry ; A tzx file using the loader





