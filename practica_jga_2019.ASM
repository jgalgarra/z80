; Programa para imprimir en pantalla.

AppFilename             equ "Practica JGA"              ;
AppFirst                equ $8000                       ; First byte of code (uncontended memory)
                        zeusemulate "48K","ULA+"        ; Set the model and enable ULA+


; Start planting code here. (When generating a tape file we start saving from here)

                        org AppFirst                    ; Start of application

AppEntry                ld a,2                          ; 2 = upper screen.
                        call CHANOPEN                   ; open channel.
                        ld a,49                         ; tinta azul (1) con fondo amarillo (6 * 8).
                        ld (23693),a                    ; establecer nuestros colores de pantalla.
                        call 3503                       ; borrar la pantalla.
principio               ld a,10                         ; row 10 = middle of screen.
                        ld (pizda_ycoord),a             ; set initial x coordinate.
                        ld (pdcha_ycoord),a             ;
                        call InitPelota                 ;
                        LD A,"0"                        ;
                        LD (Mdcha+3),A                  ;
                        LD (Mizda+3),A                  ;
                        LD de,lineasup                  ;
                        LD bc,33                        ;
                        CALL PRINT                      ;
                        LD de,lineainf                  ;
                        LD bc,33                        ;
                        CALL PRINT                      ;

                        ld de,Mizda                     ; address of string
                        ld bc,4                         ; length of string to print
                        call PRINT                      ; print our string
                        ld de,Mdcha                     ; address of string
                        ld bc,4                         ; length of string to print
                        call PRINT                      ; print our string

                        ld de,MensEspacio               ; address of string
                        ld bc,33                        ; length of string to print
                        call PRINT                      ; print our string
                        CALL LeerEspacio                ;
                        ld de,BorraPto                  ; address of string
                        ld bc,33                        ; length of string to print
                        call PRINT                      ; print our strin

bucle                   CALL PintaPelota                ;

                        CALL MuevePelota                ;
                        CALL PalaDerecha                ;
                        CALL PalaIzquierda              ;
                        CALL delay                      ;

                        ; Códigos de teclado
                        ; FEFE,65278: V, C, X, Z, Caps Shift
                        ; FEFE,65278: 5, 4, 3, 2, 1
                        ;            b4 b3 b2 b1 b0
Teclado:                ld bc,0FEFEh                    ;
                        in a,(c)                        ;
                        rra                             ; b0 (Caps Shift)
                        rra                             ; b1 'Z'
                        push af                         ;
                        call nc,mvpala_izda_down        ;
                        pop af                          ;
                        rra                             ; b2 'X'
                        push af                         ;
                        call nc,mvpala_izda_up          ;
                        pop af                          ;
                        rra                             ; b3 'C'
                        push af                         ;
                        call nc,mvpala_dcha_down        ;
                        pop af                          ;
                        rra                             ; b4 'V'
                        push af                         ;
                        call nc,mvpala_dcha_up          ;
                        pop af                          ; ASCII code for space.
                        jp bucle                        ;
                        ret                             ;

delay                   ld b,10                         ; length of delay.
delay0                  halt                            ; wait for an interrupt.
                        djnz delay0                     ; loop.
                        ret                             ; return.

LeerEspacio             ld bc,07FFEh                    ;
                        in a,(c)                        ;
                        rra                             ; b0 (Space)
                        JP NC EspPuls                   ;
                        HALT                            ;
                        JP LeerEspacio                  ;
EspPuls                 ret                             ;

PalaDerecha             ld a,PDCHA_XCOORD               ;
                        ld (char_xcoord),a              ;
                        ld a,(pdcha_ycoord_old)         ;
                        ld (char_ycoord),a              ;
                        LD HL,textw                     ;
                        LD (dir_string),HL              ;
                        CALL PintaCar                   ;
                        ld a,PDCHA_XCOORD               ;
                        ld (char_xcoord),a              ;
                        ld a,(pdcha_ycoord_old)         ;
                        INC A                           ;
                        ld (char_ycoord),a              ;
                        LD HL,textw                     ;
                        LD (dir_string),HL              ;
                        CALL PintaCar                   ;
                        ld a,PDCHA_XCOORD               ;
                        ld (char_xcoord),a              ;
                        ld a,(pdcha_ycoord)             ;
                        ld (char_ycoord),a              ;
                        LD HL,pala                      ;
                        LD (dir_string),HL              ;
                        CALL PintaCar                   ;
                        ld a,(pdcha_ycoord)             ;
                        ld (pdcha_ycoord_old),a         ;
                        ld a,PDCHA_XCOORD               ;
                        ld (char_xcoord),a              ;
                        ld a,(pdcha_ycoord)             ;
                        inc a                           ;
                        ld (char_ycoord),a              ;
                        LD HL,pala_baja                 ;
                        LD (dir_string),HL              ;
                        CALL PintaCar                   ;
                        ret                             ;

PalaIzquierda           ld a,PIZDA_XCOORD               ;
                        ld (char_xcoord),a              ;
                        ld a,(pizda_ycoord_old)         ;
                        ld (char_ycoord),a              ;
                        LD HL,textw                     ;
                        LD (dir_string),HL              ;
                        CALL PintaCar                   ;
                        ld a,PIZDA_XCOORD               ;
                        ld (char_xcoord),a              ;
                        ld a,(pizda_ycoord_old)         ;
                        INC A                           ;
                        ld (char_ycoord),a              ;
                        LD HL,textw                     ;
                        LD (dir_string),HL              ;
                        CALL PintaCar                   ;
                        ld a,PIZDA_XCOORD               ;
                        ld (char_xcoord),a              ;
                        ld a,(pizda_ycoord)             ;
                        ld (char_ycoord),a              ;
                        LD HL,pala                      ;
                        LD (dir_string),HL              ;
                        CALL PintaCar                   ;
                        ld a,(pizda_ycoord)             ;
                        ld (pizda_ycoord_old),a         ;
                        ld a,PIZDA_XCOORD               ;
                        ld (char_xcoord),a              ;
                        ld a,(pizda_ycoord)             ;
                        inc a                           ;
                        ld (char_ycoord),a              ;
                        LD HL,pala_baja                 ;
                        LD (dir_string),HL              ;
                        CALL PintaCar                   ;
                        ret                             ;

InitPelota              ld A,10                         ;
                        ld (pelota_ycoord),a            ;
                        ld (pelota_ycoord_old),a        ;
                        LD A,R                          ;
                        AND %0000011                    ;
                        ADD 12                          ;
                        ld (pelota_xcoord),a            ;
                        ld (pelota_xcoord_old),a        ;
                        RET                             ;

PintaPelota             call BorraPelota                ;
                        ld a,(pelota_xcoord)            ;
                        ld (char_xcoord),a              ;
                        ld a,(pelota_ycoord)            ;
                        ld (char_ycoord),a              ;
                        LD HL,pelota                    ;
                        LD (dir_string),HL              ;
                        CALL PintaCar                   ;
                        ld a,(pelota_ycoord)            ;
                        ld (pelota_ycoord_old),a        ;
                        ld a,(pelota_xcoord)            ;
                        ld (pelota_xcoord_old),a        ;
                        ret                             ;

BorraPelota             ld a,(pelota_xcoord_old)        ;
                        ld (char_xcoord),a              ;
                        ld a,(pelota_ycoord_old)        ;
                        ld (char_ycoord),a              ;
                        LD HL,textw                     ;
                        LD (dir_string),HL              ;
                        CALL PintaCar                   ;
                        RET                             ;

MuevePelota             LD A,R                          ;
                        OR %00000001                    ;
                        RET Z                           ;
                        ld a,(pelota_xcoord)            ;
                        CP RIGHT                        ;
                        JP NZ SR                        ;
                        LD A,(pdcha_ycoord)             ;
                        LD DE,(pelota_ycoord)           ;
                        CP D                            ;
                        JP Z VHoriz                     ;
                        DEC D                           ;
                        CP D                            ;
                        JP Z VHoriz                     ;
                        ld de,PtoIzda                   ;
                        ld bc,32                        ;
                        call PRINT                      ;
                        LD IX,Mizda                     ;
                        CALL SumaPunto                  ;
                        ld de,BorraPto                  ;
                        ld bc,32                        ;
                        call PRINT                      ;
VHoriz                  CALL VueltaHoriz                ;
SR                      ld a,(pelota_xcoord)            ;
                        CP LEFT                         ;
                        JP NZ SRLeft                    ;
                        LD A,(pizda_ycoord)             ;
                        LD DE,(pelota_ycoord)           ;
                        CP D                            ;
                        JP Z VHorizL                    ;
                        DEC D                           ;
                        CP D                            ;
                        JP Z VHorizL                    ;
                        ld de,PtoDcha                   ;
                        ld bc,32                        ;
                        call PRINT                      ;
                        LD IX,Mdcha                     ;
                        CALL SumaPunto                  ;
                        ld de,BorraPto                  ;
                        ld bc,32                        ;
                        call PRINT                      ;


VHorizL                 CALL VueltaHoriz                ;
SRLeft                  ld a,(pelota_ycoord)            ;
                        CP TOP                          ;
                        CALL Z VueltaVert               ;
                        ld a,(pelota_ycoord)            ;
                        CP DOWN                         ;
                        CALL Z VueltaVert               ;
Sigue                   ld a,(pelota_xcoord)            ;
                        LD DE,(pasox)                   ;
                        ADD E                           ;
                        ld (pelota_xcoord),a            ;
                        ld a,(pelota_ycoord)            ;
                        LD DE,(pasoy)                   ;
                        ADD E                           ;
                        ld (pelota_ycoord),a            ;

                        ret                             ;

VueltaHoriz             LD A,(pasox)                    ;
                        NEG                             ;
                        LD (pasox),A                    ;
SalVH                   RET                             ;

VueltaVert              LD A,(pasoy)                    ;
                        NEG                             ;
                        LD (pasoy),A                    ;
                        RET                             ;

PintaCar                LD IX,(dir_string)              ;
                        ld a,22                         ;
                        ld (IX),a                       ;
                        ld a,(char_ycoord)              ; x coordinate.
                        ld (IX+1),a                     ;
                        ld a,(char_xcoord)              ;
                        ld (IX+2),a                     ;
                        ld de,IX                        ; string con coordenadas del caracter
                        ld bc,4                         ;
                        CALL PRINT                      ;
                        ret                             ;



mvpala_izda_down        nop                             ;
                        ld hl,pizda_ycoord              ;
                        ld a,(hl)                       ;
                        cp DOWN-1                       ; ¿Estamos abajo?
                        ret nc                          ;
                        inc (hl)                        ;
                        ret                             ;

mvpala_izda_up          nop                             ;
                        ld hl,pizda_ycoord              ;
                        ld a,(hl)                       ;
                        cp TOP+1                        ; ¿Estamos en la izquierda?
                        ret c                           ;
                        dec (hl)                        ;
                        ret                             ;

mvpala_dcha_down        nop                             ;
                        ld hl,pdcha_ycoord              ;
                        ld a,(hl)                       ;
                        cp DOWN-1                       ; ¿Estamos abajo?
                        ret nc                          ;
                        inc (hl)                        ;
                        ret                             ;

mvpala_dcha_up          nop                             ;
                        ld hl,pdcha_ycoord              ;
                        ld a,(hl)                       ;
                        cp TOP+1                        ;
                        ret c                           ;
                        dec (hl)                        ;
                        ret                             ;

SumaPunto               LD A,(IX+3)                     ;
                        INC A                           ;
                        LD (IX+3),A                     ;
                        ld de,IX                        ; address of string
                        ld bc,4                         ; length of string to print
                        call PRINT                      ; print our string
                        LD A,(IX+3)                     ;
                        CP "3"                          ;
                        JP NZ SigueJugando              ;
                        call BorraPelota                ;
                        LD de,GameOver                  ;
                        LD bc,33                        ;
                        CALL PRINT                      ; ´
                        call delay                      ;
                        call delay                      ;
                        ld de,MensEspacio               ; address of string
                        ld bc,33                        ; length of string to print
                        call PRINT                      ; print our string
                        CALL LeerEspacio                ;
                        LD de,BorraGameOver             ;
                        LD bc,33                        ;
                        CALL PRINT                      ;
                        JP principio                    ;
Para                    HALT                            ;
                        JP Para                         ;
SigueJugando            call BorraPelota                ;
                        call InitPelota                 ;
                        LD A,10                         ;
retardopunto            call delay                      ;
                        DEC A                           ;
                        CP 0                            ;
                        JP NZ retardopunto              ;
                        RET                             ;

PIZDA_XCOORD            equ 0                           ;
pizda_ycoord            defb 0                          ;
pizda_ycoord_old        defb 0                          ;

PDCHA_XCOORD            equ 31                          ;
pdcha_ycoord            defb 0                          ;
pdcha_ycoord_old        defb 0                          ;

pelota_xcoord           defb 0                          ;
pelota_xcoord_old       defb 0                          ;
pelota_ycoord           defb 0                          ;
pelota_ycoord_old       defb 0                          ;

char_ycoord             defb 0                          ;
char_xcoord             defb 0                          ;
dir_string              defw 0                          ;

pasox                   defb 1                          ;
pasoy                   defb 1                          ;
rnum                    defb 0                          ;
puntos_izda             defb 0                          ;
puntos_dcha             defb 0                          ;

RIGHT                   equ 31                          ;
LEFT                    equ 0                           ;
TOP                     equ 1                           ;
DOWN                    equ 20                          ;
CHANOPEN                equ 5633                        ;
PRINT                   equ 8252                        ;

pala                    defb 22,0,0,"0"                 ;
pala_baja               defb 22,0,0,"|"                 ;

lineasup                defb 22,0,1,"_________________________________";
lineainf                defb 22,21,1,"----------------------------------";
GameOver                defb 22,9,1,"          GAME OVER               ";
PtoIzda                 defb 22,10,1,"    PUNTO PARA LA IZQUIERDA       ";
PtoDcha                 defb 22,10,1,"    PUNTO PARA LA DERECHA         ";
BorraPto                defb 22,10,1,"                                  ";
BorraGameOver           defb 22,9,1,"                                  ";
MensEspacio             defb 22,10,1,"  PULSA ESPACIO PARA JUGAR        ";

pelota                  defb 22,0,0,"o"                 ;

textw                   defb 22,0,0," "                 ;

Mizda                   defb 22,0,1,"0"                 ;
Mdcha                   defb 22,0,30,"0"                ;

Borra                   defb 1                          ;

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



