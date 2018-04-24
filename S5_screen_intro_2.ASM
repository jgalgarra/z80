; Exploarando la exótica memoria de pantalla del Spectrum.
; Pinta columnas en memoria de pantalla directamente
; Copia el primer tercio en el último de la pantalla con CopyMem

AppFilename             equ "S5_screen_intro_2"

AppFirst                equ $8000                       ; First byte of code (uncontended memory)

                        zeusemulate "48K","ULA+"        ; Set the model and enable ULA+


; Start planting code here. (When generating a tape file we start saving from here)

                        org AppFirst                    ; Start of application
                        jp AppEntry

DirPrimCar              EQU $4000                       ; $4000 Tercio superior
                                                        ; $4800 Tercio medio
                                                        ; 51000 Tercio inferior
DespHoriz               EQU 20                          ; Desplazamiento de la segunda columna


AppEntry:               ;ld HL,InicioColor              ;Ejemplo de color en el primer caracter de la pantalla
                        ;ld (HL),$A2
                        ld HL, DirPrimCar           ; Primer bit de la memoria de pantalla

                        LD B, (Dibujitos)               ; contador para de repeticion de dibujitos
Bucle                   LD (HL), Patron                 ; F0 hace que aparezca un guion
                        PUSH BC
                        CALL Delay
                        POP BC
                        LD DE,32
                        ADD HL,DE
                        DJNZ Bucle

                        LD HL, DirPrimCar+DespHoriz
                        LD B, (Dibujitos)               ; contador para de repeticion de dibujitos
Bucle2                  LD (HL), Patron                 ; F0 hace que aparezca un guion
                        PUSH BC
                        CALL Delay
                        POP BC
                        LD DE,32
                        ADD HL,DE
                        DJNZ Bucle2
                        CALL CopyMem
Para                    HALT
                        JP Para
                        RET

CopyMem:                push HL                         ;
                        LD HL,$4000                     ; Primer caracter
                        ld de,$4903                        ; when we use LDIR, DE is the destination address
                        LD BC,$700
                        ldir
                        pop HL
                        POP BC
                        RET

Delay                   ld b,1                         ; length of delay.
delay0                  halt                            ; wait for an interrupt.
                        djnz delay0                     ; loop.
                        ret                             ; return.

InicioPantalla          EQU $4000
InicioColor             EQU $5800
Dibujitos               EQU 56
Patron                  EQU $FE

; Stop planting code after this. (When generating a tape file we save bytes below here)
AppLast                 equ *-1                         ; The last used byte's address

; Generate some useful debugging commands

                        profile AppFirst,AppLast-AppFirst+1     ; Enable profiling for all the code

; Setup the emulation registers, so Zeus can emulate this code correctly

Zeus_PC                 equ AppEntry                            ; Tell the emulator where to start
Zeus_SP                 equ $FF40                               ; Tell the emulator where to put the stack

; These generate some output files

                        ; Generate a SZX file
                        output_szx AppFilename+".szx",$0000,AppEntry    ; The szx file

                        ; If we want a fancy loader we need to load a loading screen
;                        import_bin AppFilename+".scr",$4000            ; Load a loading screen

                        ; Now, also generate a tzx file using the loader
                        output_tzx AppFilename+".tzx",AppFilename,"",AppFirst,AppLast-AppFirst,1,AppEntry ; A tzx file using the loader


