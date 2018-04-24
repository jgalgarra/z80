; Programa para imprimir en pantalla.

AppFilename             equ "S5_teclas"       ;
AppFirst                equ $8000                       ; First byte of code (uncontended memory)
                        zeusemulate "48K","ULA+"        ; Set the model and enable ULA+


; Start planting code here. (When generating a tape file we start saving from here)

                        org AppFirst                    ; Start of application

AppEntry                ld a,2                          ; 2 = upper screen.
                        call CHANOPEN                   ; open channel.
principio               ld a,10                         ; row 10 = middle of screen.
                        ld (ycoord),a                   ; set initial x coordinate.
                        ld a,15                         ;
                        ld (xcoord),a                   ;
                        ld b,5                          ;
bucle                   ld a,(xcoord)
                        ld (xcoord_old),a
                        ld a,(ycoord)
                        ld (ycoord_old),a
                        push bc                         ;
                        call setxy                      ; set up our x/y coords.
                        ld hl,(text)                    ;
                        ld a,(text)                     ; Pintamos el caracter
                        rst 16                          ; display it.
                        call delay                      ; retardo.
                        ld a,(Borra)                      ; Indica si queremos borrar el rastro en pantalla
                        cp 1
                        jp nz, Teclado
                        ld a,(xcoord)
                        ld (xcoord_old),a
                        ld a,(ycoord)
                        ld (ycoord_old),a
                                                 ;
                        call setxy                      ; set up our x/y coords.

                        ld hl,(textw)                    ;
                        ld a,(textw)                     ; want an X here.
                        rst 16
                                                         ; Códigos de teclado
                                                         ; FEFE,65278: V, C, X, Z, Caps Shift
                                                         ; FEFE,65278: 5, 4, 3, 2, 1
                                                         ;            b4 b3 b2 b1 b0
Teclado:                ld bc,0FEFEh                    ;
                        in a,(c)                        ;
                        rra                             ; b0 (Caps Shift)
                        rra                             ; b1 'Z'
                        push af                         ;
                        call nc,mvcaracter_left         ;
                        pop af                          ;
                        rra                             ; b2 'X'
                        push af                         ;
                        call nc,mvcaracter_right        ;
                        pop af                          ;
                        rra                             ; b3 'C'
                        push af                         ;
                        call nc,mvcaracter_up           ;
                        pop af                          ;
                        rra                             ; b4 'V'
                        push af                         ;
                        call nc,mvcaracter_down          ;
                        pop af                          ;

                        ld a,32                         ; ASCII code for space.
                        jp bucle                        ;
                        ret                             ;
delay                   ld b,10                         ; length of delay.
delay0                  halt                            ; wait for an interrupt.
                        djnz delay0                     ; loop.
                        ret                             ; return.
setxy                   ld a,22                         ; ASCII control code for AT.
                        rst 16                          ; print it.
                        ld a,(ycoord)                   ; vertical position.
                        rst 16                          ; print it.
                        ld a,(xcoord)                   ; x coordinate.
                        rst 16                          ; print it.
                        ret                             ;

; Mover jugador a la izquierda.
mvcaracter_left         nop                             ;
                        ld hl,xcoord                    ;
                        ld a,(hl)                       ;
                        cp 1                            ; ¿Estamos en la izquierda?
                        ret c                           ;
                        dec (hl)
                        ret                             ;

; Mover jugador a la derecha.
mvcaracter_right        nop                             ;
                        ld hl,xcoord                    ;
                        ld a,(hl)                       ;
                        cp 31                           ; ¿Estamos en el borde derecho?
                        ret nc                          ;
                        inc (hl)                        ;
                        ret                             ;

mvcaracter_down           nop                             ;
                        ld hl,ycoord                    ;
                        ld a,(hl)                       ;
                        cp 21                           ; ¿Estamos abajo?
                        ret nc                          ;
                        inc (hl)                        ;
                        ret

mvcaracter_up         nop                             ;
                        ld hl,ycoord                    ;
                        ld a,(hl)                       ;
                        cp 1                            ; ¿Estamos en la izquierda?
                        ret c                           ;
                        dec (hl)
                        ret                             ;

xcoord                  defb 0                          ;
ycoord                  defb 0                          ;
xcoord_old              defb 0                          ;
ycoord_old              defb 0                          ;

CHANOPEN                equ 5633                        ;
PRINT                   equ 8252                        ;

text                    defb "X"                        ;
textend                 equ $                           ;

textw                   defb " "                        ;
textwend                equ $

Borra                   defb 1;

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




